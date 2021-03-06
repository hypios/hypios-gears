module type V =
  sig
    type t
    val to_strings : t -> string list
  end

module type T =
  sig
    type t
    type e

    val empty : t
    val insert : ?replace:bool -> e -> t -> t
    val insert_list : e list -> t -> t
    val remove : e -> t -> t
    val search : string -> t -> t
    val map : (e -> e) -> t -> t
    val fold : ('a -> e -> 'a) -> 'a -> t -> 'a

    val head : t -> e list 
  end
