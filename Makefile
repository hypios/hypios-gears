## Let's build them all

GEARS = misc cache client isi medline meeting ptree zemanta madmimi2 meeting paginate pubmed wikicreole
GEARS_NAME = misc cache client isi medline meeting ptree zemanta madmimi meeting paginate wikicreole

HYGEARS=$(patsubst %,hygears_%, $(GEARS))
HYGEARS_NAME=$(patsubst %,hygears_%, $(GEARS_NAME))

all: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i all; done

hygears.cmxs: $(HYGEARS_NAME)
	ocamlfind ocamlopt -thread -package "$^" -linkpkg -shared -o $@

install: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i remove install; done

clean: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i clean; done

remove: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i remove; done

install_native: 
	ocamlfind install hygears META hygears.cmxs 
