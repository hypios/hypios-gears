(* File lexer.mll *)
{
  open Helper
  open Printf
  exception Eof
}


let line_contents = [ ^ '\n' ]
let endline =  [ '\n' ]

let end = eof | "EF"  

let key = "AU" | "AF" | "BA" | "CA" | "CA" | "GP" | "TI" | "ED" | "SO" | "SE" | "BS" | "LA" | "DT" | "CT" | "CY" | "HO" | "Cl" | "SP" | "DE" | "ID" | "AB" | "C1" | "RP" | "EM" | "CR" | "NR" | "TC" | "PU" | "PI" | "PA" | "SN" | "BN" | "J9" | "JI" | "PD" | "PY" | "VL" | "IS" | "PN" | "SU" | "SI" | "BP" | "EP" | "AR" | "PG" | "DI" | "SC" | "GA" | "UT"

rule lex_isi map = parse     
  | end         { map }  
  | "FN"        { forget_line lexbuf ; lex_isi map lexbuf }
  | "VR"        { forget_line lexbuf ; lex_isi map lexbuf }
  | "PT"        { 
                   let journal_type = glob_line "" lexbuf in 
                   let article = lex_article (AttributesMap.empty >>> append "PT" journal_type) "PT" lexbuf in
                   lex_isi map lexbuf 
                }
  | endline     { lex_isi map lexbuf }
                   
and glob_line acc = parse 
  | line_contents          { glob_line (Lexing.lexeme lexbuf) lexbuf } 
  | endline                { acc }
  
and forget_line = parse 
  | line_contents  { forget_line lexbuf }
  | endline         { () }
  
and lex_article attrs current_key = parse 
  | "ER"        { forget_line lexbuf; attrs}
  | key         { 
                  let key = Lexing.lexeme lexbuf in 
                  let l = glob_line "" lexbuf in lex_article (append key l attrs) key lexbuf  }
  | "  "        { 
                  let l = glob_line "" lexbuf in lex_article (append current_key l attrs) current_key lexbuf  }                                     
  | _           { attrs }          
 

