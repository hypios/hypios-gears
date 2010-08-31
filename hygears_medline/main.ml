(*
  MEDLINE Parser
*)



module Aggregator = 
struct 
  type t = (string * string) list 
  let empty = []
  let append k v attrs = (k, v) :: attrs   
end


module L = Factory.Make (Aggregator) 

let _ = 

  let file = Sys.argv.(1) in
  let articles = L.analyse file in 
  print_string "@@@ Number of files " ; 
  print_int (List.length articles) ;
  print_endline ""  
    
