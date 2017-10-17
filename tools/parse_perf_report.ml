let output_ref = ref ""
type symbol = string

type loc = (string * int)

type overhead = string

type top_level_entry =
  { overhead : overhead;
    loc      : loc;
    symbol   : symbol;
  }

type raw_lines =
  | Top_Level_line of (overhead * loc)
  | Line of {
    offset   : int;
    overhead : string option;
    symbol   : string;
    location : loc;
  }

type state =
  | Top_level
  | Init_descent of int
  | Descent of int

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
          loop ~acc:(Line { offset; overhead; symbol; location } :: acc)
        | _ -> failwith "What the fuck"
      end
    end with End_of_file -> acc
  in
  ignore (List.rev (loop ~acc:[]))
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
