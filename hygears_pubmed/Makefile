all: byte native

byte:
	ocamlbuild main.byte

native: 	
	ocamlbuild main.native

install: 
	ocamlfind install hygears_pubmed META _build/hygears_pubmed.cm*

remove: 
	ocamlfind remove hygears_pubmed

clean:
	ocamlbuild -clean
	rm -rf *~


