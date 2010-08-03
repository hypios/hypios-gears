(*
 * hyGears - misc
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)


open Types 

let create login password = 
  { login = login ;
    password = password ; 
    prefix = "http://localhost:8890" }

