open Types

let create_doodle access_key_id secret_access_key = 
  {
    http_method = "POST" ; 
    http_host = "doodle.com/api1"; 
    http_uri = "/"; 
    access_key_id = access_key_id ; 
    secret_access_key = secret_access_key ; 
  }