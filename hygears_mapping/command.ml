open Printf
open Connection


(*
  GET /json/_db__/__graph_kind__/__graph_subkind__/__actor_id_
  *)
  
let get_json connection db graph_kind graph_subkind actor_id = 
  let db = match db with `Publications -> "publications" in
  let graph_kind = match graph_kind with `AA -> "AA" in
  let graph_subkind = match graph_subkind with `b -> "b" in
  Effector.get connection (sprintf "/json/%s/%s/%s/?a=%%20Pierga%%20%%20J-Y%%20%%20JY" db graph_kind graph_subkind)
