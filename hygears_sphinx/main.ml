open Printf 

let _ = 
  printf "@@@ Starting sphinx-ocaml stress test\n" ; flush stdout ; 
  let connection = Hygears_sphinx.Connection.create () in 
  Hygears_sphinx.Command.query connection "test1" "test" ; 
  ( )
