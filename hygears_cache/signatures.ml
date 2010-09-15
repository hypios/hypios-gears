(*
 * hyGears - cache
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Lwt 

module type V = 
sig
  type key
  type value

  type diff
    
  val max_size : int 

  val create : key -> value Lwt.t (* aka load *)
    
  val insert : key -> value -> key Lwt.t  (* aka save *)
  
  val update : key -> diff -> value -> value Lwt.t

end

module type T = 
  sig 
    type key 
    type value 
    type diff

    val get : key -> value Lwt.t
  
    val insert : key -> value -> unit Lwt.t 

    val update : key -> diff -> value Lwt.t

    val clear : unit -> unit
      

    val remove : key -> unit 
  end
