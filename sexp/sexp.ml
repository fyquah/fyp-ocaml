type t =
  | Atom of string
  | List of t list

let rec print_mach ppf t =
  match t with
  | Atom s -> Format.fprintf ppf "%s" s
  | List ts ->
    Format.pp_print_list
      ~pp_sep:(fun ppf () -> Format.fprintf ppf " ")
      (fun ppf t -> Format.fprintf ppf "%a" print_mach t)
      ppf ts
