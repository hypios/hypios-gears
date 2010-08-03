(*
 * hyGears - misc
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Hygears_misc.Utils

open Types 

let upload connection iri rdf = 

  let counter = ref 0 in 
    
  let writer accum data =
    Buffer.add_string accum data;
    String.length data in

  let reader str maxBytes =
    let readBytes = min (String.length str - !counter) maxBytes in
      if readBytes = 0 then ""
      else 
	(
	  let c = !counter in
	    counter := !counter + readBytes;
	    String.sub str c readBytes) in
    
    
  let conn = Curl.init () in
    
    Curl.setopt conn (Curl.CURLOPT_URL (connection.prefix ^ iri));
    Curl.setopt conn (Curl.CURLOPT_PUT true) ; 
    Curl.setopt conn (Curl.CURLOPT_USERPWD (connection.login ^ ":" ^ connection.password));
    Curl.setopt conn (Curl.CURLOPT_READFUNCTION (reader rdf));    
    
    let result = Buffer.create 16384 in
      
      Curl.set_writefunction conn (writer result);
      Curl.perform conn; 
      Curl.cleanup conn; 
      Buffer.contents result 

  
let create connection iri fmt  =
  Printf.ksprintf (fun s -> debug "@@@ Sending %s\n" s;  upload connection iri s) fmt
   
      



