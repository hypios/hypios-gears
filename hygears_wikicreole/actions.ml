
(*
  module type INTERFACE = sig
        val render : string -> XHTML.M.elt list Lwt.t
  end
  
module IMPLEMENTATION = struct
    *)

open Lwt
open XHTML.M
  
(* open Lexer *)
  
let (>>>) f g = g f 



let convert_to_utf8 s = 
  let op = String.make 1 (Char.chr 222) in 
  let cl = String.make 1 (Char.chr 221) in 
  let cd = String.make 1 (Char.chr 146) in
  let cp = String.make 1 (Char.chr 249) in
  let s = Str.global_replace (Str.regexp_string cp) "*" (Str.global_replace (Str.regexp_string cd) "'" (Str.global_replace (Str.regexp_string op) "'" (Str.global_replace (Str.regexp_string cl) "'" s))) in
  try 
    Netconversion.verify `Enc_utf8 s ; s 
  with _ ->
    (* debug' "@@@ Pas de l'utf8: %s!\n" s ;  *)
    Netconversion.convert ~in_enc:`Enc_iso88591 ~out_enc:`Enc_utf8 s

      
      
(** OCaml strings are already in Latin1 ? *)
let make_string (s:string) = 
  Lwt.return (convert_to_utf8 s)

  (*
let element (c : Xhtmltypes_duce.inlines Lwt.t list) = 
  Lwt_util.map_serial (fun x -> x) c >>= fun c ->
  Lwt.return << (map {: c :} with i -> i) >>
  *)

let element c  = 
  Lwt_util.map_serial (fun x -> x) c >>= fun c ->
  Lwt.return (List.map (fun i -> i) c)

(*
let element2 (c : << [ Xhtmltypes_duce.a_content* ] >> list) = 
  << (map {: c :} with i -> i) >>
  *)

let element2 c= List.map (fun i -> i) c


(* I don't know how to do a function for 
    try
      let c = convert_to_utf8 (List.assoc name attribs) in
      << {...=c} >>
    with Not_found -> atts
that typechecks with ocamlduce ... ?
*)
let parse_class_and_id attribs =
  let at1 =
    try
      let c = convert_to_utf8 (List.assoc "class" attribs) in
      [a_class [c]]
    with Not_found -> []
  and at2 =
    try
      let c = convert_to_utf8 (List.assoc  "id" attribs) in
      [a_id c]
    with Not_found -> []
  in
  ( at1 @ at2)

  let parse_common_attribs attribs =
  let at1 = parse_class_and_id attribs 
  and at2 =
    try
      let c = convert_to_utf8 (List.assoc  "style" attribs) in
      [a_style c]
    with Not_found -> []
    
  in
  ( at1 @ at2)

let length_of_string s =
  let len = String.length s in
  if len = 0 then raise Not_found;
  if s.[len-1] = '%' then
    `Percent (int_of_string (String.sub s 0 (len-1)))
  else
    `Pixels (int_of_string s)
    
  
let parse_table_attribs attribs =
  let atts = parse_common_attribs attribs
  and at1 =
    try
      let c = int_of_string (List.assoc  "border" attribs) in
      [ a_border c]
    with _ -> []
  and at2 =
    try
      let c = length_of_string (List.assoc  "cellpadding" attribs) in
      [ a_cellpadding c]
    with _ -> []
  and at3 =
    try
      let c = length_of_string (List.assoc  "cellspacing" attribs) in
      [ a_cellspacing c ]
    with _ -> []
(*  let atts =
    try
      let c = convert_to_utf8 (List.assoc  "frame" attribs) in
      << {frame=c}++atts >>
    with Not_found -> atts
  in
  let atts =
    try
      let c = convert_to_utf8 (List.assoc  "rules" attribs) in
      << {rules=c}++atts >>
    with Not_found -> atts
  in*)
  and at4 =
    try
      let c = convert_to_utf8 (List.assoc  "summary" attribs) in
      [ a_summary c]
    with Not_found -> []
  and at5 =
    try
      let c = length_of_string (List.assoc  "width" attribs) in
      [ a_width c] 
    with _ -> []
  in
  atts @ at1 @ at2 @ at3 @ at4 @ at5

let parse_valign_attrib attribs (* : << { valign =? Xhtmltypes_duce.valign } >> *) =
  try
    let c = List.assoc "valign" attribs in
    match c with
      "top" -> [ a_valign `Top]
    | "middle" -> [ a_valign `Middle ]
    | "bottom" -> [ a_valign `Bottom ]
    | "baseline" -> [ a_valign `Baseline ]
    | _ -> []
  with Not_found -> []

let parse_align_attrib attribs (* : << { align =? Xhtmltypes_duce.align } >> *) =
  try
    let c = List.assoc "align" attribs in
    match c with
      "left" -> [ a_align `Left ]
    | "center" -> [ a_align `Center ]
    | "right" -> [ a_align `Right ]
    | "justify" -> [ a_align `Justify ]
    | "char" -> [ a_align `Char ]
    | _ -> []
  with Not_found -> []


let parse_scope_attrib attribs =
(*  : << { scope =? Xhtmltypes_duce.scope } >> = *)
  try
    let c = List.assoc "scope" attribs in
    match c with
      "row" -> [ a_scope `Row ]
    | "col" -> [ a_scope `Col ]
    | "rowgroup" -> [ a_scope `Rowgroup ]
    | "colgroup" -> [ a_scope `Colgroup ]
    | _ -> []
  with Not_found -> []


let parse_table_row_attribs attribs =
  let atts = parse_common_attribs attribs
  and at1 =
    try
      let c = List.assoc  "char" attribs in
      [ a_char c.[0] ] (* TODO: sure ? *)
    with _ -> []
    and at2 =
    try
      let c = length_of_string (List.assoc  "charoff" attribs) in
      [ a_charoff c ]
    with _ -> []
  and atts2 = parse_valign_attrib attribs in
  let atts3 = parse_align_attrib attribs in
  atts @ at1 @ at2 @ atts2 @ atts3 @ atts 


let parse_table_cell_attribs attribs =
  let atts = parse_common_attribs attribs
  and at1 =
    try
      let c = List.assoc  "char" attribs in
      [ a_char c.[0]]
    with _ -> []
  and at2  =
    try
      let c = length_of_string (List.assoc  "charoff" attribs) in
      [ a_charoff c ]
    with Not_found -> []
  and at3  =
    try
      let c = convert_to_utf8 (List.assoc  "abbr" attribs) in
      [ a_abbr c ]
    with Not_found -> []
  and at4 =
    try
      let c = convert_to_utf8 (List.assoc  "axis" attribs) in
      [ a_axis c ]
    with Not_found -> []
  and at5 =
    try
      let c = int_of_string (List.assoc  "colspan" attribs) in
      [ a_colspan c ]
    with Not_found -> []
  and at6 =
    try
      let c = convert_to_utf8 (List.assoc  "headers" attribs) in
      [ a_headers [c] ]
    with Not_found -> []
  and at7 =
    try
      let c = int_of_string (List.assoc  "rowspan" attribs) in
      [ a_rowspan c ]
    with Not_found -> []
  and atts2 = parse_valign_attrib attribs
  and atts3 = parse_align_attrib attribs
  and atts4 = parse_scope_attrib attribs in
 atts @ at1 @ at2 @ at3 @ at4 @ at5 @ at6 @ at7 @ atts2 @ atts3 @ atts4

let list_builder = function
  | [] -> Lwt.return (li [], [])
  | a::l ->
      let f (c, 
             (l ),
             attribs) =
        let atts = parse_common_attribs attribs in
        element c >>= fun r ->
        (match l with
          | Some v -> v >>= fun v -> Lwt.return v
          | None -> Lwt.return << [] >>) >>= fun l ->
  Lwt.return (li ~a:atts (r @ [l]))
(*          << <li $list:  atts$> $r$ $l$ </li> >>   *)
      (* {{ <li (atts)>[ !r !l ] }} *)

      in
      f a >>= fun r ->
      Lwt_util.map_serial f l >>= fun l ->
      Lwt.return (r, l) (* << [ r !{: l :} ] >> *)
   
let descr_builder = function
  | [] -> Lwt.return (dt [], [])
  | a::l ->
      let f (istitle, d, attribs) =
        let atts = parse_common_attribs attribs in
        element d >>= fun d ->
        if istitle
        then Lwt.return (dt ~a:atts d)
        else Lwt.return (dd ~a:atts d)
      in
      f a >>= fun r ->
      Lwt_util.map_serial f l >>= fun l ->
      Lwt.return (r, l)  (* << [ r !{: l :} ] >> *)

(*
let inline (x : Xhtmltypes_duce.a_content)
    : Xhtmltypes_duce.inlines
    = << {: [ x ] :} >>
*)



(********************************)
(* builders. Default functions: *)

let strong_elem = (fun attribs a -> 
                     let atts = parse_common_attribs attribs in
                     element a >>= fun r ->
                     Lwt.return (strong ~a:atts r))

let em_elem = (fun attribs a -> 
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (em ~a:atts r))

let monospace_elem = (fun attribs a -> 
                        let atts = parse_common_attribs attribs in
                        element a >>= fun r ->
                        Lwt.return (tt ~a:atts r))

let underlined_elem = (fun attribs a -> 
                         let atts = parse_common_attribs attribs in
                         element a >>= fun r ->
        Lwt.return (span 
          ~a: ((a_class ["underlined"]) :: atts) r))

let linethrough_elem = (fun attribs a -> 
                          let atts = parse_common_attribs attribs in
                          element a >>= fun r ->
        Lwt.return (span 
          ~a: ((a_class ["linethrough"]) :: atts) r))

let subscripted_elem = (fun attribs a -> 
                          let atts = parse_common_attribs attribs in
                          element a >>= fun r ->
                          Lwt.return (sub ~a:atts r))

let superscripted_elem = (fun attribs a -> 
                            let atts = parse_common_attribs attribs in
                            element a >>= fun r ->
                            Lwt.return (sup ~a:atts r))


let a_elem =
  (fun attribs addr c ->
(*     (c : << [ Xhtmltypes_duce.a_content* ] >> Lwt.t list) ->  *)
       let atts = parse_common_attribs attribs in
       Lwt_util.map_serial (fun x -> x) c >>= fun c ->
        Lwt.return
        (a ~a:( (a_href (uri_of_string addr)) :: atts) (element2 c )))



let br_elem = (fun attribs -> 
      let atts = parse_class_and_id attribs in
      Lwt.return (br ~a:atts ()))


let img_elem =
  (fun attribs addr alt -> 
     let atts = parse_common_attribs attribs in
     Lwt.return 
       (img
          ~src:addr
          ~alt: (convert_to_utf8 alt)
          ~a: atts
            ))


let tt_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (tt ~a:atts r ))

let nbsp = Lwt.return (convert_to_utf8 " ")

let endash = Lwt.return (convert_to_utf8 "–")

let emdash = Lwt.return (convert_to_utf8 "—")

let p_elem = (fun attribs a -> 
                let atts = parse_common_attribs attribs in
                element a >>= fun r ->
                Lwt.return (p ~a:atts r))

let pre_elem = (fun attribs a ->
                  let atts = parse_common_attribs attribs in
                  Lwt.return
        (pre ~a:atts [pcdata
          (convert_to_utf8 (String.concat "" a))]))

let h1_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (h1 ~a:atts r))

let h2_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (h2 ~a:atts r))

let h3_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (h3 ~a:atts r))

let h4_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (h4 ~a:atts r))

let h5_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (h5 ~a:atts r))

let h6_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 element a >>= fun r ->
                 Lwt.return (h6 ~a:atts r))

  
let ul_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
      list_builder a >>= fun (li, lis) ->
            Lwt.return (ul ~a:atts li lis))

let ol_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 list_builder a >>= fun (li, lis) ->
                 Lwt.return (ol ~a:atts li lis))

let dl_elem = (fun attribs a ->
                 let atts = parse_common_attribs attribs in
                 descr_builder a >>= fun (dt, dts) ->
                 Lwt.return (dl ~a:atts dt dts))

let hr_elem = (fun attribs -> 
                 let atts = parse_common_attribs attribs in
                 Lwt.return (hr ~a:atts ()))

let table_elem =
  (fun attribs l ->
     let atts = parse_table_attribs attribs in
     match l with
       | [] -> Lwt.return << [] >>
       | row::rows ->
           let f (h, attribs, c) =
             let atts = parse_table_cell_attribs attribs in
             element c >>= fun r ->
             Lwt.return
                 (if h 
                  then th ~a:atts r
                  else td ~a:atts r)
           in
           let f2 (row, attribs) = match row with
             | [] -> Lwt.return (tr (td []) [])
             | a::l -> 
                 let atts = parse_table_row_attribs attribs in
                 f a >>= fun r ->
                 Lwt_util.map_serial f l >>= fun l ->
                 Lwt.return (tr ~a:atts r l )
           in
           f2 row >>= fun row ->
           Lwt_util.map_serial f2 rows >>= fun rows ->
           Lwt.return (table ~a:atts row  rows))

(*
let inline = (fun x -> (x : Xhtmltypes_duce.a_contents Lwt.t
                        :> Xhtmltypes_duce.inlines Lwt.t))
  *)

let default_plugin =  (fun (_name : string) ->
                        (true,
                         (fun _ _args _content ->
                            Lexer.A_content 
                              (
                               Lwt.return [ "" ]
                        )
                     )))


let plugin_action = (fun _ _ _ _ _ _ -> ())

let link_action = (fun _ _ _ _ _ -> ())

let error = (fun (s : string) -> Lwt.return (b [pcdata s]))

let span_elem = (fun attribs a ->
                    let atts = parse_common_attribs attribs in
                    element a >>= fun r ->
                    Lwt.return (span ~a:atts r))

type a_content = A_CONTENT
let a_content _ = A_CONTENT
let wrap_a_content f attribs inlines =
  ignore (f attribs inlines);
  A_CONTENT
let wrap_a_content_no_inlines f attribs =
  ignore (f attribs);
  A_CONTENT
  
let actions  = 
  let make_string s = a_content (make_string s) 
  in
    
    {
      Lexer.chars = make_string;
      strong_elem = wrap_a_content strong_elem; 
      em_elem = wrap_a_content em_elem ;
      a_elem = wrap_a_content_no_inlines a_elem ;
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
      Lwt.return (List.map (fun i -> i) r)
    
  (* >>= fun r -> Lwt_list.map_s  (fun x -> x >>= fun c -> return << <div> c >>)  r 
  >>= fun l -> return << {: l :} >> 
*)

(*
end

include (IMPLEMENTATION : INTERFACE)
*)

