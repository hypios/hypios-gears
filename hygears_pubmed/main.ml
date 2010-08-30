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


module SimpleAggregator = 
  struct 
    type t = (string * string) list 
    let empty = []
    let append key value attributes = (key, value) :: attributes 
  end


module Parser = Factory.Make (SimpleAggregator)

let retrieve_from_file file = 
  let articles = Parser.analyse file in 
  debug "@@@ Number of articles: %d\n" (List.length articles) ; 
  List.iter (fun article -> 
    debug "@@@ Attributes of the article: " ; 
    List.iter (fun (k,v) -> debug "%s : %s, " k v ) article ; 
    debug "\n") articles 
     
let retrieve_from_server term = 
  let prerequest = Effector_standalone.prerequest term in 

  InformationMap.iter (fun key value-> debug "%s %s\n" key value) prerequest ; 

  let query_key = InformationMap.find "QueryKey" prerequest in 
  let web_env = InformationMap.find "WebEnv" prerequest in 

  let fresh_file = Fs.fresh_file () in
 
  let oc = Unix.openfile fresh_file [Unix.O_CREAT; Unix.O_WRONLY] 0o666 in 

  let callback data = Unix.write oc data 0 (String.length data) in
    
  Effector_standalone.request query_key web_env callback;
  

  Unix.close oc ; 
  
  let ic = Unix.openfile fresh_file [ Unix.O_RDONLY ] 0o666 in
  let source = `Channel ( Unix.in_channel_of_descr ic ) in
  let input = make_input source in 
  
  Xml.parse input ; 
  
  Unix.close ic ;

  Unix.unlink fresh_file

  
  
  

    
    
    
    
let _ = 
  debug "HyGears PUBMED Parser \n"; 
  
  let input_file = ref None in
  let input_term = ref None in
  
  Arg.parse [
    ("-f", Arg.String (fun file -> input_file := Some file), "Input file");
    ("-t", Arg.String (fun term -> input_term := Some term), "Input term");
  ] (fun _ -> ()) "Available commands: "  ; 
  
  match !input_file with 
      Some file -> retrieve_from_file file 
    | None -> 
      match !input_term with 
	  Some term -> retrieve_from_server term 
	| None -> ()
  

    
  
