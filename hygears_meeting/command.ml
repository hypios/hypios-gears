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
  

let create_meeting title description owner =

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
    
    
