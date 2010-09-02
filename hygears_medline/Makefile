all: 
	ocamlbuild hygears_medline.cmo

byte:
	ocamlbuild main.byte

native: 	
	ocamlbuild main.native

install: 
	ocamlfind install hygears_medline META _build/hygears_medline.cm*

remove: 
	ocamlfind remove hygears_medline

test: 
	ocamlbuild test.byte

clean:
	ocamlbuild -clean
	rm -rf *~


