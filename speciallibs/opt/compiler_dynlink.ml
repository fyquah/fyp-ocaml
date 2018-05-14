let (return_val : Obj.t option ref) = ref None

let set_return_val s =
  return_val := Some (Obj.repr s)
;;

let run_module module_name allowed_modules =
  (* Dynlink.allow_only allowed_modules; *)
  ignore allowed_modules;
  Dynlink.loadfile module_name;
  match !return_val with
  | None -> assert false
  | Some value -> Obj.obj value
;;
