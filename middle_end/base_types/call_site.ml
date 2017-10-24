[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type offset = int

type at_call_site =
  { closure_id : Closure_id.t option;
    offset     : offset;
  }

type t =
  | Enter_decl of Closure_id.t
  | At_call_site of at_call_site

let base_offset = 0

let inc offset = offset + 1

let enter_decl closure_id = Enter_decl closure_id

let create_top_level offset =
  At_call_site { closure_id = None; offset }
;;

let create closure_id offset =
  At_call_site { closure_id = Some closure_id; offset; }
;;

let print_closure_id_option ppf = function
  | None -> Format.fprintf ppf "TOP_LEVEL"
  | Some closure_id -> Format.fprintf ppf "%a" Closure_id.print closure_id
;;

let print_mach ppf = function
  | At_call_site at_call_site ->
    Format.fprintf ppf "%a:%d"
      print_closure_id_option at_call_site.closure_id at_call_site.offset
  | Enter_decl closure_id ->
    Format.fprintf ppf "{%a}" Closure_id.print closure_id
