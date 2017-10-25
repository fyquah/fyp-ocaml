all: main.native

lexer.ml lexer.mli: lexer.mll
	ocamllex lexer.mll

parser.ml parser.mli: parser.mly
	menhir parser.mly

main.native: sexp.ml parser.mli parser.ml lexer.ml main.ml 
	ocamlopt $^ -o $@

clean:
	rm lexer.ml parser.mli parser.ml main.native *.o *.cm*
