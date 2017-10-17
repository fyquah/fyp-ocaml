let output_ref = ref ""

type symbol = string

type loc = (string * int)

type overhead = string

type top_level_entry =
  { overhead : overhead;
    loc      : loc;
    symbol   : symbol;
  }

type t =
  | Pending
  | Filled (overhead * (symbol * loc) list * t) list

type state =
  | Top_level

let parse_loc s =
  match String.split_on_char ':' s with
  | source :: loc -> (source, int_of_string loc)
  | _ -> failwith (Format.sprintf "Cannot parse loc string %s" s)
;;

let parse_report filename =
  if !output_ref = "" then begin
    output_ref := filename ^ ".parsed"
  end;
  Format.printf "File : %s" filename;
  let ic = open_in filename in
  let rec loop ~state ~acc =
    try
      let line = input_line ic in
      if String.get line 0 = '#' then begin
        loop ~acc
      end else begin match state with
      | Top_level ->
        let segments =
          List.filter (fun s -> String.length s = 0)
            (String.split_on_char ' ')
        in
        begin match segments with
        | overhead :: loc :: symbol :: _ :: _object :: [] ->
          let loc = parse_loc loc in
          let tos = Filled (overhead, [(symbol, loc)], Pending) in
          loop ~state ~acc:(tos :: acc)
        | _ -> failwith (Format.sprintf "Parser error at line %s" line)
        end
      end
      Format.printf "-> %s" line;
      loop ~acc:(line :: acc)
    with End_of_file -> acc
  in
  ignore (loop ~acc:[])
;;

let arg_list = [ "-output", Arg.Set_string output_ref, " output file" ]

let main() =
  let arg_usage =
    Printf.sprintf "%s -output PATH FILE : parse a perf report to ocaml object."
      Sys.argv.(0)
  in
  Arg.parse_expand arg_list parse_report arg_usage;
;;

let _ = main ()
