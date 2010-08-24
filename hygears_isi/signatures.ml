
module type AGGREGATOR = 
  sig
    type t 
    val empty : t 
    val append : string -> string -> t -> t
  end
