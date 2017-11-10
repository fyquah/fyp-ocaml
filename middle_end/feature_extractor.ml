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

let empty
    (* callee information *)
    ~is_a_functor ~is_recursive ~is_annonymous

    (* caller information *)
    ~indirect_call ~in_imperative_loop ~in_conditional_expression ~bound_vars_in_scope

    (* env information *)
    ~inlining_depth ~closure_depth ~in_recursive_function
    ~original_function_size ~original_bound_vars
  =
  { (* callee features *)
    bound_vars_to_symbol             = 0;
    assign                           = 0;
    bound_vars_to_mutable            = 0;
    free_vars                        = 0;
    free_symbols                     = 0;
    set_of_closures                  = 0;
    is_a_functor                     ;
    non_specialized_args             = 0;
    specialized_args                 = 0;
    size                             = 0;
    underlying_direct_applications   = 0;
    underlying_indirect_applications = 0;
    is_recursive                     ;
    expected_allocations             = None;
    is_annonymous                    ;
    if_then_else                     = 0;
    switch                           = 0;
    string_switch                    = 0;

    (* caller features *)
    indirect_call                    ;
    in_imperative_loop               ;
    in_conditional_expression        ;
    (* refers to ocaml [while] or [for] loops *)
    bound_vars_in_scope              ;

    (* environment features -- this is same for all siblings *)
    inlining_depth                   ;
    closure_depth                    ;
    in_recursive_function            ;
    original_function_size           ;
    original_bound_vars              ;
  }
