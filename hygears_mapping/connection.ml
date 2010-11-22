

type t = 
    {
      host: string ;
      port : int ; 
      username : string ;
      password : string ; 
      auth : string ; 
    }
    
let create host port username password = {
  host = host ;
  port = port ;
        username = username ;
        password = password ;
        auth = Netencoding.Base64.encode (Printf.sprintf "%s:%s" username password) ;
}

