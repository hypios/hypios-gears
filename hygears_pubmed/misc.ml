open Types

let (>>>) f g = g f

let debug fmt = 
  Printf.ksprintf (fun s -> print_string s; flush stdout) fmt

open Xmlm

let extract_information xml = 

  let source = `String (0, xml) in
  let input = make_input source in
  
  let rec glob depth i = 
    match (Xmlm.input i), depth with
      | `Data _, d -> glob d i 
      | `El_end, 0 -> () 
      | `Dtd _, d -> glob d i
      | `El_end, d -> glob (d-1) i 
      | `El_start (tag,_), d -> glob (d+1) i in	
  
  let rec extract_attrib key params i = 
    match Xmlm.input i with 
	`Data data -> extract_attrib key (InformationMap.add key data params) i
      | `El_end -> get_information params i 
      | `El_start _ -> glob 1 i ; get_information params i
      | _ -> extract_attrib key params i

  and get_information params i = 
    match Xmlm.input i with 
	`El_start ( (_, key), _ ) ->
	  extract_attrib key params i
      | _ ->  if not (eoi i) then get_information params i else params in
	  
  let rec read i = 
    match Xmlm.input i with 
	`El_start _ ->
	  get_information InformationMap.empty input 
      | _ -> if not (eoi i) then read i else InformationMap.empty in
  
  read input 
  
