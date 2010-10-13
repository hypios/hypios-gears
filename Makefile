## Let's build them all

GEARS = misc cache client isi medline meeting ptree zemanta madmimi2 meeting paginate pubmed wikicreole

HYGEARS=$(patsubst %,hygears_%, $(GEARS))

all: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i all; done


install: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i remove install; done

clean: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i clean; done

remove: $(HYGEARS)
	for i in $(HYGEARS); do make -C $$i remove; done