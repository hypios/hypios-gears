(*
 * hyGears - zementa
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                  
 *)

type t = 
    {
      host : string ; 
      uri : string ; 

      api_key : string ; 
    }

let create api_key = 
  {
    host = "api.zemanta.com" ; 
    uri = "/services/rest/0.0/" ; 

    api_key = api_key ; 
  }
