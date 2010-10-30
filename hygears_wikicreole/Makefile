 #
 #
 #  This file is part of Wikicreole-ocaml
 #
 #  Wikicreole-ocaml is free software: you can redistribute it and/or modify
 #  it under the terms of the GNU General Public License as published by
 #  the Free Software Foundation, either version 3 of the License, or
 #  (at your option) any later 
 #  
 #  Wikicreole-ocaml is distributed in the hope that it will be useful,
 #  but WITHOUT ANY WARRANTY; without even the implied warranty of
 #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #  GNU General Public License for more details.
 #  
 #  You should have received a copy of the GNU General Public License
 #  along with Wikicreole-ocaml. If not, see <http://www.gnu.org/licenses/>.
 #
 #  Makefile william le ferrand (william@themipsfactory.com) 17/04/2010 22:50
 #
 #

default: all

DISPLAYFLAG := -classic-display

OCAMLBUILD := ocamlbuild
OCAMLFIND := ocamlducefind

all: 
	$(OCAMLBUILD) hygears_wikicreole.cma
	$(OCAMLBUILD) hygears_wikicreole.cmxa -cflags -for-pack,Hygears_wikicreole

test: 
	$(OCAMLBUILD) test.byte 

install:
	$(OCAMLFIND) install hygears_wikicreole META _build/hygears_wikicreole.cm* _build/hygears_wikicreole.o _build/hygears_wikicreole.a

remove: 
	$(OCAMLFIND) remove hygears_wikicreole

clean: 
	$(OCAMLBUILD) -clean 
	rm -f *~
