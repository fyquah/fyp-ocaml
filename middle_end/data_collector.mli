[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type call_site =
  { closure_id  : Closure_id.t;
    location_id : int;
  }

type t = { call_stack : call_site list; decision : bool }

val inlining_decisions : t list ref

val save : output_prefix: string -> unit
