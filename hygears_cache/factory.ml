(*
 * hyGears - cache
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

(* This is a synchronous cache module. 
       Call to get : 
          / on success, return the value binded in the cache 
          / on fail, create the value with O.create key, 
                     store the value in db with O.save 
                     return the created value *)

(* This is not meant to be used as a db cache, rather to protect an advanced module (that does a lot of processing) in the middleware *)

open Lwt 

(*
module Stupid = functor (O: Signatures.V) -> 
  struct
 
    type key = O.key 
    type value = O.value 
    type diff = O.diff

    let get key  = O.create key 
    let update diff value = failwith "Not implemented in this naive version"
            
  end
*)

module Make = functor (O: Signatures.V) -> 
    struct 

    type key = O.key 
    type value = O.value 
    type diff = O.diff 

    module NativeCache = Ocsigen_cache.Make (O)

    let cache = new NativeCache.cache O.create O.max_size

    let get (key:key) = cache#find key

    let update key diff = 
        cache#find key >>=
        O.update key diff >>= fun updated_value -> 
            cache#remove key ;
            cache#add key updated_value ; return updated_value

    let clear () =
        cache#clear ()

        end
