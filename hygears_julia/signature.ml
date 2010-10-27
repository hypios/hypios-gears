
type instance
type actor

type concept = { concept_id : int64 }

module API = 
  struct 
    
  (* 
     POST /concept/add 
     concept_id is unique
  *)
    
  (* 
     POST /actor/add 
     actor_id is unique
  *)

  (* 
     POST /instance/add 
     instance_id is unique
  *)

 (* 
     POST /concept/delete 
     concept_id is unique
  *)
    
  (* 
     POST /actor/delete 
     actor_id is unique
  *)

  (* 
     POST /instance/delete 
     instance_id is unique
  *)


 (* 
     POST /instance/__instance_id__/add/concept/__concept_id__ 
     instance_id is unique
 *)

 (* 
     POST /instance/__instance_id__/add/actor/__actor_id__ 
     instance_id is unique
 *)

    
  (*
    GET /graph/__db__/__graph_kind__/__graph_subkind__/__actor_id__
    *)
    
   
    
    






  end
