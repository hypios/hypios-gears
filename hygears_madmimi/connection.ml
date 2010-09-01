(*
 * hyGears - zementa
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                  
 *)

type t = 
	{
		host : string;
		username : string;
		api_key : string;
	}

let create username api_key =
	{
		host = "api.madmimi.com";
		username = username;
		api_key = api_key;
	}
