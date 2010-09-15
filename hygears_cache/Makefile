all:
	ocamlbuild hygears_cache.cmo
	ocamlbuild hygears_cache.cmx -cflags -for-pack,Hygears_cache

install: 
	ocamlfind install hygears_cache META _build/hygears_cache.cm*

remove: 
	ocamlfind remove hygears_cache

clean:
	ocamlbuild -clean
	rm -rf *~


