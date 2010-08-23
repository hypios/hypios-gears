open Helper
open Printf


let analyse file : ArticleMap.t = 
  try 
    let ic = open_in file in 
    
    let lexbuf = Lexing.from_channel ic in
    let articles = Lexer.lex_isi ArticleMap.empty lexbuf in ignore articles ; 
    
    close_in ic; articles 
 
    with exn -> close_in ic ; raise exn
 
