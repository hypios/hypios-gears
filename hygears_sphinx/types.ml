(*
 * hyGears - sphinx
 *
 * (c) 2010 William Le Ferrand william.le-ferrand@polytechnique.edu
 *
 *)

type connection

val connect : unit -> connection = external "ocaml_sphinx_connect" 


