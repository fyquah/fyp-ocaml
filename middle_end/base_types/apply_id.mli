[@@@ocaml.warning "+a-4-9-30-40-41-42"]

(** [Variable.t] is the equivalent of a non-persistent [Ident.t] in
    the [Flambda] tree.  It wraps an [Ident.t] together with its source
    [compilation_unit].  As such, it is unique within a whole program,
    not just one compilation unit.

    Introducing a new type helps in tracing the source of identifiers
    when debugging the inliner.  It also avoids Ident renaming when
    importing cmx files.
*)

type label =
  | Plain_apply
  | Over_application

include Identifiable.S

val create : ?current_compilation_unit:Compilation_unit.t -> label -> t

val with_label : t -> label -> t

val in_compilation_unit : t -> Compilation_unit.t -> bool

val get_compilation_unit : t -> Compilation_unit.t

val print : Format.formatter -> t -> unit
