(*
 * hyGears - database
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

type t = 
    {
      login: string; 
      password :string; 
      prefix: string 
    }

let create server login password = 
  { login = login ;
    password = password ; 
    prefix = server }