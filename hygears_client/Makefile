all:
	ocamlbuild hygears_client.cmo
	ocamlbuild hygears_client.cmx -cflags -for-pack,Hygears_client

install: 
	ocamlfind install hygears_client META _build/hygears_client.cm*

remove: 
	ocamlfind remove hygears_client

clean:
	ocamlbuild -clean
	rm -rf *~


