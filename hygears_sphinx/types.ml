(*
 * hyGears - sphinx
 *
 * (c) 2010 William Le Ferrand william.le-ferrand@polytechnique.edu
 *
 *)

(* Alter those types at your own risk .. *)

type sphinx_client

type sphinx_wordinfo =
    {
      word : string ; 
      docs : int ; 
      hits : int ; 
    }


type content = IntArray of Int32.t array | Float of float | String of string | Int of Int32.t 

type attributes =
    {
      name : string ; 
      content : content ;
    }

type occurence = 
    {
      doc_id : int64 ; 
      weight : int ;
      attributes : attributes array ;
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

