all: main.native

sexp_lexer.ml sexp_lexer.mli: sexp_lexer.mll
	ocamllex sexp_lexer.mll

sexp_parser.ml sexp_parser.mli: sexp_parser.mly
	menhir sexp_parser.mly

main.native: sexp.mli sexp.ml sexp_parser.mli sexp_parser.ml sexp_lexer.ml main.ml
	ocamlopt $^ -o $@

clean:
	rm sexp_lexer.ml sexp_parser.mli sexp_parser.ml main.native *.o *.cm*
