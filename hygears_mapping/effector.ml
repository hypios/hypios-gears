open Lwt

open Connection




(* let get ?https ?port ?headers ~host ~uri () =
  Ocsigen_lib.get_inet_addr host >>= fun inet_addr ->
  raw_request
    ?https
    ?port
    ?headers
    ~http_method:Ocsigen_http_frame.Http_header.GET
    ~content:None
    ~host:(match port with None -> host | Some p -> host^":"^string_of_int p)
    ~inet_addr
    ~uri
    ()
    () *)

let get connection uri =
        Printf.printf "%s\n" uri;
        Ocsigen_http_client.get ~host:connection.host ~uri () 
        >>= fun frame -> 
          match frame.Ocsigen_http_frame.frame_content with
              None -> failwith "Server down"
            | Some data ->  Ocsigen_stream.string_of_stream (Ocsigen_stream.get data) 
                
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

let post connection uri content =
        post_urlencoded ~host:connection.host ~uri:uri ~content:content ()
         
