module type V =
  sig
    type t

    val to_string : t -> string
  end

module type T =
  sig
    type t
    type e

    val empty : t
    val insert : e -> t -> t
    val insert_list : e list -> t -> t
    val remove : e -> t -> t
    val search : string -> t -> t
    val map : (e -> e) -> t -> t
    val fold : ('a -> e -> 'a) -> 'a -> t -> 'a

    val head : t -> e list 
  end
