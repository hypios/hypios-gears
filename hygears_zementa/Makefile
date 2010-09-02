all:
	ocamlbuild hygears_zementa.cmo

install: 
	ocamlfind install hygears_zementa META _build/hygears_zementa.cm*

remove: 
	ocamlfind remove hygears_zementa

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~