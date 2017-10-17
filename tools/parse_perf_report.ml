open Pgo

type raw_lines =
  { offset   : int;
    overhead : string option;
    symbol   : string;
    location : loc;
  }

type parser_stack =
  | Terminal
  | Transient of parser_stack
  | Done of t * parser_stack
  | Parsing of string * int * (symbol * loc) list * parser_stack
  | Exhausted of top_level

let output_ref = ref ""

let rec print_stack ppf (stack : parser_stack) =
  let fprintf = Format.fprintf in
  match stack with
  | Terminal -> fprintf ppf "- Terminal\n"
  | Transient next -> fprintf ppf "- Transient\n"; print_stack ppf next
  | Done (_, next) -> fprintf ppf "- Done\n"; print_stack ppf next
  | Parsing (_, _, occurences, next) ->
    fprintf ppf "- Parsing (%a)\n"
      (Format.pp_print_list ~pp_sep:(fun ppf () -> Format.fprintf ppf "; ")
         (fun ppf (symbol, (filename, line_no)) ->
            Format.fprintf ppf "[%s %s:%d]" symbol filename line_no))
      occurences;
    print_stack ppf next
  | Exhausted _ -> fprintf ppf "- Exhausted\n"
;;

let print_top_level ppf (top_level : top_level) =
  let rec loop ~offset (t : t) =
    let print_margin () =
      for _ = 1 to offset do
        Format.fprintf ppf "    ";
      done
    in
    print_margin ();
    Format.fprintf ppf "%s:\n" t.overhead;
    List.iter (fun (symbol, (source, line)) ->
        print_margin ();
        Format.fprintf ppf "- %s [%s:%d]\n" symbol source line)
      t.call_stack;
    List.iter (fun child -> loop ~offset:(offset + 1) child)
      t.children
  in
  List.iter (fun t -> loop ~offset:0 t; Format.fprintf ppf "\n")
    top_level
;;

let parsing_to_done ~descent stack =
  let rec loop i s ~children =
    if i >= descent then
      s
    else begin
      match s with
      | Terminal -> Exhausted children
      | Done (t, ros) ->
        let children = t :: children in
        loop i ros ~children
      | Parsing (overhead, _offset, call_stack, ros) ->
        let children = children in
        let t = { overhead; call_stack; children } in
        loop (i + 1) (Done (t, ros)) ~children:[]
      | _ -> failwith "What the fuck"
    end
  in
  loop 0 stack ~children:[]
;;

let parse_lines =
  let rec walk ~stack (lines : raw_lines list) =
    match stack with
    | Transient ros ->
      begin match lines with
      | hd :: tl ->
        begin match hd.overhead with
        | None ->
          failwith (
            Format.sprintf "What the actual fuck %s %s:%d"
              hd.symbol (fst hd.location) (snd hd.location)
          )
        | Some overhead ->
          walk tl ~stack:(
            Parsing (overhead, hd.offset, [(hd.symbol, hd.location)], ros))
        end
      | [] -> failwith "Unexpected"
      end
    | Parsing (acc_overhead, acc_offset, acc, ros) ->
      begin match lines with
      | hd :: tl ->
        if hd.offset = acc_offset then
          begin match hd.overhead with
          | Some _overhead ->
            let stack = parsing_to_done ~descent:1 stack in
            let stack = Transient stack in
            walk lines ~stack
          | None ->
            let acc = (hd.symbol, hd.location) :: acc in
            walk tl ~stack:(Parsing (acc_overhead, acc_offset, acc, ros))
          end
        else if hd.offset > acc_offset then
          let stack = Transient stack in
          walk lines ~stack
        else if hd.offset < acc_offset then
          let descent = (acc_offset - hd.offset) + 1 in
          let stack = parsing_to_done ~descent stack in
          let stack = Transient stack in
          walk lines ~stack
        else
          failwith "What the fuck"
      | [] -> parsing_to_done ~descent:(10000000) stack
      end
    | Exhausted _
    | Terminal
    | Done _ ->
      failwith "Shouldn't see a terminal or done"
  in
  fun lines ->
    walk lines ~stack:(Transient Terminal)
;;

let parse_loc s =
  match String.split_on_char ':' s with
  | source :: loc :: [] -> (source, int_of_string loc)
  | _ -> ("<UNKNOWN>", 0)
;;

let rec count_character ~start s c =
  if start >= String.length s then
    0
  else if String.unsafe_get s start = c then
    1 + count_character ~start:(start + 1) s c
  else
    count_character ~start:(start + 1) s c
;;

let find_start s =
  try
    String.rindex s '|' + 1
  with Not_found ->
    let rec loop i =
      if i >= String.length s then
        raise Not_found
      else if String.get s i != ' ' then
        i
      else
        loop (i + 1)
    in
    loop 0
;;

let last_char s =
  String.unsafe_get s (String.length s - 1)
;;

let parse_report filename =
  if !output_ref = "" then begin
    output_ref := filename ^ ".parsed"
  end;
  let ic = open_in filename in
  let rec loop ~acc =
    try begin
      let line = input_line ic in
      if String.length line = 0 || String.get line 0 = '#' then begin
        loop ~acc
      end else begin
        let offset = count_character ~start:0 line '|' in
        try
         let start = find_start line in
         let chunks =
           let length = String.length line - start in
           String.sub line start length
           |> String.split_on_char ' '
           |> List.filter (fun s -> String.length s != 0)
         in
         match chunks with
         | [] -> loop ~acc
         | hd :: tl ->
           let overhead, tl =
             if last_char hd = '%' then
               (Some hd, tl)
             else
               (None, chunks)
           in
           match tl with
           | loc :: _ :: symbol :: _ when offset = 0 ->
             let location = parse_loc loc in
             loop ~acc:({ offset; overhead; symbol; location } :: acc)
           | symbol :: loc :: _ ->
             let location = parse_loc loc in
             loop ~acc:({ offset; overhead; symbol; location } :: acc)
           | _ -> failwith "What the fuck"
        with Not_found -> loop ~acc
      end
    end with End_of_file -> acc
  in
  match parse_lines (List.rev (loop ~acc:[])) with
  | Exhausted top_level ->
    let oc = open_out_bin !output_ref in
    output_value oc top_level
  | stack ->
    Format.printf "Not done? %a" print_stack stack;
    failwith "FAILED"
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
