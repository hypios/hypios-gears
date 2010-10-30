all:
	ocamlbuild hygears_ptree.cmo
	ocamlbuild hygears_ptree.cmx -cflags -for-pack,Hygears_ptree

install: 
	ocamlfind install hygears_ptree META _build/hygears_ptree.cm* _build/hygears_ptree.o

remove: 
	ocamlfind remove hygears_ptree

clean:
	ocamlbuild -clean
	rm -rf *~
