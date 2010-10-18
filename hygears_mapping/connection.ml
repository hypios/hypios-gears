

type t = 
    {
      host: string ;
      username : string ;
      password : string ; 
      auth : string ; 
    }
    
let create_key username password = {
        host = "sd-19613.dedibox.fr" ;
        username = username ;
        password = password ;
        auth= "Basic " ^ "(" ^ (Netencoding.Base64.encode username) ^ ":" ^ (Netencoding.Base64.encode password) ^ ")" ;
}

