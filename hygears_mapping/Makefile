all:
	ocamlbuild hygears_mapping.cmo
	ocamlbuild hygears_mapping.cmx -cflags -for-pack,Hygears_mapping

install: 
	ocamlfind install hygears_mapping META _build/hygears_mapping.cm*

remove: 
	ocamlfind remove hygears_mapping

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~
