

let _ = 
  try 

    let connection = Connection.create "" "" in

    let result = register_user connection "william@corefarm.com" "Mr" "William" "Le Ferrand" "warnegia@gmail.com" in
    let profile = fetch_profile connection "william@corefarm.com" in

    let addemail = add_email connection "william@corefarm.com" "william@tmf.com" in 
    let addemail = add_email connection "william@corefarm.com" "william@beouifi.org" in 
      
    let profile = fetch_profile connection "william@corefarm.com" in
      

	  ()
      
  with Curl.CurlException (_, _, s) -> ()


