 (*
  * Madmimi client lib
  *
  * Fait en speed le 24 septembre 2010; william@hypios.com
  *)

open Lwt 

open Connection

let post_string ?https ?port ?(headers = Http_headers.empty)
    ~host ~uri ~content ~content_type () =
 
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


let send connection uri content = 
  post_urlencoded ~host:connection.endpoint ~uri:uri ~content:content ()
