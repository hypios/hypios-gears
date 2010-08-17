(*
 * hyGears - medline
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)

(* FS handler *)

open Misc

let uid = 
  let mutex = Mutex.create () in 
  let cid = ref 0 in 
  (fun () -> 
    Mutex.lock mutex ;
    incr cid; 
    let v = !cid in 
    Mutex.unlock mutex ; v)
   
let fresh_file () = 
  let id = uid () in 
  let prefix = Unix.time () 
  >>> int_of_float 
  >>> (fun current_date -> if current_date < 0 then - current_date else current_date) in
  Printf.sprintf "%d%d" prefix id
