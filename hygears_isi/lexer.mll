(* File lexer.mll *)
{
  open Helper
  open Signatures
  open Printf
  exception Eof

  module Make = functor (Aggregator: AGGREGATOR) -> 
    struct 
}


let line_contents = [ ^ '\n' ]
let endline =  [ '\n' ]

let end = eof | "EF"  

let key = "AU " | "AF " | "BA " | "CA " | "GP " | "TI " | "ED " | "SO " | "SE " | "BS " | "LA " | "DT " | "CT " | "CY " | "HO " | "Cl " | "SP " | "DE " | "ID " | "AB " | "C1 " | "RP " | "EM " | "CR " | "NR " | "TC " | "PU " | "PI " | "PA " | "SN " | "BN " | "J9 " | "JI " | "PD " | "PY " | "VL " | "IS " | "PN " | "SU " | "SI " | "BP " | "EP " | "AR " | "PG " | "DI " | "SC " | "GA " | "UT "

rule lex_isi set = parse     
  | end         { set }  
  
  | "FN"        { forget_line lexbuf ; lex_isi set lexbuf }
  | "VR"        { forget_line lexbuf ; lex_isi set lexbuf }
  | "PT "        { 
                   let journal_type = glob_line "" lexbuf in 
		   printf "Journal type reloaded: %s\n" journal_type ; 
                   let article = lex_article ( Aggregator.append "PT" journal_type Aggregator.empty ) "PT" lexbuf in
                   lex_isi (article :: set) lexbuf 
                }
  | endline     { lex_isi set lexbuf }
                   
and glob_line acc = parse 
  | line_contents*          { glob_line (acc ^ (Lexing.lexeme lexbuf)) lexbuf } 
  | endline                 { acc }
  
and forget_line = parse 
  | line_contents  { forget_line lexbuf }
  | endline         { () }
  
and lex_article attrs current_key = parse 
  | "ER"        { forget_line lexbuf; attrs}
  | key         { 
                  let key = Lexing.lexeme lexbuf in 
                  let l = glob_line "" lexbuf in lex_article (Aggregator.append key l attrs) key lexbuf  }
  | "  "        { 
                  let l = glob_line "" lexbuf in lex_article (Aggregator.append current_key l attrs) current_key lexbuf  }                                     
  | _           { attrs }          
 

{
end
}
