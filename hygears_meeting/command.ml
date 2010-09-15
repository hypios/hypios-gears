(*
 * hyGears - meeting
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)


open Misc
open Types

let uid () = 
  Unix.time () >>> string_of_float >>> Digest.string >>> Digest.to_hex 
  

let create title description owner = 
  {
    id = 0L ; 
    title = title ;
    description = description ;
    owner = owner ;

    ranges = [] ; 
    participants = [] ; 
    
    chosen_date = { date = 
                    { year = 0;
                      month = 0;
                      day = 0 };
                    moment = "" };
    is_open = true ;
  }
  
let edit_title meeting title = 
  meeting.title <- title; meeting 

let edit_description meeting description = 
  meeting.description <- description ; meeting 

let append_range meeting range = 
  meeting.ranges <- range :: meeting.ranges ; meeting 
  
let set_chosen_date meeting range =
  meeting.chosen_date <- range ; meeting
  
let set_open meeting =
  meeting.is_open <- true ; meeting
  
let set_closed meeting =
  meeting.is_open <- false ; meeting

let remove_range meeting range = 
  meeting.ranges <- range :: meeting.ranges ; meeting 

let add_participant meeting participant = 
  match List.exists (fun (p, _) -> p = participant) meeting.participants with 
      false -> 
	meeting.participants <- (participant, ([], [])) :: meeting.participants ; meeting
    | true -> meeting



let rec list_filter cmp = 
  function 
    | [] -> []
    | t::q when cmp t -> list_filter cmp q 
    | t::q -> t :: (list_filter cmp q)

(** Those functions lead to segfaults *)
      
let remove_participant meeting participant = 
  match List.remove_assoc participant meeting.participants with 
    | [] -> meeting.participants <- []; meeting
    | l -> meeting.participants <- l ; meeting 

let accept_range meeting participant range = 
  let accepted_ranges, rejected_ranges = List.assoc participant meeting.participants in
  let n_accepted_ranges = range :: accepted_ranges in 
  let n_rejected_ranges = List.filter (fun r -> r.date <> range.date || r.moment <> range.moment) rejected_ranges in 
  meeting.participants <- (participant, (n_accepted_ranges, n_rejected_ranges)) :: List.remove_assoc participant meeting.participants ; 
  meeting
  
let reject_range meeting participant range =
  let accepted_ranges, rejected_ranges = List.assoc participant meeting.participants in
  let n_accepted_ranges = List.filter (fun r -> r.date <> range.date || r.moment <> range.moment) accepted_ranges in 
  let n_rejected_ranges = range :: rejected_ranges in 
  meeting.participants <- (participant, (n_accepted_ranges, n_rejected_ranges)) :: List.remove_assoc participant meeting.participants ; 
  meeting

(* Retrieval methods *)

module Date = 
  struct 
    type t = date 
    let compare d1 d2 = 
      match d1.year - d2.year with 
	  0 -> 
	    ( match d1.month - d2.month with 
		0 -> d1.day - d2.day 
	      | c -> c )
	| c -> c 
  end

module DateMap = Map.Make (Date)

module Range = 
  struct 
    type t = period 
    let compare r1 r2 =
      
      match Date.compare r1.date r2.date with 
	  0 -> String.compare r1.moment r2.moment 
	| c -> c 
	    
	    
  end

module RangeMap = Map.Make (Range) 

let find_concensus meeting  = 
  
  let preferences_map = List.fold_left (fun m (_, (accepted_ranges, rejected_ranges)) -> 
    
    let m' = List.fold_left (fun acc range -> 
      let weight = try RangeMap.find range acc with Not_found -> 0 in
      RangeMap.add range (weight-1) acc 
    ) m rejected_ranges in 

 
    let m'' = List.fold_left (fun acc range -> 
      let weight = try RangeMap.find range acc with Not_found -> 0 in
      RangeMap.add range (weight+1) acc 
    ) m' accepted_ranges in 
    
    m''

  ) (List.fold_left (fun acc range -> RangeMap.add range 0 acc ) RangeMap.empty meeting.ranges) meeting.participants in 

  let preferences_list = RangeMap.fold (fun range weight acc -> (range, weight) :: acc) preferences_map [] in

  List.rev ( List.sort (fun (_, w1) (_, w2) -> w1 - w2) preferences_list ) 
    
