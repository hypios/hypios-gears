all:
	ocamlbuild hygears_misc.cmo
	ocamlbuild hygears_misc.cmx -cflags -for-pack,Hygears_misc

install: 
	ocamlfind install hygears_misc META _build/hygears_misc.cm* _build/hygears_misc.o

remove: 
	ocamlfind remove hygears_misc 

clean:
	ocamlbuild -clean
	rm -rf *~


