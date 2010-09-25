 (*
  * Madmimi client lib
  *
  * Fait en speed le 24 septembre 2010; william@hypios.com
  *)


open Connection

module ListManagement =
  struct 
    let new_audience connection name = 
      
      let request =
	[
	  "name", name ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	 ] in
	
      Effector.send connection "/audience_lists" request 
      
  end
