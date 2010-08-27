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
    title = title ;
    description = description ;
    owner = owner ;

    ranges = PeriodSet.empty ; 
    participants = ParticipantMap.empty 
  }
  
let edit_title meeting title = 
  { meeting with title = title }

let edit_description meeting description = 
  { meeting with description = description }

let append_range meeting range = 
  { meeting with ranges = PeriodSet.add range meeting.ranges }

let remove_range meeting range = 
  { meeting with ranges = PeriodSet.remove range meeting.ranges }

let add_participant meeting participant = 
  { meeting with participants = ParticipantMap.add participant { accepted_ranges = PeriodSet.empty; rejected_ranges = PeriodSet.empty } meeting.participants }

let remove_participant meeting participant = 
  { meeting with participants = ParticipantMap.remove participant meeting.participants }

let accept_range meeting participant range = 
  debug "@@@ Accepting the range %s for participant %s\n" (Period.to_string range) participant ;
  let participation = ParticipantMap.find participant meeting.participants in
  let participation = { participation with accepted_ranges = PeriodSet.add range participation.accepted_ranges } in
  let participation = { participation with rejected_ranges = PeriodSet.remove range participation.rejected_ranges } in
  { meeting with participants = ParticipantMap.add participant participation meeting.participants } 

let reject_range meeting participant range = 
  debug "@@@ Rejecting the range %s for participant %s\n" (Period.to_string range) participant ;
  let participation = ParticipantMap.find participant meeting.participants in
  let participation = { participation with accepted_ranges = PeriodSet.remove range participation.accepted_ranges } in
  let participation = { participation with rejected_ranges = PeriodSet.add range participation.rejected_ranges } in
  { meeting with participants = ParticipantMap.add participant participation meeting.participants } 

let display_participation meeting participant = 
  let participation = ParticipantMap.find participant meeting.participants in
  PeriodSet.iter (fun p -> Printf.printf "%s\n" (Period.to_string p)) participation.accepted_ranges ;
  PeriodSet.iter (fun p -> Printf.printf "%s\n" (Period.to_string p)) participation.rejected_ranges 
  


(* Retrieval methods *)
let find_concensus ?(strong=false) meeting = 
  match strong with 
    | false -> 
      ParticipantMap.fold (fun _ v acc -> PeriodSet.diff acc v.rejected_ranges) meeting.participants meeting.ranges
    | true -> 
      ParticipantMap.fold (fun _ v acc -> PeriodSet.inter acc v.accepted_ranges) meeting.participants meeting.ranges

(* Simple test function for doodle traversal *)
 
let display_ranges meeting = PeriodSet.iter (fun p -> Printf.printf "%s\n" (Period.to_string p)) meeting.ranges  

let display_participants meeting = 
  ParticipantMap.iter (fun user participation -> ()) meeting.participants

let check_status meeting user range = 
  let participation = ParticipantMap.find user meeting.participants in 
  match PeriodSet.mem range participation.accepted_ranges with 
      true -> Accepted 
    | false -> 
      match PeriodSet.mem range participation.rejected_ranges with 
	  true -> Rejected
	| false -> Unknown 
    
    
