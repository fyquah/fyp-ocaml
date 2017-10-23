[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type call_site =
  { closure_id  : Closure_id.t;
    location_id : int;
  }

type t = { call_stack : call_site list; decision : bool; }

let (inlining_decisions : t list ref) = ref []

let print_decisions ppf decisions =
  List.iter (fun decision ->
      let { call_stack; decision } = decision in
      List.iter (fun call_site ->
          let { closure_id; location_id } = call_site in
          Format.fprintf ppf "%a:%d,"
            Closure_id.print closure_id location_id)
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
