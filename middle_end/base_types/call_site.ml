[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type offset = int

type t =
  { closure_id : Closure_id.t option;
    offset     : offset;
  }

let base_offset = 0

let inc offset = offset + 1

let create_top_level offset = { closure_id = None; offset }

let create closure_id offset = { closure_id = Some closure_id; offset; }

let print_closure_id_option ppf = function
  | None -> Format.fprintf ppf "<Top_level>"
  | Some closure_id -> Format.fprintf ppf "%a" Closure_id.print closure_id
;;

let print_mach ppf t =
  Format.fprintf ppf "%a:%d"
    print_closure_id_option t.closure_id t.offset
