all:
	ocamlbuild hygears_ptree.cmo

install: 
	ocamlfind install hygears_ptree META _build/hygears_ptree.cm*

remove: 
	ocamlfind remove hygears_ptree

clean:
	ocamlbuild -clean
	rm -rf *~
