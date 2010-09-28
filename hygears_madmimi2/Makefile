all:
	ocamlbuild hygears_madmimi.cmo

install: 
	ocamlfind install hygears_madmimi META _build/hygears_madmimi.cm*

remove: 
	ocamlfind remove hygears_madmimi

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~
