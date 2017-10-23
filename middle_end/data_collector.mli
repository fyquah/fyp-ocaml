[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type t = { call_stack : Call_site.t list; decision : bool }

val inlining_decisions : t list ref

val save : output_prefix: string -> unit
