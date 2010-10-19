

type t = 
    {
      host: string ;
      username : string ;
      password : string ; 
      auth : string ; 
    }
    
let create username password = {
        host = "sd-19613.dedibox.fr" ;
        username = username ;
        password = password ;
        auth = Netencoding.Base64.encode (Printf.sprintf "%s:%s" username password) ;
}

