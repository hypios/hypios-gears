all:
	ocamlbuild hygears_paginate.cmo

install: 
	ocamlfind install hygears_paginate META _build/hygears_paginate.cm*

remove: 
	ocamlfind remove hygears_paginate

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~
