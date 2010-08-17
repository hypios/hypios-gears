open Helper
open Printf
let _ = 

    let file = Sys.argv.(1) in
    let ic = open_in file in 
  
    try 
        let lexbuf = Lexing.from_channel ic in
        let articles = Lexer.lex_isi ArticleMap.empty lexbuf in ignore articles ; 
        close_in ic; 
    with exn -> printf "An error occured: %s" (Printexc.to_string exn); close_in ic 
 