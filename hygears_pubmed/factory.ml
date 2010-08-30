(*
 * hyGears - medline
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)

open Xmlm

open Signatures 

module Make = functor (Aggregator : AGGREGATOR) -> 
  struct 

    module L = Lexer.Make (Aggregator) 

    let analyse file = 
      let ic = open_in file in 
      try 
	let source = `Channel ic in
	let input = make_input source in 
	let articles = L.parse input in
	close_in ic ; articles 
      with exn -> close_in ic ; raise exn
    
  end
 


