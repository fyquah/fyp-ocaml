[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type offset = int

type t =
  { closure_id : Closure_id.t;
    offset     : offset;
  }

let base_offset = 0

let inc offset = offset + 1

let create closure_id offset = { closure_id; offset; }

let print_mach ppf t =
  Format.fprintf ppf "%a:%d"
    Closure_id.print t.closure_id t.offset
