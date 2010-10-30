all:
	ocamlbuild hygears_paginate.cmo
	ocamlbuild hygears_paginate.cmx -cflags -for-pack,Hygears_paginate

install: 
	ocamlfind install hygears_paginate META _build/hygears_paginate.cm* _build/hygears_paginate.o

remove: 
	ocamlfind remove hygears_paginate

test: 
	ocamlbuild main.byte

clean:
	ocamlbuild -clean
	rm -rf *~
