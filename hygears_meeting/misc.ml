(*
 * hyGears - meeting
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

let (>>>) f g = g f 

let warning fmt = 
  Printf.ksprintf (fun s -> Ocsigen_messages.warning s) fmt

let error fmt = 
  Printf.ksprintf (fun s -> Ocsigen_messages.errlog s) fmt

let debug fmt = 
  Printf.ksprintf (fun s -> print_string s; flush stdout) fmt


