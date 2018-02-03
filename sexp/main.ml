open Lexing

let () =
  let ic = open_in "a.sexp" in
  let lexbuf = Lexing.from_channel ic in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = "a.sexp" };

  match Sexp_parser.prog Sexp_lexer.read lexbuf with
  | None -> Format.printf "Cannot parse"
  | Some sexp -> Format.printf "%a" Sexp.print_mach sexp
  | exception Sexp_lexer.Syntax_error s ->
    Format.printf "Syntax_error -> %s" s
  | exception Sexp_parser.Error ->
    Format.printf "Parser error"
;;
