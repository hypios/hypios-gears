(* File lexer.mll *)
{
  open Signatures
  open Printf
  exception Eof

  module Make = functor (Aggregator: AGGREGATOR) -> 
    struct
      
      let strip_key key = 
	printf "Key is %s\n" key ;
	printf "Size of the key: %d\n" (String.length key) ;
	let i = ref 3 in 
	while !i > 0 && key.[!i] = ' ' do decr i done ; 
	String.sub key 0 (!i + 1)
  
}


let line_contents = [ ^ '\n' ]
let endline =  [ '\n' ]

let end = eof

let key = [ 'A' - 'Z' ] [ 'A' - 'Z' ] [  'A' - 'Z' ' ' ] [  'A' - 'Z' ' ' ]
let padding = "      "
let dash = '-' ' '

rule lex_medline set = parse     

  | '\n'        { lex_medline set lexbuf }

  | key dash    { 

    let key = strip_key (String.sub (Lexing.lexeme lexbuf) 0 4) in 
    
    let contents = glob_contents "" lexbuf in
    
    let article = lex_article (Aggregator.append key contents Aggregator.empty) lexbuf in
    lex_medline (article :: set) lexbuf 

                } 
       
  | _ | eof     { set }  

  

 and glob_contents acc = parse 
   | line_contents+     { glob_contents (acc ^ (Lexing.lexeme lexbuf)) lexbuf }
   | endline            { glob_contents2 acc lexbuf }
   | eof                { acc }
  
 and glob_contents2 acc = parse
   | padding            { glob_contents acc lexbuf }
   | "" | eof           { acc }
       
       

and lex_article acc = parse 
   | key dash    { 

    let key = strip_key (String.sub (Lexing.lexeme lexbuf) 0 4) in 
    let contents = glob_contents "" lexbuf in
    lex_article (Aggregator.append key contents Aggregator.empty) lexbuf 		       

   } 
   | eof           { acc } 
   | _           { acc } 
                  


{
  end
}
