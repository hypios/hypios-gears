open Lwt

open Connection

let get connection uri =
        Printf.printf "URI:%s\n" uri;
        Ocsigen_http_client.get ~host:connection.host ~uri () 
        >>= fun frame -> 
          match frame.Ocsigen_http_frame.frame_content with
              None -> failwith "Server down"
            | Some data ->  Ocsigen_stream.string_of_stream (Ocsigen_stream.get data) 
          
let post_string ?https ?port ?(headers = Http_headers.empty) ~host ~uri ~content ~content_type () =
 
  Ocsigen_lib.get_inet_addr host >>= fun inet_addr ->

  let content_type = String.concat "/" [fst content_type; snd content_type] in
  Ocsigen_http_client.raw_request
    ?https
    ?port
    ~http_method:Ocsigen_http_frame.Http_header.POST
    ~content:(Some (Ocsigen_stream.of_string content))
    ~content_length:(Int64.of_int (String.length content))
    ~headers:(Http_headers.add Http_headers.content_type content_type headers)
    ~host:(match port with None -> host | Some p -> host^":"^string_of_int p)
    ~inet_addr
    ~uri
    ()
    ()

let post_urlencoded ?https ?port ?headers ~host ~uri ~content () = 
  post_string ?https ?port ?headers
    ~host ~uri
    ~content:(Netencoding.Url.mk_url_encoded_parameters content) 
    ~content_type:("application","x-www-form-urlencoded")
    ()

let post connection uri content = 
  post_urlencoded 
    ~headers:(Http_headers.add (Http_headers.name "Authorization") (Printf.sprintf "Basic %s" connection.auth) Http_headers.empty)
    ~host:connection.host 
    ~uri 
    ~content ()
 >>= fun frame -> 
          match frame.Ocsigen_http_frame.frame_content with
              None -> Printf.printf "@@@ PANIC!\n"; failwith "Empty body"
            | Some data ->  Printf.printf "@@@ OK man\n"; Ocsigen_stream.string_of_stream (Ocsigen_stream.get data) 
  

let put_string ?https ?port ?(headers = Http_headers.empty) ~host ~uri ~content ~content_type () =
 
  Ocsigen_lib.get_inet_addr host >>= fun inet_addr ->

  let content_type = String.concat "/" [fst content_type; snd content_type] in
  Ocsigen_http_client.raw_request
    ?https
    ?port
    ~http_method:Ocsigen_http_frame.Http_header.PUT
    ~content:(Some (Ocsigen_stream.of_string content))
    ~content_length:(Int64.of_int (String.length content))
    ~headers:(Http_headers.add Http_headers.content_type content_type headers)
    ~host:(match port with None -> host | Some p -> host^":"^string_of_int p)
    ~inet_addr
    ~uri
    ()
    ()

let put_urlencoded ?https ?port ?headers ~host ~uri ~content () = 
  put_string ?https ?port ?headers
    ~host ~uri
    ~content:(Netencoding.Url.mk_url_encoded_parameters content) 
    ~content_type:("application","x-www-form-urlencoded")
    ()

let put connection uri content = 
  put_urlencoded 
    ~headers:(Http_headers.add (Http_headers.name "Authorization") (Printf.sprintf "Basic %s" connection.auth) Http_headers.empty)
    ~host:connection.host 
    ~uri 
    ~content ()
 >>= fun frame -> 
          match frame.Ocsigen_http_frame.frame_content with
              None -> Printf.printf "@@@ PANIC!\n"; failwith "Empty body"
            | Some data ->  Printf.printf "@@@ OK man\n"; Ocsigen_stream.string_of_stream (Ocsigen_stream.get data) 
  

(* method delete by Ramdane, to check :-) *)

let delete_string ?https ?port ?(headers = Http_headers.empty) ~host ~uri ~content ~content_type () =
 
  Ocsigen_lib.get_inet_addr host >>= fun inet_addr ->

  let content_type = String.concat "/" [fst content_type; snd content_type] in
  Ocsigen_http_client.raw_request
    ?https
    ?port
    ~http_method:Ocsigen_http_frame.Http_header.DELETE
    ~content:(Some (Ocsigen_stream.of_string content))
    ~content_length:(Int64.of_int (String.length content))
    ~headers:(Http_headers.add Http_headers.content_type content_type headers)
    ~host:(match port with None -> host | Some p -> host^":"^string_of_int p)
    ~inet_addr
    ~uri
    ()
    ()

let delete_urlencoded ?https ?port ?headers ~host ~uri ~content () = 
  delete_string ?https ?port ?headers
    ~host ~uri
    ~content:(Netencoding.Url.mk_url_encoded_parameters content) 
    ~content_type:("application","x-www-form-urlencoded")
    ()

let delete connection uri content = 
  delete_urlencoded 
    ~headers:(Http_headers.add (Http_headers.name "Authorization") (Printf.sprintf "Basic %s" connection.auth) Http_headers.empty)
    ~host:connection.host 
    ~uri 
    ~content ()
(*
let post connection uri body = 
  Printf.printf "URI (post): %s\n" uri ; 
  
  let headers = Http_headers.add (Http_headers.name "Authorization") (Printf.sprintf "Basic %s" connection.auth) Http_headers.empty in
 
  
  
  Ocsigen_lib.get_inet_addr connection.host >>= fun inet_addr ->
  let content_type = "" in
  let content =  (Json_io.string_of_json body) in
  Printf.printf "Content of the request : %s\n" content; 
  let content = "id=10000&title=coucou" in
  Ocsigen_http_client.raw_request 
    ~http_method:Ocsigen_http_frame.Http_header.POST
    ~content:(Some (Ocsigen_stream.of_string content))
    ~content_length: (Int64.of_int (String.length content))
    ~headers:headers (* (Http_headers.add Http_headers.content_type content_type headers)  *)
    ~host:connection.host
    ~inet_addr
    ~uri
    ()
    () >>= fun frame -> 
          match frame.Ocsigen_http_frame.frame_content with
              None -> Printf.printf "@@@ PANIC!\n"; failwith "Empty body"
            | Some data ->  Printf.printf "@@@ OK man\n"; Ocsigen_stream.string_of_stream (Ocsigen_stream.get data) 
  
	      *)
