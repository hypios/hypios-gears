
module Types =
  struct 
    (* Alter those types at your own risk .. *)
    type sphinx_client
    type sphinx_wordinfo =
	{
	  word : string ; 
	  docs : int ; 
	  hits : int ; 
	}
    type occurence = 
	{
	  doc_id : int ; 
	  weight : int ; 
	}
    type sphinx_result = 
	{ 
	  total : int ; 
	  total_found : int ; 
	  
	  num_words : int ;
	  words : sphinx_wordinfo array ;
	  
	  num_occurences : int ; 
	  occurences : occurence array ;
	}
  end


module Connection =
struct 
  open Types 
  external create : unit -> sphinx_client = "ocaml_sphinx_connect"
  external set_server : sphinx_client -> string -> int -> unit = "ocaml_sphinx_set_server"
end

module Command = 
  struct 
    open Types 
    external set_field_weights : sphinx_client -> int -> string array -> int array -> unit = "ocaml_sphinx_set_field_weights"
    external set_select : sphinx_client -> string -> unit = "ocaml_sphinx_set_select" 
    external query : sphinx_client -> string -> string -> sphinx_result = "ocaml_sphinx_query"
  end
