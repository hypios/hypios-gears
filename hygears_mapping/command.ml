open Printf
open Connection


(*
  GET /json/_db__/__graph_kind__/__graph_subkind__/__actor_id_
  *)
  (* /rest/<db>/instance/{publication_id}/ to get a publication (or project)
  
  
    /rest/<db>/actor/{author_id}/  to get an author *)
    
    (*88.190.12.149/rest/projects/actor/2 *)
let db_to_string = function 
  | `Publications -> "publications" 
  | `Projects -> "projects" 
  | `Actor -> "actor"

let get_json connection db graph_kind graph_subkind actor_id = 
  
  let db = db_to_string db in
  
  let graph_kind = match graph_kind with 
    | `AA -> "AA" in

  let graph_subkind = match graph_subkind with 
    | `b -> "b" 
    | `c -> "c" 
    | `n -> "n" 
    | `s -> "s" 
    | `a -> "a" in

  Effector.get connection (sprintf "/rest/%s/%s/%s/actor/%Ld/" db graph_kind graph_subkind actor_id)

open Json_type

module Instance = 
  struct 
    
    let create connection db body = 
      let db = db_to_string db in
      Effector.post connection (sprintf "/rest/%s/instance/" db) body 

    let update connection db instance_id body = 
      let db = db_to_string db in
      Effector.put connection (sprintf "/rest/%s/instance/%Ld/" db instance_id) body 
	
    let delete connection db instance_id body =
          let db = db_to_string db in
          Effector.delete connection (sprintf "/rest/%s/instance/%Ld/" db instance_id) body
 
  end


module Actor = 
  struct 
    
    let create connection db body = 
      let db = db_to_string db in
      Effector.post connection (sprintf "/rest/%s/actor/" db) body 

    let update connection db actor_id body = 
      let db = db_to_string db in
      Effector.put connection (sprintf "/rest/%s/actor/%Ld/" db actor_id) body 
	
    let delete connection db actor_id body = 
      let db = db_to_string db in
      Effector.delete connection (sprintf "/rest/%s/actor/%Ld/" db actor_id) body 
    
  end


module InstanceActor = 
  struct 
    
    let create connection db instance_id actor_id body =
            let db = db_to_string db in
            Effector.post connection (sprintf "/rest/%s/instance/%Ld/actor/%Ld/" db instance_id actor_id) body
   
   
   let update connection db instance_id actor_id body =
           let db = db_to_string db in
           Effector.put connection (sprintf "/rest/%s/instance/%Ld/actor/%Ld/" db instance_id actor_id) body        
           
   let delete connection db instance_id actor_id body =
           let db = db_to_string db in
           Effector.delete connection (sprintf "/rest/%s/instance/%Ld/actor/%Ld/" db instance_id actor_id) body   
    
  end


module Concept =
  struct
  
     let create connection db body =
             let db = db_to_string db in
             Effector.post connection (sprintf "/rest/%s/concept/" db ) body
             
     let update connection db md_id body =
             let db = db_to_string db in
             Effector.put connection (sprintf "/rest/%s/concept/%Ld/" db md_id) body
  
     let delete connection db actor_id body = 
             let db = db_to_string db in
             Effector.delete connection (sprintf "/rest/%s/actor/%Ld/" db actor_id) body 
     
  end

module InstanceConcept =
  struct
  
     let create connection db instance_id md_id body =
             let db = db_to_string db in
             Effector.put connection (sprintf "/rest/%s/instance/%Ld/concept/%Ld/" db instance_id md_id) body
             
     
     let update connection db instance_id md_id body =
             let db = db_to_string db in
             Effector.put connection (sprintf "/rest/%s/instance/%Ld/concept/%Ld/" db instance_id md_id) body

    let delete connection db instance_id md_id body =
            let db = db_to_string db in
            Effector.delete connection (sprintf "/rest/%s/instance/%Ld/concept/%Ld/" db instance_id md_id) body
  end
  
