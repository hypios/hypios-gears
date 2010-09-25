 (*
  * Madmimi client lib
  *
  * Fait en speed le 24 septembre 2010; william@hypios.com
  *)


(* Remember to do the URI encoding !! *)
open Printf
open Lwt 
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
      >>= fun _ -> return () 

    (* /audience_lists/{list_to_be_deleted}&_method=delete [POST] *)
    let delete_audience connection name = 
       let request =
	[
	  "_method", "delete" ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	 ] in
       Effector.send connection (sprintf "/audience_lists/%s" name) request 
       >>= fun _ -> return () 

    (* /audience_lists/{name_of_list}/add?email={email_to_add} [POST] *)
    let add_audience connection name email = 
      let request = 
	[
	  "email", email ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	] in
      Effector.send connection (sprintf "/audience_lists/%s/add" name) request
	>>= fun _ -> return () 

  let remove_audience connection name email = 
      let request = 
	[
	  "email", email ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	] in
      Effector.send connection (sprintf "/audience_lists/%s/remove" name) request
	>>= fun _ -> return () 
      
  end
