all:
	ocamlbuild hygears_isi.cmo
	ocamlbuild hygears_isi.cmx -cflags -for-pack,Hygears_isi

install: 
	ocamlfind install hygears_isi META _build/hygears_isi.cm*

remove: 
	ocamlfind remove hygears_isi

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~


