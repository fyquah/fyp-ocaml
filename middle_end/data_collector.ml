[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type t = { call_stack : Call_site.t list; decision : bool; }

let (inlining_decisions : t list ref) = ref []

let print_decisions ppf decisions =
  List.iter (fun decision ->
      let { call_stack; decision } = decision in
      List.iter (fun call_site ->
          Format.fprintf ppf "%a," Call_site.print_mach call_site)
        (List.rev call_stack);
      if decision then
        Format.fprintf ppf "YES\n"
      else
        Format.fprintf ppf "NO\n")
    decisions
;;

let save ~output_prefix =
  let out_channel = open_out (output_prefix ^ ".data_collector.txt") in
  let ppf = Format.formatter_of_out_channel out_channel in
  Format.fprintf ppf
    "# The calls are from left to right -- ToS is at the furthest right\n";
  print_decisions ppf !inlining_decisions;
  close_out out_channel;
  inlining_decisions := []
;;
