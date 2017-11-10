[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type t =
  { (* callee features *)
    bound_vars_to_symbol             : int;
    assign                           : int;
    bound_vars_to_mutable            : int;
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
    indirect_call                    : bool;
    in_imperative_loop               : bool;
    in_conditional_expression        : bool;
    (* refers to ocaml [while] or [for] loops *)
    bound_vars_in_scope              : int;

    (* environment features -- this is same for all siblings *)
    inlining_depth                   : int;
    closure_depth                    : int;
    in_recursive_function            : bool;
    original_function_size           : int option;
    original_bound_vars              : int option;
  }

val empty
   : is_a_functor: bool
  -> is_recursive : bool
  -> is_annonymous: bool
  -> indirect_call: bool
  -> in_imperative_loop: bool
  -> in_conditional_expression: bool
  -> bound_vars_in_scope: int
  -> inlining_depth: int
  -> closure_depth: int
  -> in_recursive_function: bool
  -> original_function_size: int option
  -> original_bound_vars: int option
  -> t
