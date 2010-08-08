open Lwt 

type profile = { email: string }

module Feed = 
  struct 
    type key = profile
    type value = string 

    let create profile = 
      Shared.Db.Profile.get_feed profile >>= fun l -> return {{ [] }} 

    let update profile current_feed delta =
      Shared.Db.Profile.insert_event profile delta ; 
      current_feed 
      
  end

module Cache = Synchronous.Make (Feed) 

let _ = 
  Cache.get email ; 
  
