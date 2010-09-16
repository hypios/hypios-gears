all:
	ocamlbuild hygears_zemanta.cmo
	ocamlbuild hygears_zemanta.cmx -cflags -for-pack,Hygears_zemanta

install: 
	ocamlfind install hygears_zemanta META _build/hygears_zemanta.cm*

remove: 
	ocamlfind remove hygears_zemanta

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~
