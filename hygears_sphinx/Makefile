## Hand made Makefile

SPHINX_INCLUDE = /Users/hypios/pub/sphinx-1.10-beta/api/libsphinxclient/ 
SPHINX_LIB_STATIC = /usr/local/lib/libsphinxclient.a ## Qd qqun a deux minutes, builder en dynamique ..

INCLUDES = -I $(SPHINX_INCLUDE) -I `ocamlc -where`
LIBS = $(SPHINX_LIB_STATIC)

all: sphinx_stubs.o

%.o: %.c
	gcc $(INCLUDES) $^ -c -o $@ 

%.cmo: %.ml
	ocamlfind ocamlc $^ -c 

%.cmx: %.ml
	ocamlfind ocamlopt $^ -c 

lib: sphinx_stubs.o hygears_sphinx.cmo hygears_sphinx.cmx 
	ocamlmklib -o sphinx hygears_sphinx.cmo hygears_sphinx.cmx sphinx_stubs.o $(LIBS)

test:  test.o 
	gcc $^ $(LIBS) -o $@

main: lib # Hardcore
	ocamlc -custom sphinx_stubs.o main.ml hygears_sphinx.cmo -o $@ -cclib $(LIBS)

clean:
	rm -f *~
	rm -f *.o
	rm -f *.rm
	rm -f *.cm*
	rm -f *.so
	rm -f test
	rm -f main