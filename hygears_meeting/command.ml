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
  }
  
let edit_title meeting title = 
  meeting.title <- title; meeting 

let edit_description meeting description = 
  meeting.description <- description ; meeting 

let append_range meeting range = 
  meeting.ranges <- range :: meeting.ranges ; meeting 
  

let remove_range meeting range = 
  meeting.ranges <- range :: meeting.ranges ; meeting 

let add_participant meeting participant = 
  meeting.participants <- (participant, { accepted_ranges = []; rejected_ranges = [] }) :: meeting.participants ; meeting

let remove_participant meeting participant = 
  meeting.participants <- List.filter (fun (p,_) -> p <> participant) meeting.participants ; meeting

let accept_range meeting participant range = 
  let _, participation = List.find (fun (p,_) -> p = participant) meeting.participants in
  participation.accepted_ranges <- range :: participation.accepted_ranges ; 
  participation.rejected_ranges <- List.filter (fun r -> r.date <> range.date && r.moment <> range.moment) participation.rejected_ranges ; 
  meeting 
  
let reject_range meeting participant range =
  let _, participation = List.find (fun (p,_) -> p = participant) meeting.participants in
  participation.accepted_ranges <- List.filter (fun r -> r.date <> range.date && r.moment <> range.moment) participation.accepted_ranges  ; 
  participation.rejected_ranges <- range :: participation.accepted_ranges ;
  meeting 


(* Retrieval methods *)

let find_concensus meeting = 
  List.fold_left (fun remaining (_, participation) ->
    List.fold_left (fun remaining range -> 
      (* <> ??? *)
      List.filter (fun r -> r.date <> range.date && r.moment <> range.moment) remaining)
      remaining participation.rejected_ranges
  ) meeting.ranges meeting.participants 



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
  
  let preferences_map = List.fold_left (fun m (_, participation) -> 
    
    let m' = List.fold_left (fun acc range -> 
      let weight = try RangeMap.find range acc with Not_found -> 0 in
      RangeMap.add range (weight-1) acc 
    ) m participation.rejected_ranges in 

 
    let m'' = List.fold_left (fun acc range -> 
      let weight = try RangeMap.find range acc with Not_found -> 0 in
      RangeMap.add range (weight+1) acc 
    ) m' participation.accepted_ranges in 
    
    m''

  ) (List.fold_left (fun acc range -> RangeMap.add range 0 acc ) RangeMap.empty meeting.ranges) meeting.participants in 

  let preferences_list = RangeMap.fold (fun range weight acc -> (range, weight) :: acc) preferences_map [] in

  List.sort (fun (_, w1) (_, w2) -> w1 - w2) preferences_list 
    
