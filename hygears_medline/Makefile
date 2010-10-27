all: 
	ocamlbuild hygears_medline.cmo
	ocamlbuild hygears_medline.cmx -cflags -for-pack,Hygears_medline

byte:
	ocamlbuild main.byte

native: 	
	ocamlbuild main.native

install: 
	ocamlfind install hygears_medline META _build/hygears_medline.cm* _build/hygears_medline.o

remove: 
	ocamlfind remove hygears_medline

test: 
	ocamlbuild test.byte

clean:
	ocamlbuild -clean
	rm -rf *~


