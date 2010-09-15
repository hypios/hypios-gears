## Hand made Makefile

SPHINX_INCLUDE = /Users/marcsimon/Desktop/sphinx-1.10-beta/api/libsphinxclient 
SPHINX_LIB_STATIC = /usr/lib/libsphinxclient.a ## Qd qqun a deux minutes, builder en dynamique ..

INCLUDES = -I $(SPHINX_INCLUDE) -I `ocamlc -where`
LIBS = $(SPHINX_LIB_STATIC)

all: hygears_sphinx.cmo hygears_sphinx.cmx lib_cmo lib_cmx

%.o: %.c
	gcc $(INCLUDES) $^ -c -o $@ 

%.cmo: %.mlpack
	ocamlbuild $@

%.cmx: %.mlpack
	ocamlbuild $@

lib_cmo: hygears_sphinx.cmo sphinx_stubs.o
	ocamlmklib -o hygears_sphinx _build/hygears_sphinx.cmo sphinx_stubs.o -lsphinxclient

lib_cmx: hygears_sphinx.cmx sphinx_stubs.o
	ocamlmklib -o hygears_sphinx _build/hygears_sphinx.cmx sphinx_stubs.o -lsphinxclient



test:  test.o 
	gcc $^ $(LIBS) -o $@

main: lib # Hardcore
	ocamlc -custom sphinx_stubs.o main.ml hygears_sphinx.cmo -o $@ -cclib $(LIBS)

install: 
	ocamlfind install hygears_sphinx META _build/hygears_sphinx.cmi hygears_sphinx.cma *.a *.so

remove: 
	ocamlfind remove hygears_sphinx

clean:
	ocamlbuild -clean
	rm -f *~
	rm -f *.o
	rm -f *.rm
	rm -f *.cm*
	rm -f *.so
	rm -f *.a
	rm -f test
	rm -f main