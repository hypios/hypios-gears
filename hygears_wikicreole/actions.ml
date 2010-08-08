

open Lwt

open Lexer
  
let (>>>) f g = g f 



(***)
let make_string s = Lwt.return (Ocamlduce.Utf8.make s)

let element (c : Xhtmltypes_duce.inlines Lwt.t list) = 
  Lwt_util.map_serial (fun x -> x) c >>= fun c ->
  Lwt.return {{ (map {: c :} with i -> i) }}

let element2 (c : {{ [ Xhtmltypes_duce.a_content* ] }} list) = 
  {{ (map {: c :} with i -> i) }}


(* I don't know how to do a function for 
    try
      let c = Ocamlduce.Utf8.make (List.assoc name attribs) in
      {{ {...=c} }}
    with Not_found -> atts
that typechecks with ocamlduce ... ?
*)
let parse_common_attribs attribs =
  let at1 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc "class" attribs) in
      {{ {class=c} }}
    with Not_found -> {{ {} }}
  and at2 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "id" attribs) in
      {{ {id=c} }}
    with Not_found -> {{ {} }}
  in
  ({{ at1++at2 }} : Xhtmltypes_duce.coreattrs)

let parse_table_attribs attribs =
  let atts = parse_common_attribs attribs
  and at1 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "border" attribs) in
      {{ {border=c} }}
    with Not_found -> {{ {} }}
  and at2 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "cellpadding" attribs) in
      {{ {cellpadding=c} }}
    with Not_found -> {{ {} }}
  and at3 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "cellspacing" attribs) in
      {{ {cellspacing=c} }}
    with Not_found -> {{ {} }}
(*  let atts =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "frame" attribs) in
      {{ {frame=c}++atts }}
    with Not_found -> atts
  in
  let atts =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "rules" attribs) in
      {{ {rules=c}++atts }}
    with Not_found -> atts
  in*)
  and at4 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "summary" attribs) in
      {{ {summary=c} }}
    with Not_found -> {{ {} }}
  and at5 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "width" attribs) in
      {{ {width=c} }}
    with Not_found -> {{ {} }}
  in
  ({{ atts++at1++at2++at3++at4++at5 }} : Xhtmltypes_duce.table_attrs)

let parse_valign_attrib attribs : {{ { valign =? Xhtmltypes_duce.valign } }} =
  try
    let c = List.assoc "valign" attribs in
    if c="top"
    then {{ {valign="top"} }}
    else
    if c="middle"
    then {{ {valign="middle"} }}
    else
    if c="bottom"
    then {{ {valign="bottom"} }}
    else
    if c="baseline"
    then {{ {valign="baseline"} }}
    else {{ {} }}
  with Not_found -> {{ {} }}

let parse_align_attrib attribs : {{ { align =? Xhtmltypes_duce.align } }} =
  try
    let c = List.assoc "align" attribs in
    if c="left"
    then {{ {align="left"} }}
    else
    if c="center"
    then {{ {align="center"} }}
    else
    if c="right"
    then {{ {align="right"} }}
    else
    if c="justify"
    then {{ {align="justify"} }}
    else
    if c="char"
    then {{ {align="char"} }}
    else {{ {} }}
  with Not_found -> {{ {} }}

let parse_scope_attrib attribs : {{ { scope =? Xhtmltypes_duce.scope } }} =
  try
    let c = List.assoc "scope" attribs in
    if c="row"
    then {{ {scope="row"} }}
    else
    if c="col"
    then {{ {scope="col"} }}
    else
    if c="rowgroup"
    then {{ {scope="rowgroup"} }}
    else
    if c="colgroup"
    then {{ {scope="colgroup"} }}
    else {{ {} }}
  with Not_found -> {{ {} }}

let parse_table_row_attribs attribs =
  let atts = parse_common_attribs attribs
  and at1 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "char" attribs) in
      {{ {char=c} }}
    with Not_found -> {{ {} }}
    and at2 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "charoff" attribs) in
      {{ {charoff=c} }}
    with Not_found -> {{ {} }}
  and atts2 = parse_valign_attrib attribs in
  let atts3 = parse_align_attrib attribs in
  ({{ atts++at1++at2++atts2++atts3++atts }} : Xhtmltypes_duce.align_attrs)

let parse_table_cell_attribs attribs =
  let atts = parse_common_attribs attribs
  and at1 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "char" attribs) in
      {{ {char=c} }}
    with Not_found -> {{ {} }}
  and at2  =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "charoff" attribs) in
      {{ {charoff=c} }}
    with Not_found -> {{ {} }}
  and at3  =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "abbr" attribs) in
      {{ {abbr=c} }}
    with Not_found -> {{ {} }}
  and at4 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "axis" attribs) in
      {{ {axis=c} }}
    with Not_found -> {{ {} }}
  and at5 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "colspan" attribs) in
      {{ {colspan=c} }}
    with Not_found -> {{ {} }}
  and at6 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "headers" attribs) in
      {{ {headers=c} }}
    with Not_found -> {{ {} }}
  and at7 =
    try
      let c = Ocamlduce.Utf8.make (List.assoc  "rowspan" attribs) in
      {{ {rowspan=c} }}
    with Not_found -> {{ {} }}
  and atts2 = parse_valign_attrib attribs
  and atts3 = parse_align_attrib attribs
  and atts4 = parse_scope_attrib attribs in
  ({{ atts++at1++at2++at3++at4++at5++at6++at7++atts2++atts3++atts4 }}
     : Xhtmltypes_duce.thd_attribs)

let list_builder = function
  | [] -> Lwt.return {{ [ <li>[] ] }} (*VVV ??? *)
  | a::l ->
      let f (c, 
             (l : Xhtmltypes_duce.flows Lwt.t option),
             attribs) =
        let atts = parse_common_attribs attribs in
        element c >>= fun r ->
        (match l with
          | Some v -> v >>= fun v -> Lwt.return v
          | None -> Lwt.return {{ [] }}) >>= fun l ->
        Lwt.return
          {{ <li (atts)>[ !r
                   !l ] }}
      in
      f a >>= fun r ->
      Lwt_util.map_serial f l >>= fun l ->
      Lwt.return {{ [ r !{: l :} ] }}

let descr_builder = function
  | [] -> Lwt.return {{ [ <dt>[] ] }} (*VVV ??? *)
  | a::l ->
      let f (istitle, d, attribs) =
        let atts = parse_common_attribs attribs in
        element d >>= fun d ->
        if istitle
        then Lwt.return {{ <dt (atts)>[ !d ] }}
        else Lwt.return {{ <dd (atts)>[ !d ] }}
      in
      f a >>= fun r ->
      Lwt_util.map_serial f l >>= fun l ->
      Lwt.return {{ [ r !{: l :} ] }}

let inline (x : Xhtmltypes_duce.a_content)
    : Xhtmltypes_duce.inlines
    = {{ {: [ x ] :} }}




(********************************)
(* builders. Default functions: *)

let strong_elem = (fun attribs a -> 
                     let atts = parse_common_attribs attribs in
                     element a >>= fun r ->
                     Lwt.return {{ [<strong (atts)>r ] }})

let em_elem = (fun attribs a -> 
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<em (atts)>r] }})

let monospace_elem = (fun attribs a -> 
                        let atts = parse_common_attribs attribs in
                        element a >>= fun r ->
                        Lwt.return {{ [<tt (atts)>r] }})

let underlined_elem = (fun attribs a -> 
                         let atts = parse_common_attribs attribs in
                         element a >>= fun r ->
                         Lwt.return {{ [<span ({class="underlined"} ++
                                                   atts)>r] }})

let linethrough_elem = (fun attribs a -> 
                          let atts = parse_common_attribs attribs in
                          element a >>= fun r ->
                          Lwt.return {{ [<span ({class="linethrough"} ++
                                                    atts)>r] }})

let subscripted_elem = (fun attribs a -> 
                          let atts = parse_common_attribs attribs in
                          element a >>= fun r ->
                          Lwt.return {{ [<sub (atts)>r] }})

let superscripted_elem = (fun attribs a -> 
                            let atts = parse_common_attribs attribs in
                            element a >>= fun r ->
                            Lwt.return {{ [<sup (atts)>r] }})

let a_elem =
  (fun attribs addr 
     (c : {{ [ Xhtmltypes_duce.a_content* ] }} Lwt.t list) -> 
       let atts = parse_common_attribs attribs in
       Lwt_util.map_serial (fun x -> x) c >>= fun c ->
       Lwt.return
           {{ [ <a ({href={: Ocamlduce.Utf8.make addr :}}++atts)>{: element2 c :} ] }})



let br_elem = (fun attribs -> 
                 let atts = parse_common_attribs attribs in
                 Lwt.return {{ [<br (atts)>[]] }})

let img_elem =
  (fun attribs addr alt -> 
     let atts = parse_common_attribs attribs in
     Lwt.return 
       {{ [<img
              ({src={: Ocamlduce.Utf8.make addr :} 
                   alt={: Ocamlduce.Utf8.make alt :}}
               ++
                   atts)
            >[] ] }})

let tt_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<tt (atts)>r ] }})

let nbsp = Lwt.return (Ocamlduce.Utf8.make " ")

let endash = Lwt.return (Ocamlduce.Utf8.make "–")

let emdash = Lwt.return (Ocamlduce.Utf8.make "—")

let p_elem = (fun attribs a -> 
                let atts = parse_common_attribs attribs in
                element a >>= fun r ->
                Lwt.return {{ [<p (atts)>r] }})

let pre_elem = (fun attribs a ->
                  let atts = parse_common_attribs attribs in
                  Lwt.return
                    {{ [<pre (atts)>{:Ocamlduce.Utf8.make (String.concat "" a):}] }})

let h1_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<h1 (atts)>r] }})

let h2_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<h2 (atts)>r] }})

let h3_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<h3 (atts)>r] }})

let h4_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<h4 (atts)>r] }})

let h5_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<h5 (atts)>r] }})

let h6_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return {{ [<h6 (atts)>r] }})

let ul_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 list_builder a >>= fun r ->
                 Lwt.return {{ [<ul (atts)>r] }})

let ol_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 list_builder a >>= fun r ->
                 Lwt.return {{ [<ol (atts)>r] }})

let dl_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 descr_builder a >>= fun r ->
                 Lwt.return {{ [<dl (atts)>r] }})

let hr_elem = (fun attribs -> 
                 let atts = parse_common_attribs attribs in
                 Lwt.return {{ [<hr (atts)>[]] }})

let table_elem =
  (fun attribs l ->
     let atts = parse_table_attribs attribs in
     match l with
       | [] -> Lwt.return {{ [] }}
       | row::rows ->
           let f (h, attribs, c) =
             let atts = parse_table_cell_attribs attribs in
             element c >>= fun r ->
             Lwt.return
                 (if h 
                  then {{ <th (atts)>r }}
                  else {{ <td (atts)>r }})
           in
           let f2 (row, attribs) = match row with
             | [] -> Lwt.return {{ <tr>[<td>[]] }} (*VVV ??? *)
             | a::l -> 
                 let atts = parse_table_row_attribs attribs in
                 f a >>= fun r ->
                 Lwt_util.map_serial f l >>= fun l ->
                 Lwt.return {{ <tr (atts)>[ r !{: l :} ] }}
           in
           f2 row >>= fun row ->
           Lwt_util.map_serial f2 rows >>= fun rows ->
           Lwt.return {{ [<table (atts)>[<tbody>[ row !{: rows :} ] ] ] }})

let inline = (fun x -> (x : Xhtmltypes_duce.a_contents Lwt.t
                        :> Xhtmltypes_duce.inlines Lwt.t))

let default_plugin =  (fun (name : string) ->
                        (true,
                         (fun _ args content ->
                            Lexer.A_content 
                              (
                               Lwt.return {{ {: "" :} }}))
                        )
                     )


let plugin_action = (fun _ _ _ _ _ _ -> ())

let link_action = (fun _ _ _ _ _ -> ())

let error = (fun (s : string) -> Lwt.return {{ [ <b>{: s :} ] }})

let span_elem = (fun attribs a ->
                    let atts = parse_common_attribs attribs in
                    element a >>= fun r ->
                    Lwt.return {{ [<span (atts)>r] }})

let actions  = 
 
    
    {
      Lexer.chars = make_string;
      strong_elem = strong_elem; 
      em_elem = em_elem ;
      a_elem = a_elem ;
      make_href = (fun () a fragment -> match fragment with 
                     | None -> a
                     | Some f -> a ^"#"^f);
      br_elem = br_elem; 
      img_elem = img_elem; 
      tt_elem = tt_elem;
      monospace_elem = monospace_elem; 
      underlined_elem = underlined_elem;
      linethrough_elem = linethrough_elem;
      subscripted_elem = subscripted_elem;
      superscripted_elem = superscripted_elem;
      nbsp = nbsp; 
      endash = endash;
      emdash = emdash; 
      p_elem = p_elem;
      pre_elem = pre_elem;
      h1_elem = h1_elem;
      h2_elem = h2_elem;
      h3_elem = h3_elem;
      h4_elem = h4_elem;
      h5_elem = h5_elem;
      h6_elem = h6_elem;

      ul_elem = ul_elem;

      ol_elem = ol_elem;
      dl_elem = dl_elem; 
      hr_elem = hr_elem;
      table_elem = table_elem;
      inline = inline;

      plugin = default_plugin ; 

      plugin_action = plugin_action;
      link_action = link_action;
      error = error ;
    } 

let render source =
  Lexer.from_string () actions source 
 >>=
fun l ->
  Lwt_util.map_serial (fun x -> x) l >>= fun r ->
  Lwt.return {{ (map {: (r : Xhtmltypes_duce.flows list) :} with i -> i) }}
    
  (* >>= fun r -> Lwt_list.map_s  (fun x -> x >>= fun c -> return {{ <div> c }})  r 
  >>= fun l -> return {{ {: l :} }} 
  *)
