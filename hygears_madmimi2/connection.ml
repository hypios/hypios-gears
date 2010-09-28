type t = {
  username : string; 
  key : string ; 
  endpoint : string ;
}


let create username key = 
  {
    username = username ; 
    key = key ; 
    endpoint = "api.madmimi.com"
  }
