(*
 * hyGears - doodle // OUT OF LIB
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Misc

let _ = 
  debug "@@@ Hello\n" ; 
  let connection = Connection.create "" "" in
  let token = Command.Create.exec connection in 
  ( )
