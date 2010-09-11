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
      List.filter (fun r -> r.date <> range.date && r.moment <> range.moment) remaining)
      remaining participation.rejected_ranges
  ) meeting.ranges meeting.participants 
 	
	
(* Simple test function for doodle traversal *)
(*let check_status meeting user range = 
  let participation = ParticipantMap.find user meeting.participants in 
  match PeriodSet.mem range participation.accepted_ranges with 
      true -> Accepted 
    | false -> 
      match PeriodSet.mem range participation.rejected_ranges with 
	  true -> Rejected
	| false -> Unknown 
    
    
*)
