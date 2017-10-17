let output_ref = ref ""
type symbol = string

type loc = (string * int)

type overhead = string

type raw_lines =
  { offset   : int;
    overhead : string option;
    symbol   : string;
    location : loc;
  }

type t =
  { overhead: overhead;
    call_stack: (symbol * loc) list;
    children: t list;
  }

type parser_stack =
  | Terminal
  | Transient of parser_stack
  | Done of t * parser_stack
  | Parsing of string * int * (symbol * loc) list * parser_stack

let parsing_to_done ~descent stack =
  let rec loop i s ~children =
    if i >= descent then
      s
    else begin
      match s with
      | Done (_t, Terminal) -> s
      | Done (t, ros) ->
        let children = t :: children in
        loop i ros ~children
      | Parsing (overhead, _offset, call_stack, ros) ->
        let children = List.rev children in
        let t = { overhead; call_stack; children } in
        loop i (Done (t, ros)) ~children:[]
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
        | None -> failwith "What the actual fuck"
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
          parsing_to_done ~descent stack
        else
          failwith "What the fuck"
      | [] -> parsing_to_done ~descent:(10000000) stack
      end
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
  | _ -> failwith (Format.sprintf "Cannot parse loc string %s" s)
;;

let rec count_character ~start s c =
  if start >= String.length s then
    0
  else if String.unsafe_get s start = c then
    1 + count_character ~start:(start + 1) s c
  else
    count_character ~start:(start + 1) s c
;;

let find_start line =
  (* finds the start directly after the (possibly hypothetical) pipe
   * charcter *)
  let start = String.rindex line '|' in
  if String.get line (start + 1) = ' ' then begin
    let rec loop i =
      if String.get line i != ' ' then
        (i - 1)
      else
        loop (i + 1)
    in
    loop (start + 1)
  end else begin
    start
  end
;;

let last_char s =
  String.unsafe_get s (String.length s - 1)
;;

let parse_report filename =
  if !output_ref = "" then begin
    output_ref := filename ^ ".parsed"
  end;
  Format.printf "File : %s" filename;
  let ic = open_in filename in
  let rec loop ~acc =
    try begin
      let line = input_line ic in
      if String.get line 0 = '#' then begin
        loop ~acc
      end else begin
        let offset = count_character ~start:0 line '|' in
        let start = find_start line in
        let chunks =
          let length = String.length line - start in
          String.sub line start length
          |> String.split_on_char ' '
          |> List.filter (fun s -> String.length s != 0)
        in
        let hd = List.hd chunks in
        let overhead, tl =
          if last_char hd = '%' then
            (Some hd, List.tl chunks)
          else
            (None, chunks)
        in
        match tl with
        | symbol :: loc :: _ ->
          let location = parse_loc loc in
          loop ~acc:({ offset; overhead; symbol; location } :: acc)
        | _ -> failwith "What the fuck"
      end
    end with End_of_file -> acc
  in
  ignore (parse_lines (List.rev (loop ~acc:[])))
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
