(*
 * hyGears - meeting
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Lwt 
open Misc

type date = { year: int ; month: int; day: int } with orm

let d2date d = 
  CalendarLib.Date.make d.year d.month d.day 

let date2d date = 
 {
   year = CalendarLib.Date.year date ; 
   month = CalendarLib.Date.month date >>> CalendarLib.Date.int_of_month ; 
   day = CalendarLib.Date.day_of_month date ; 
 }
  
module Period = 
  struct 
    type t =  
	{  
	  date : date ;
	  moment : string ; 
	} with orm

    let compare p1 p2 =
      match CalendarLib.Date.compare (d2date p1.date) (d2date p2.date) with 
	| 0 -> String.compare p1.moment p2.moment
	| c -> c

    let to_string p = 
      (CalendarLib.Printer.Date.sprint "%A, %B %d, %Y " (d2date p.date)) ^ p.moment
	
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
    

