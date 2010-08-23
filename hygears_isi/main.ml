open Helper
open Printf
let _ = 

    let file = Sys.argv.(1) in
    let ic = open_in file in 
  
    try 
        let lexbuf = Lexing.from_channel ic in
        let articles = Lexer.lex_isi ArticleSet.empty lexbuf in ignore articles ; 
        close_in ic; 

	ArticleSet.iter (fun value -> printf "Article hitted\n"; 
	  AttributesMap.iter (fun k v -> printf "%s: " k; List.iter (printf "%s ") v ;
	    printf "\n") value ; 
	  
	) articles 
	  
	
    with exn -> printf "An error occured: %s" (Printexc.to_string exn); close_in ic 
 
