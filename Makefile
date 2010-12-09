## Let's build them all

GEARS = misc cache client medline meeting ptree zemanta madmimi2 paginate wikicreole mapping
GEARS_NAME = misc cache client medline ptree wikicreole paginate wikicreole zemanta mapping madmimi

HYGEARS=$(patsubst %,hygears_%, $(GEARS))
HYGEARS_NAME=$(patsubst %,hygears_%, $(GEARS_NAME))

all: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i all; done

cmxs: $(HYGEARS_NAME)
	echo $^
	for i in $^; do ocamlfind ocamlopt -thread -package $$i -shared -o $$i.cmxs $$i.cmx ; done 

hygears.cmxs: $(HYGEARS_NAME)
	ocamlfind ocamlopt -thread -package "$^" -linkpkg -shared -o $@

install: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i remove install; done

clean: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i clean; done

remove: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i remove; done

install_native: 
	ocamlfind install hygears META *.cmxs 

clean_native: 
	rm -f *.cmxs

remove_native:
	ocamlfind remove hygears
