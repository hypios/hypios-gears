open Helper
open Printf


let analyse file = 
  
    let ic = open_in file in 
    try 
      let lexbuf = Lexing.from_channel ic in
      let articles = Lexer.M.lex_isi [] lexbuf in ignore articles ; 
      close_in ic; articles 
	
    with exn -> close_in ic ; raise exn
 
