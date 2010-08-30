(*
 * hyGears - zementa
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                  
 *)

open Connection

let preferences ?(format = "json") connection () = 
  Effector.send connection [
    "method", "zemanta.preferences" ; 
    "api_key", connection.api_key ; 
    "format", format 
  ]

let suggests ?(format = "json") connection text = 
  Effector.send connection [
    "method", "zemanta.suggest" ; 
    "api_key", connection.api_key ; 
    "text", text ;
    "format", format 
  ]



