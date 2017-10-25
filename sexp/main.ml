open Lexing

let () =
  let ic = open_in "a.sexp" in
  let lexbuf = Lexing.from_channel ic in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = "a.sexp" };
  while true do
    let token = Lexer.read lexbuf in
    match token with
    | STRING s -> Format.printf " [STRING %s] " s
    | LEFT_BRACE -> Format.printf "( "
    | RIGHT_BRACE -> Format.printf ") "
    | EOF -> Format.printf "\n"; raise Not_found
  done;

  match Parser.prog Lexer.read lexbuf with
  | None -> Format.printf "Cannot parse"
  | Some sexp -> Format.printf "%a" Sexp.print_mach sexp
  | exception Lexer.Syntax_error s ->
    Format.printf "Syntax_error -> %s" s
  | exception Parser.Error ->
    Format.printf "Parser error"
;;
