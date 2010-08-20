(*
 * hyGears - database
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Xml

open Types

exception Malformed 


let result_of_value result =
  print_endline "Into result_of_value"; 
  match result with 
      Element ("literal", _, PCData v :: _) -> Literal v 
    | Element (k, _, _) -> print_endline k; raise Malformed  
    | _ -> print_endline "Wow"; raise Malformed 

let extract_result var result = 
  match result with 
      Element ("result", _, affectations) -> 
	let value = List.find (fun affectation -> 
	  match affectation with 
	      Element ("binding", attrs, _) when (List.assoc "name" attrs = var) -> true
	    | Element (e, attrs, _) ->  false
	    | _ -> false) affectations in
	
	( match value with 
	    Element (_, _, contents :: _) -> result_of_value contents
	  | _ -> raise Malformed )
	    
    | _ -> raise Malformed 

let extract var result = 
  let xml = Xml.parse_string result in 
  match xml with 
      Element ("sparql", _, vars::results::_) -> 
	( match results with 
	    Element ("results", _, results_list) -> 
	      List.map (extract_result var) results_list 
	  | _ -> raise Malformed )
    | _ -> raise Malformed
	
