all:
	ocamlbuild hygears_meeting.cmo
	ocamlbuild hygears_meeting.cmx -cflags -for-pack,Hygears_meeting

install: 
	ocamlfind install hygears_meeting META _build/hygears_meeting.cm*

remove: 
	ocamlfind remove hygears_meeting

clean:
	ocamlbuild -clean
	rm -rf *~


