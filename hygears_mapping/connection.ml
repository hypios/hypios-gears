

type t = 
    {
      host: string ;
      username : string ;
      password : string ; 
      auth : string ; 
    }
    
let create_key username password = {
        host = "88.190.12.149" ;
        username = username ;
        password = password ;
        auth= (Netencoding.Base64.encode username) ^ ":" ^ (Netencoding.Base64.encode password) ;
}

