[@@@ocaml.warning "+a-4-9-30-40-41-42"]

module E = Inline_and_simplify_aux.Env
module W = Inlining_cost.Whether_sufficient_benefit
module R = Inline_and_simplify_aux.Result

type scope = Current | Outer

type inlined_result =
  { r                        : Inline_and_simplify_aux.Result.t;
    body                     : Flambda.t;
  }

type query =
  { function_decl            : Flambda.function_declaration;
    closure_id_being_applied : Closure_id.t;
    env                      : Inline_and_simplify_aux.Env.t;
    r                        : Inline_and_simplify_aux.Result.t;
    apply_id                 : Apply_id.t;
    original                 : Flambda.t;
    inlined_result           : inlined_result;
    call_kind                : Flambda.call_kind;
    value_set_of_closures    : Simple_value_approx.value_set_of_closures;
    only_use_of_function     : bool;
  }

let hd_opt a =
  match a with
  | [] -> None
  | hd :: _ -> Some hd


let rec find_substring haystack needle =
  if String.length haystack < String.length needle then
    false
  else if
    String.equal needle (String.sub haystack 0 (String.length needle))
  then
    true
  else
    find_substring (String.sub haystack 1 (String.length haystack - 1))
      needle
;;


let extract_features 
    ~(kind : Flambda.call_kind)
    ~(closure_id : Closure_id.t)
    ~(env : E.t)
    ~(function_decl : Flambda.function_declaration)
    ~(value_set_of_closures: Simple_value_approx.value_set_of_closures)
    ~(size_before_simplify : int)
    ~(size_after_simplify  : int)
    ~(flambda_tries: bool)
    ~(flambda_wsb: Feature_extractor.wsb)
    ~only_use_of_function
    ~(apply_id: Apply_id.t) =
  let function_decls = value_set_of_closures.function_decls in
  let is_annonymous =
    find_substring
      (Format.asprintf "%a" Closure_id.print closure_id)
      "anon-fn"
  in
  let direct_call =
    match kind with
    | Indirect -> true
    | Direct _ -> false
  in
  let in_recursive_function =
    match
      E.actively_unrolling env function_decls.set_of_closures_origin
    with
    | None -> false
    | Some _ -> true
  in
  let original_function_size =
    hd_opt (E.original_function_size_stack env)
  in
  let recursive_call =
    match E.inlining_stack env with
    | [] -> false
    | Call_site.Enter_decl { closure = current; _ } :: _
    | Call_site.At_call_site { applied = current ; _ } :: _ ->
      Closure_id.equal closure_id current
  in
  let module DC = Data_collector in
  let trace =
    let trace =
      List.map (fun trace_item ->
          match trace_item with
          | DC.Trace_item.Enter_decl decl ->
              Feature_extractor.Decl decl.declared.closure_origin
          | DC.Trace_item.At_call_site acs ->
              Feature_extractor.Apply acs.apply_id)
        (E.inlining_trace env)
    in
    List.rev (Feature_extractor.Apply apply_id :: trace)
  in
  let call_context_stack = E.call_context_stack env in
  let original_bound_vars = hd_opt (E.original_bound_vars_stack env) in
  let flambda_round = E.round env in
  let params = function_decl.params in
  let init =
    Feature_extractor.empty
      ~size_before_simplify
      ~size_after_simplify
      ~flambda_tries
      ~params:(List.length params)
      ~is_a_functor:function_decl.is_a_functor
      ~is_recursive:(Variable.Map.cardinal function_decls.funs > 1)
      ~is_annonymous
      ~call_context_stack
      ~direct_call
      ~recursive_call
      ~inlining_depth:(E.inlining_level env)
      ~in_recursive_function
      ~original_function_size
      ~original_bound_vars
      ~flambda_round
      ~flambda_wsb
      ~closure_depth:(E.closure_depth env)
      ~trace
      ~only_use_of_function
  in
  let init =
    let free_vars =
      Variable.Set.cardinal function_decl.free_variables - List.length params
    in
    let free_symbols = Symbol.Set.cardinal function_decl.free_symbols in
    let specialized_args =
      Variable.Map.fold
        (fun var _ acc ->
          if List.exists (fun param ->
            Variable.equal (Parameter.var param) var) params
          then acc else acc + 1)
        value_set_of_closures.specialised_args 0
    in
    let non_specialized_args = List.length params - specialized_args in
    { init with
      size_after_simplify;
      size_before_simplify;
      free_vars;
      free_symbols;
      specialized_args;
      non_specialized_args;
    }
  in
  let (state : Feature_extractor.t ref) = ref init in
  (* TODO(fyquah): Complete this *)
  let on_named ~(state : Feature_extractor.t) (named: Flambda.named) =
    begin match named with
    | Symbol _ ->
      { state with
        bound_vars_to_symbol = state.bound_vars_to_symbol + 1 };
    | Set_of_closures _ ->
      { state with
        set_of_closures = state.set_of_closures + 1
      }
    | Const _
    | Allocated_const _
    | Read_mutable _
    | Read_symbol_field _
    | Project_closure _
    | Move_within_set_of_closures _
    | Project_var _
    | Prim _
    | Expr _ -> state
    end
  in
  Flambda_iterators.iter_toplevel
    (fun (t : Flambda.t) ->
       let (current : Feature_extractor.t) = !state in
       match t with
       | Var _ -> ()
       | Let let_expr ->
         let current =
           { current with bound_vars = current.bound_vars + 1 }
         in
         state := on_named ~state:current let_expr.defining_expr
       | Let_mutable _ ->
         let current =
           { current with
             bound_vars_to_mutable = current.bound_vars_to_mutable + 1;
             bound_vars = current.bound_vars + 1;
           }
         in
         state := current
       | Let_rec (let_rec_expr, _) ->
         let current =
           { current with bound_vars = current.bound_vars + List.length let_rec_expr }
         in
         state :=
           List.fold_left (fun state (_var, named) ->
                 on_named ~state named)
             current let_rec_expr
       | Apply apply ->
         let current =
           match apply.kind with
           | Indirect ->
             { current with
               underlying_indirect_applications = current.underlying_indirect_applications + 1 }
           | Direct _ ->
             { current with
               underlying_direct_applications = current.underlying_direct_applications + 1 }
         in
         state := current
       | Switch _ ->
         let current = { current with switch = current.switch + 1 } in
         state := current
       | String_switch _ ->
         let current =
           { current with string_switch = current.string_switch + 1 }
         in
         state := current
       | If_then_else _ ->
         let current =
           { current with if_then_else = current.if_then_else + 1 }
         in
         state := current
       | Assign _ ->
         let current = { current with assign = current.assign + 1 } in
         state := current

       | Send _
       | Static_raise _
       | Static_catch _
       | Try_with _
       | While _
       | For _
       | Proved_unreachable ->
         ()
    )
    (fun (_named : Flambda.named) -> ())
    function_decl.body;
  !state
;;

let extract_v0_features query =
  let {
    original;
    function_decl;
    env;
    r = _;
    apply_id;
    inlined_result;
    closure_id_being_applied;
    call_kind = kind;
    value_set_of_closures;
    only_use_of_function;
  } = query in
  let size_before_simplify =
    Inlining_cost.lambda_size function_decl.body
  in
  let flambda_wsb =
    let whether_sufficient_benefit =
      W.create ~original inlined_result.body
        ~toplevel:(E.at_toplevel env)
        ~branch_depth:(E.branch_depth env)
        ~lifting:function_decl.Flambda.is_a_functor
        ~round:(E.round env)
        ~benefit:(R.benefit inlined_result.r)
    in
    W.to_feature_extractor_wsb whether_sufficient_benefit
  in
  let closure_id = closure_id_being_applied in
  let base_features =
    extract_features ~kind ~closure_id ~env ~function_decl
      ~size_before_simplify ~size_after_simplify:size_before_simplify
      ~value_set_of_closures ~flambda_tries:false ~flambda_wsb ~apply_id
      ~only_use_of_function
  in
  let size_after_simplify =
    Inlining_cost.lambda_size inlined_result.body
  in
  { base_features with size_after_simplify }
;;
