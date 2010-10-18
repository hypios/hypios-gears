open Printf
open Connection


(*
  GET /json/_db__/__graph_kind__/__graph_subkind__/__actor_id_
  *)
  
let get_json connection db graph_kind graph_subkind actor_id = 
  Effector.get connection (sprintf "/json/%s/%s/%s/%Ld" db graph_kind graph_subkind actor_id)
