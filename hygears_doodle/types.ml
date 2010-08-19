type connection = 
    { 
      http_method : string ; 
      http_host : string ;
      http_uri : string ;
      secret_access_key : string ; 
      access_key_id : string; 
    }

type attribute = { name : string; value : string }

exception Error of string 
