[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type offset
type t

val base_offset : offset

val inc : offset -> offset

val enter_decl : Closure_id.t -> t

val create_top_level : offset -> t

val create : Closure_id.t -> offset -> t

val print_mach : Format.formatter -> t -> unit

val of_string : string -> t
