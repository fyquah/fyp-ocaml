type t =
  | Atom of string
  | List of t list

val print_mach : Format.formatter -> t -> unit
