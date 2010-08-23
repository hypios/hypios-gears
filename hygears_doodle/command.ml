
module CreateDoodle = 
struct 
  let doodle_exec connection domain = 
    let request = 
      ("AWSAccessKeyId", connection.access_key_id) :: 
	("Action", "CreateDomain") ::
	("DomainName", domain) ::
	("SignatureMethod", "HmacSHA1") ::
	("SignatureVersion", "2") ::
	("Timestamp", current_timestamp ()) :: 
	("Version", "2009-04-15") :: [] in 
   
    let signature = Authentication.sign connection request in
    let signature = String.sub signature 0 (String.length signature - 1) in

    let full_request = ("Signature", signature) :: request in
      try 
	Effector.send connection full_request 
      with Http_client.Http_error (_, s) -> raise (Error s)

end