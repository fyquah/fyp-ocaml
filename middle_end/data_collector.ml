[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type t =
  { call_stack : Call_site.t list;
    applied : Closure_id.t;
    decision : bool;
  }

let (inlining_decisions : t list ref) = ref []

let (inlining_overrides : t list ref) = ref []

let print_decisions ppf decisions =
  List.iter (fun decision ->
      let { applied; call_stack; decision } = decision in
      begin if decision then
        Format.fprintf ppf "YES,"
      else
        Format.fprintf ppf "NO,"
      end;
      Format.fprintf ppf "[%a]," Closure_id.print applied;
      List.iter (fun call_site ->
          Format.fprintf ppf "%a," Call_site.print_mach call_site)
        call_stack;
      Format.fprintf ppf "END\n")
    decisions
;;

let print_list = print_decisions

let save ~output_prefix =
  let out_channel = open_out (output_prefix ^ ".data_collector.txt") in
  let ppf = Format.formatter_of_out_channel out_channel in
  Format.fprintf ppf
    "# The calls are from right to left -- ToS is at the furthest left\n";
  print_decisions ppf !inlining_decisions;
  close_out out_channel;
  inlining_decisions := []
;;

let parse lines =
  List.filter (fun line -> String.length line >= 0 && String.get line 0 != '#') lines
  |> List.map (fun line ->
      let f decision applied call_stack =
        let applied =
          assert (String.get applied 0 = '[');
          assert (String.get applied (String.length applied - 1) = ']');
          Closure_id.wrap (
              Variable.of_string (String.sub applied 1 (String.length applied - 2)))
        in
        let call_stack =
          match List.rev call_stack with
          | "END" :: tl -> List.rev tl
          | _ -> Misc.fatal_error "FAILED"
        in
        let call_stack = List.map Call_site.of_string call_stack in
        { call_stack; applied; decision; }
      in
      match (String.split_on_char ',' line) with
      | "YES" :: applied :: stack -> f true applied stack
      | "NO"  :: applied :: stack -> f false applied stack
      | _ -> Misc.fatal_error "bad")
