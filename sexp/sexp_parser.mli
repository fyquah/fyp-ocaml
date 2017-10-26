
(* The type of tokens. *)

type token = 
  | STRING of (string)
  | RIGHT_BRACE
  | LEFT_BRACE
  | EOF

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Sexp.t option)
