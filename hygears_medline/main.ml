(*
 * hyGears - medline
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)

open Printf 

module Aggregator = 
struct 
  type t = (string * string) list 
  let empty = []
  let append k v attrs = 

    (k, v) :: attrs   
end


module L = Factory.Make (Aggregator) 

let _ = 

  let file = Sys.argv.(1) in
  let articles = L.analyse file in 
  print_string "@@@ Number of files " ; 
  print_int (List.length articles) ;
  print_endline ""  ; 
  List.iter (fun article -> 
    List.iter (fun (k,v) -> printf "%s -> %s\n" k v ) article) articles 
    
