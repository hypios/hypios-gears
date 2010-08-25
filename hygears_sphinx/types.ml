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

