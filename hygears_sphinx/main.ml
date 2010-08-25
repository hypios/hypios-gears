open Printf 

open Hygears_sphinx.Types 

let _ = 
  printf "@@@ Starting sphinx-ocaml stress test\n" ; flush stdout ; 
  let connection = Hygears_sphinx.Connection.create () in 
  
  for t = 0 to 0 do 
    
    Hygears_sphinx.Command.set_field_weights connection 2 [| "title"; "content" |] [| 21; 1000 |]; 
    let result = Hygears_sphinx.Command.query connection "test1" "test and a second" in 
    printf "%d %d\n" result.total result.total_found ; flush stdout; 
    
 
  Array.iter (fun wordinfo -> printf "%s found %d times in %d docs\n" wordinfo.word wordinfo.docs wordinfo.hits)
   result.words ;

  Array.iter (fun occurence -> 
    printf "doc: %d ; weight: %d\n" occurence.doc_id occurence.weight ) result.occurences; 

  flush stdout
  done 
