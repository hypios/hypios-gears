(*
 * Small test example
 *
 *)

open Misc


module Aggregator = 
  struct 
    type t = (string * string) list 
    let empty = []
    let append k v l = (k,v) :: l 
  end

module P = Factory.Make (Aggregator) 

let _ = 
  debug "@@@ Pubmed functor example\n" ; 
  let file = Sys.argv.(1) in 
  debug "@@@ Parsing file %s\n" file ; 
  let articles = P.analyse file in
  debug "@@@ %d articles found\n" (List.length articles) 

  
