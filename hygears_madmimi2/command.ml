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


    (* /audience_lists/{list_to_be_deleted}&_method=delete [POST] *)
    let delete_audience connection name = 
       let request =
	[
	  "_method", "delete" ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	 ] in
       Effector.send connection (sprintf "/audience_lists/%s" name) request 


    (* /audience_lists/{name_of_list}/add?email={email_to_add} [POST] *)
    let add_audience connection name email = 
      let request = 
	[
	  "email", email ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	] in
      Effector.send connection (sprintf "/audience_lists/%s/add" name) request

 
    let remove_audience connection name email = 
      let request = 
	[
	  "email", email ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	] in
      Effector.send connection (sprintf "/audience_lists/%s/remove" name) request

      
    (* MEEEEERDE ils n'ont pas de méthodes pour retrouver les membres d'une liste?? *)
    
      
  end


module Mailer =
  struct 
    (* From is either the raw email or at the Display Name <email@domain.com> *)
    (* Because you are sending to a list you will need to include the [[unsubscribe]] (or [[opt_out]] alias) macro with raw_html and raw_plain_text. If you are using raw_html you will also need to include the [[tracking_beacon]] (or [[peek_image]] alias) macro. 
       and the [[unsubscribe]]  [[tracking_beacon]] macro somewhere inside the body, so we can track your email
If you’re sending to a list, that you have the [[unsubscribe]] 
*)

    let send_to_list connection list from subject content = 
      let request = 
	[
	  "from", from ;
	  "promotion_name", "raw_plain_text" ;
	  "subject", subject ; 
	  "raw_html", content ; 
	  "list_name", list ; 
	  "username", connection.username ;
	  "api_key", connection.key ;
	] in
      Effector.send connection "/mailer/to_list" request

  end
