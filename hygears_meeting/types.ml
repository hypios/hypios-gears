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
	  starting_date : CalendarLib.Printer.Date.t ;
	  starting_time : CalendarLib.Printer.Time.t ;
	  
	  ending_date : CalendarLib.Printer.Date.t ; 
	  ending_time : CalendarLib.Printer.Time.t ; 
	}

    let compare p1 p2 =
      match CalendarLib.Date.compare p1.starting_date p2.starting_date with 
	| 0 ->
	  ( match CalendarLib.Time.compare p1.starting_time p2.starting_time with 
	    | 0 -> 
	      ( 
		match CalendarLib.Date.compare p1.ending_date p2.ending_date with 
		  | 0 -> CalendarLib.Time.compare p1.ending_time p2.ending_time 
	     	  | c -> c 
	      )
	    | c -> c 
	  )
	| c -> c

    let to_string p = 
      (CalendarLib.Printer.Date.sprint "%A, %B %d, %Y " p.starting_date) ^ ( 
      CalendarLib.Printer.Date.sprint "%A, %B %d, %Y" p.ending_date )
	
	
  end

module PeriodSet = Set.Make (Period)
module ParticipantMap = Map.Make (String)

type user = string
  
type status = Accepted | Rejected | Unknown (* Used as support type, not core *)

type participation = {
  accepted_ranges : PeriodSet.t ;
  rejected_ranges : PeriodSet.t ;
}

type meeting = {
  title : string ; 
  description : string ;
  owner : user ; 
  participants : participation ParticipantMap.t ;
  ranges : PeriodSet.t ;
}
    

