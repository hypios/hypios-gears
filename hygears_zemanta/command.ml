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
    "format", format; 
    "return_images", "0"; 
    "return_categories", "0"; 
    "return_rdf_links", "0";
    "articles_limit", "0"; 
  ]

let suggests ?(format = "json") connection text = 
  Effector.send connection [
    "method", "zemanta.suggest" ; 
    "api_key", connection.api_key ; 
    "text", text ;
    "format", format ;
    "return_images", "0"; 
    "return_categories", "0"; 
    "return_rdf_links", "0";
    "articles_limit", "1"; 
  ]



