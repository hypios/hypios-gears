## 
# Simple sparql test
#
##

all: sparql_simple.cmo

sparql_simple.cmo: sparql_simple.ml
	ocamlfind ocamlc -thread -package hygears_misc,hygears_sparql $^ -c $@ 