type contact = string

module TreeContents =
 struct
  type t = contact

  let to_string contact =
    contact
end

module Tree = Factory.Make (TreeContents)

let _ = 
  let my_tree = Tree.empty in 
  let my_tree = Tree.insert "toto" my_tree in

  Tree.fold (fun () elem -> Printf.printf "%s\n" elem) () my_tree