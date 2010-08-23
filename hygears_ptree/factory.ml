module CharMap = Map.Make (Char)

module Make = functor (Data: Signatures.V) ->
  struct
    type e = Data.t
    type t = Node of (e list * t CharMap.t)

    let empty = Node ( [],  CharMap.empty )

    let insert elem tree =
      let rec create_derivation elem path =
        if String.length path = 0 then
         Node ([elem], CharMap.empty)
        else
          (
            let switch = path.[0] in
            let suffix = String.sub path 1 (String.length path - 1) in 

           Node ([], (CharMap.add switch (create_derivation elem suffix) CharMap.empty))
          ) in

      let rec insert_internal path tree =
        match tree with Node (elements, children) ->
        match String.length path with
          0 ->  Node (elem :: elements, children)
        | l ->  let switch = path.[0] in
                let suffix = String.sub path 1 (l - 1) in
                try 
                    let new_child = insert_internal suffix (CharMap.find switch children) in
                    Node (elements, CharMap.add switch new_child children)
                with Not_found ->  Node (elements, CharMap.add switch (create_derivation elem suffix) children)
        in
      let path = Data.to_string elem in
      insert_internal path tree

    let insert_list elem_list tree =
      List.fold_left (fun tree elem -> insert elem tree) tree elem_list

    let remove elem tree = 
      let rec remove_internal path tree : t option=
        match tree with
              | Node (elements, children) ->
                  match String.length path with
                     | 0 -> 
                        let new_elements = List.filter (fun e -> e <> elem) elements in
                        ( match (List.length new_elements = 0), (CharMap.is_empty children) with 
                              true, true -> None
                            | _ -> Some (Node (new_elements, children)))
                     | l -> 
                        let switch = path.[0] in
                        let suffix = String.sub path 1 (l-1) in
                        let new_child =
                            try
                                remove_internal suffix (CharMap.find switch children)
                            with Not_found -> None in
                            
                        match new_child with
                          Some child -> Some (Node (elements, CharMap.add switch child children))
                        | None -> (match (List.length elements = 0), (CharMap.is_empty (CharMap.remove switch children)) with
                                      true, true -> None 
                                      | _ -> Some ( Node (elements, CharMap.remove switch children))
                                  )
                                  
              in 
        match remove_internal (Data.to_string elem) tree with 
            Some t -> t
          | None -> empty

    let rec search path tree =
      match String.length path with
        0 -> tree
      | length -> match tree with
                  Node (_, children) ->
                    let suffix = String.sub path 1 (length - 1) in
                    try search suffix (CharMap.find path.[0] children)
                    with Not_found -> empty

    let map _ _ = failwith "todo"
    
    let rec fold f acc tree =
      match tree with
      Node (elem_list, children) -> CharMap.fold (fun _ tree acc -> fold f acc tree) children (List.fold_left f acc elem_list)

  end