(* File lexer.mll *)
{
  open Helper
  exception Eof
}


let line_contents = [ ^ '\n']
let endline =  [ '\n' ]

rule lex_isi map = parse       
  | "FN"        { forget_line () }
  | "VR"        { forget_line () }
  | "PT"        { let l = glob_line [] lexbuf in List.iter (Printf.printf "%s") l ; () }
    
and glob_line acc = parse 
  | line_contents   { glob_line (Lexing.lexeme lexbuf :: acc) lexbuf }
  | endline         { acc } 
  
and forget_line = parse 
  | line_contents   { forget_line lexbuf }
  | endline         { () }
  
  
(*    
  |'  '        { Blank}
  |'FN'        { File_name }
  |'VR'        { Version_number }  
  |'PT'        { Publication_type }
  |'AU'        { Authors }  
  |'AF'        { Author_full_name }
  |'BA'        { Book_authors }
  |'CA'        { Group_authors }
  |'GP'        { Book_group_authors }   
  |'TI'        { Document_title }
  |'ED'        { Editors }
  |'SO'        { Publication_name }
  |'SE'        { Book_series_title }
  |'BS'        { Book_series_subtitle }
  |'LA'        { Language }
  |'DT'        { Document_type }
  |'CT'        { Conference_title }
  |'CY'        { Conference_date }
  |'HO'        { Conference_host }
  |'CL'        { Conference_location }
  |'SP'        { Conference_sponsors }
  |'DE'        { Author_keywords }
  |'ID'        { Keywords_plus }
  |'AB'        { Abstract }
  |'C1'        { Author_address }
  |'RP'        { Reprint_address }
  |'EM'        { Mail_address }
  |'CR'        { Cited_references }
  |'NR'        { Cited_reference_count }
  |'TC'        { Times_cited }
  |'PU'        { Publisher }
  |'PI'        { Publisher_city }
  |'PA'        { Publisher_address }
  |'SN'        { Issn }
  |'BN'        { Usbn }
  |'J9'        { Character_source_abbreviation }
  |'JI'        { Iso_source_abbreviation }
  |'PD'        { Publication_date }
  |'PY'        { Year_published }
  |'VL'        { Volume }
  |'IS'        { Issue }
  |'PN'        { Part_number }
  |'SU'        { Supplement }
  |'SI'        { Special_issue }
  |'BP'        { Beginning_page }
  |'EP'        { Ending_page }
  |'AR'        { Article_number }
  |'PG'        { Page_count }
  |'DI'        { Digital_object_identifier }
  |'SC'        { Subject_category }
  |'GA'        { Document_delivery_number }
  |'UT'        { Unique_article_identifier }
  |'ER'        { End_of_record }
  |'EF'        { EOL }

*)
  