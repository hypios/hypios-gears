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
        Ocsigen_http_client.get ~host:connection.host ~uri () 
        >>= fun frame -> 
          match frame.Ocsigen_http_frame.frame_content with
              None -> failwith "Server down"
            | Some data ->  Ocsigen_stream.string_of_stream (Ocsigen_stream.get data) 
                           
        
