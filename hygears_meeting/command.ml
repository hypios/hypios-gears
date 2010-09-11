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
    id = 0 ; 
    title = title ;
    description = description ;
    owner = owner ;

    ranges = [] ; 
    participants = [] ; 
  }
  
let edit_title meeting title = 
  { meeting with title = title }

let edit_description meeting description = 
  { meeting with description = description }

let append_range meeting range = 
  { meeting with ranges = range :: meeting.ranges }

let remove_range meeting range = 
  { meeting with ranges = range :: meeting.ranges }

let add_participant meeting participant = 
  { meeting with participants = (participant, { accepted_ranges = []; rejected_ranges = [] }) :: meeting.participants }

let remove_participant meeting participant = 
  { meeting with participants = List.filter (fun (p,_) -> p <> participant) meeting.participants }

let accept_range meeting participant range = 
  let _, participation = List.find (fun (p,_) -> p = participant) meeting.participants in
  let participation2 = { participation with accepted_ranges = range :: participation.accepted_ranges } in
  let participation3 = { participation2 with rejected_ranges = List.filter (fun r -> r.date <> range.date && r.moment <> range.moment) participation2.rejected_ranges } in
  { meeting with participants = (participant, participation3) :: meeting.participants } 

let reject_range meeting participant range = 
  let _, participation = List.find (fun (p,_) -> p = participant) meeting.participants in
  let participation2 = { participation with accepted_ranges = List.filter (fun r -> r.date <> range.date && r.moment <> range.moment) participation.rejected_ranges } in
  let participation3 = { participation2 with rejected_ranges = range :: participation2.accepted_ranges } in
  { meeting with participants = (participant, participation3) :: meeting.participants } 



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
