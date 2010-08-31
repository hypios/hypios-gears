(*
 * hyGears - zementa
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                  
 *)

type t = 
    {
      host : string ; 

      username : string ;
      api_key : string ; 
    }

let create api_key = 
  {
    host = "api.madmimi.com" ;

    api_key = api_key ; 
  }

let params connection =
	[
		("username", connection.username);
		("api_key", connection.api_key);
	]
