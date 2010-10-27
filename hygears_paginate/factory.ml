(* 30 09 2010 -- pagination module *)

open Lwt 

module type PARAMS = 
  sig
    val cache_size : int 
    val page_size : int
  end

(* Key has to be unique *)
module type DATA = 
  sig 
    type key 
    type t 
    val create : key -> t list Lwt.t
  end

(*****************************************************)
(* Stupid pagination module                          *)
(*****************************************************)

module Make = 
  functor (Params : PARAMS) -> 
    functor (Data : DATA) -> 
       struct 
	 (* On crée un cache des résultats *)
	 
	 module Cache = Hygears_cache.Factory.Make (
	   struct 
	     type key = Data.key
	     type value = int * Data.t list array 
	     type diff = unit 

	     let max_size = Params.cache_size

	     let create key =
	       Data.create key 
	       >>= fun elts -> 
	       let rec dispatch pages acc = 
		 function 
		   | (_, []) -> (match acc with [] -> pages | _ -> (List.rev acc) :: pages)
		   | (0, l) -> dispatch ((List.rev acc) :: pages) [] (Params.page_size, l)
		   | (n, h::t) -> dispatch pages (h::acc) (n-1, t) in 
	       let pages = dispatch [] [] (Params.page_size, elts) in 
	       return (List.length elts, Array.of_list (List.rev pages))
	       	       
	     let insert _ _ = assert false 
	     let update _ _ = assert false 
	   end ) 


	  (* No page = empty page, to catch the dirty index_out_of_bounds exception *)
	 let get_page key page_id = 
	   Cache.get key >>= fun (size, array) -> let page = try array.(page_id) with _ -> [] in return (size, page)

	 let clean key = 
	   Cache.remove key 

	 let clear () =
	   Cache.clear ()

       end
