(*
 * hyGears - meeting
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Lwt 
open Misc

module Period = 
  struct 
    type t =  
	{  
	  date : CalendarLib.Printer.Date.t ;
	  moment : string ; 
	}

    let compare p1 p2 =
      match CalendarLib.Date.compare p1.date p2.date with 
	| 0 -> String.compare p1.moment p2.moment
	| c -> c

    let to_string p = 
      (CalendarLib.Printer.Date.sprint "%A, %B %d, %Y " p.date) ^ p.moment
	
  end

module PeriodSet = Set.Make (Period)

module UserId = 
  struct 
    type t = int 
    let compare = Pervasives.compare 
  end

module ParticipantMap = Map.Make (UserId)

type status = Accepted | Rejected | Unknown (* Used as support type, not core *)

type participation = {
  accepted_ranges : PeriodSet.t ;
  rejected_ranges : PeriodSet.t ;
}

type meeting = {
  title : string ; 
  description : string ;
  owner : UserId.t ; 
  participants : participation ParticipantMap.t ;
  ranges : PeriodSet.t ;
}
    

