(*
 * hyGears - meeting
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

(* Types are extremely basic here, to cope with orm restrictions. For more advanced types, revert to commits < 9/11 2010 *)

open Lwt 
open Misc

type user_id = int with orm
type meeting_id = int64 with orm 

type date = { year: int ; month: int; day: int } with orm

type period =  
    {  
      date : date ;
      moment : string ; 
    } with orm 

let d2date d = 
  CalendarLib.Date.make d.year d.month d.day 

let date2d date = 
 {
   year = CalendarLib.Date.year date ; 
   month = CalendarLib.Date.month date >>> CalendarLib.Date.int_of_month ; 
   day = CalendarLib.Date.day_of_month date ; 
 }
  
let period_to_string p = 
  (CalendarLib.Printer.Date.sprint "%A, %B %d, %Y " (d2date p.date)) ^ p.moment
	
type status = Accepted | Rejected | Unknown (* Used as support type, not core *)

type meeting = {
  mutable id : meeting_id ; 
  mutable title : string ; 
  mutable description : string ;
  owner : user_id ; 
  mutable participants : (user_id * ((period list) * (period list))) list ;
  mutable ranges : period list ;
  mutable chosen_date : period ;
  mutable is_open : bool ;
} with orm  


let range_equal r1 r2 = 
  r1.moment = r2.moment 
  && r1.date.year = r2.date.year 
    && r1.date.month = r2.date.month
      && r1.date.day = r2.date.day

    

