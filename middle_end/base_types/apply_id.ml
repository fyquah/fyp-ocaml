type label =
  | Plain_apply
  | Over_application

type t = {
  compilation_unit : Compilation_unit.t;
  stamp : int;
  label : label;
}

include Identifiable.Make (struct
  type nonrec t = t

  let compare t1 t2 =
    if t1 == t2 then 0
    else
      let c = t1.stamp - t2.stamp in
      if c <> 0 then c
      else Compilation_unit.compare t1.compilation_unit t2.compilation_unit

  let equal t1 t2 =
    if t1 == t2 then true
    else
      t1.stamp = t2.stamp
        && Compilation_unit.equal t1.compilation_unit t2.compilation_unit

  let output chan t =
    output_string chan (Compilation_unit.string_for_printing t.compilation_unit);
    output_string chan "_";
    output_string chan (string_of_int t.stamp)

  let hash t = t.stamp lxor (Compilation_unit.hash t.compilation_unit)

  let print ppf t =
    if Compilation_unit.equal t.compilation_unit
        (Compilation_unit.get_current_exn ())
    then begin
      Format.fprintf ppf "Apply_id[%d]" t.stamp
    end else begin
      Format.fprintf ppf "Apply_id[%a/%d]"
        Compilation_unit.print t.compilation_unit
        t.stamp
    end
end)

let previous_stamp = ref (-1)

let create ?current_compilation_unit label =
  let compilation_unit =
    match current_compilation_unit with
    | Some compilation_unit -> compilation_unit
    | None -> Compilation_unit.get_current_exn ()
  in
  let stamp =
    incr previous_stamp;
    !previous_stamp
  in
  { compilation_unit;
    stamp;
    label;
  }

let with_label t label = { t with label }

let in_compilation_unit t c = Compilation_unit.equal c t.compilation_unit

let get_compilation_unit t = t.compilation_unit

