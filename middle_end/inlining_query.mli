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

val extract_v0_features : query -> Feature_extractor.t
