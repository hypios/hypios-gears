all:
	ocamlbuild hygears_madmimi.cmo
	ocamlbuild hygears_madmimi.cmx -cflags -for-pack,Hygears_madmimi

install: 
	ocamlfind install hygears_madmimi META _build/hygears_madmimi.cm* _build/hygears_madmimi.o

remove: 
	ocamlfind remove hygears_madmimi

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~
