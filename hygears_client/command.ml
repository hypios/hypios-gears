(*
 * hyGears - database
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)

open Lwt

open Hygears_misc.Utils

open Connection


let list_problems connection =
    Ocsigen_http_client.get ~https:connection.https ~host:connection.host ~uri:"/problem/json" ()
        >>= fun frame -> 
            match frame.Ocsigen_http_frame.frame_content with
                None -> failwith "Server down"
              | Some data -> Ocsigen_stream.get data >>> Ocsigen_stream.string_of_stream
                     >>= fun c -> Json_io.json_of_string c >>> return

 
