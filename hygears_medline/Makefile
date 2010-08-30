all: 
	ocamlbuild hygears_pubmed.cmo

byte:
	ocamlbuild main.byte

native: 	
	ocamlbuild main.native

install: 
	ocamlfind install hygears_pubmed META _build/hygears_pubmed.cm*

remove: 
	ocamlfind remove hygears_pubmed

test: 
	ocamlbuild test.byte

clean:
	ocamlbuild -clean
	rm -rf *~


