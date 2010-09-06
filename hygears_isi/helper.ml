(* Helper *)

let (>>>) f g = g f 

module AttributesMap = Map.Make (String)

module Article = 
struct 
  type t = string list AttributesMap.t
  (* We need a global order on lists *)
  let compare = AttributesMap.compare (fun l1 l2 ->
    let c1 = String.concat "" l1 in 
    let c2 = String.concat "" l2 in 
    String.compare c1 c2 
  ) 
end

module ArticleSet = Set.Make (Article)


let size map = AttributesMap.fold (fun k v acc -> acc+1) map 0 

let append key value map = 
  Printf.printf "Current map size: %d\n" (size map) ;  
  Printf.printf "Inserting %s -> %s\n" key value; 
  let current = try AttributesMap.find key map with _ -> [] in
  AttributesMap.add key (value :: current) map 
    `
