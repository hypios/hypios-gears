(*
 * hyGears - medline
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)

(* XML reader for medline files *) 

open Xmlm

open Types
open Misc

let parse input = 

  let extract_string i = 
    match Xmlm.input i with 
	`Data data -> debug "@@@ Extracted string %s\n" data ; data 
      | _ -> raise Error in

  let print_tag (_, local) = debug "@@@ Tag: %s\n" local in

  let rec glob depth i = 
    match (Xmlm.input i), depth with
      | `Data _, d -> glob d i 
      | `El_end, 0 -> () 
      | `Dtd _, d -> glob d i
      | `El_end, d -> glob (d-1) i 
      | `El_start (tag,_), d -> print_tag tag ;  glob (d+1) i in
	
  let rec read_medline_citation params i = 
    match Xmlm.input i with 
      | `El_end -> debug "@@@ end in medline citation\n"; read_pubmed_article params i 
      | `El_start _ -> glob 0 i; read_medline_citation params i  
      | `Dtd _ | `Data _ -> read_medline_citation params i 
	
  and read_pubmed_data params i = 
    match Xmlm.input i with 
      | `El_end -> read_pubmed_article params i 
      | `El_start (tag, _) -> print_tag tag; glob 0 i; params  
      | `Dtd _ | `Data _ -> read_pubmed_data params i 
	
  and read_pubmed_article params i =
    match Xmlm.input i with 
      | `El_end -> 
	params
      
      | `El_start ((_, "MedlineCitation"), _) -> 
	debug "@@@ In medline citation\n"; 
	read_medline_citation params i 
	  
      | `El_start ((_, "PubmedData"), _) -> 
	debug "@@@ In pubmed data\n"; 
	read_pubmed_data params i 
	
      | `Dtd _ | `Data _ | `El_start _ -> 
	read_pubmed_article params i 
 
  and read_pubmed_articles acc i = 
    match Xmlm.input i with 
      | `Dtd _ | `Data _ -> read_pubmed_articles acc i
      | `El_end -> debug "@@@ Weird out path\n" ; acc 
      | `El_start ((_,  t), _) -> 		
	let article = read_pubmed_article InformationMap.empty i in 
	match eoi i with 
	    false -> read_pubmed_articles ( article :: acc ) i 
	  | true -> article :: acc     
  in
  
  let rec read i = 
    match Xmlm.input input with 
	`El_start ((_, "PubmedArticleSet"), _) -> 
	  read_pubmed_articles [] input 
      | _ -> 
	match eoi i with 
	    false -> read i
	  | true -> []
  in
  

  
  try   
    
    let articles = read input in 
   ()
  with Xmlm.Error((l,c), e) -> debug "@@@ PANIC at pos %d:%d : %s\n" l c  (e >>> error_message)
