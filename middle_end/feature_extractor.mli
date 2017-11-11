[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type call_context =
  | Conditional_branch
  | String_switch_branch
  | Switch_int_branch
  | Switch_block_branch
  | Switch_failaction_branch
  | Imperative_loop
  | In_try_block
  | In_catch_block
  | Inlined_function
  | In_function_declaration

type t =
  { (* callee features *)
    bound_vars_to_symbol             : int;
    assign                           : int;
    bound_vars_to_mutable            : int;
    bound_vars                       : int;
    free_vars                        : int;
    free_symbols                     : int;
    set_of_closures                  : int;
    is_a_functor                     : bool;
    non_specialized_args             : int;
    specialized_args                 : int;
    size                             : int;
    underlying_direct_applications   : int;
    underlying_indirect_applications : int;
    is_recursive                     : bool;
    expected_allocations             : float option;
    is_annonymous                    : bool;
    if_then_else                     : int;
    switch                           : int;
    string_switch                    : int;

    (* caller features *)
    call_context_stack               : call_context list;
    direct_call                      : bool;
    recursive_call                   : bool;

    (* environment features -- this is same for all siblings *)
    inlining_depth                   : int;
    closure_depth                    : int;
    in_recursive_function            : bool;
    original_function_size           : int option;
    original_bound_vars              : int option;
    flambda_round                    : int;
  }

val empty
   : is_a_functor: bool
  -> is_recursive : bool
  -> is_annonymous: bool
  -> call_context_stack: call_context list
  -> direct_call: bool
  -> recursive_call: bool
  -> inlining_depth: int
  -> closure_depth: int
  -> in_recursive_function: bool
  -> original_function_size: int option
  -> original_bound_vars: int option
  -> flambda_round: int
  -> t
