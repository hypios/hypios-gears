(*
 * hyGears - sphinx
 *
 * (c) 2010 William Le Ferrand william.le-ferrand@polytechnique.edu
 *
 *)

open Types 

external create : unit -> sphinx_client = "ocaml_sphinx_connect"
external set_server : sphinx_client -> string -> int -> unit = "ocaml_sphinx_set_server"
    
