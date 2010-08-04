(*
 * hyGears - database
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Connection

let put_rdf connection namegraph rdf = 

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
    
    Curl.setopt conn (Curl.CURLOPT_READFUNCTION (reader rdf));    
    Curl.setopt conn (Curl.CURLOPT_PUT true) ; 
    Curl.setopt conn (Curl.CURLOPT_UPLOAD true) ;
    Curl.setopt conn (Curl.CURLOPT_URL (connection.prefix ^ "/data/" ^ namegraph));
    Curl.setopt conn (Curl.CURLOPT_INFILESIZE (String.length rdf)); 

    let result = Buffer.create 16384 in
      
      Curl.set_writefunction conn (writer result);
      Curl.perform conn; 
      Curl.cleanup conn; 
      Buffer.contents result 


let put_turtle connection namegraph turtle = 
  let writer accum data =
    Buffer.add_string accum data;
    String.length data in
    
  let conn = Curl.init () in

  let data = Printf.sprintf "data=%s&graph=%s&mime-type=application/x-turtle" (Curl.escape turtle) (Curl.escape namegraph) in

    Curl.setopt conn (Curl.CURLOPT_POSTFIELDS data); 
    Curl.setopt conn (Curl.CURLOPT_URL (connection.prefix ^ "/data/"));
    
    let result = Buffer.create 16384 in
      
      Curl.set_writefunction conn (writer result);
      Curl.perform conn; 
      Curl.cleanup conn; 
      Buffer.contents result 


let exec_sparql connection query = 
     
  let writer accum data =
    Buffer.add_string accum data;
    String.length data in

  let conn = Curl.init () in
    
  let query = Curl.escape query in 
    
    Curl.setopt conn (Curl.CURLOPT_URL (connection.prefix ^ "/sparql/?query=" ^ query));
    
    let result = Buffer.create 16384 in
      
      Curl.set_writefunction conn (writer result);
      Curl.perform conn; 
      Curl.cleanup conn; 
      Buffer.contents result 

  
  
