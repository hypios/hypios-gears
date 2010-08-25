


module Connection =
struct 
  type t 
  external create : unit -> t = "ocaml_sphinx_connect"
end

module Command = 
  struct 
    external query : Connection.t -> string -> string -> unit = "ocaml_sphinx_query"
  end
