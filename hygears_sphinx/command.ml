(*
 * hyGears - sphinx
 *
 * (c) 2010 William Le Ferrand william.le-ferrand@polytechnique.edu
 *
 *)


open Types 
  
external set_field_weights : sphinx_client -> int -> string array -> int array -> unit = "ocaml_sphinx_set_field_weights"
external set_select : sphinx_client -> string -> unit = "ocaml_sphinx_set_select" 
external query : sphinx_client -> string -> string -> sphinx_result = "ocaml_sphinx_query"
