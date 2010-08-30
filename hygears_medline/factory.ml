

open Printf
open Signatures 

module Make = functor (Aggregator : AGGREGATOR) -> 
  struct 
    
    module L = Lexer.Make (Aggregator) 
    
    let analyse file = 
      let ic = open_in file in 
      try 
	let lexbuf = Lexing.from_channel ic in
	let articles = L.lex_medline [] lexbuf in
	close_in ic; articles 
      with exn -> close_in ic ; raise exn
  end
