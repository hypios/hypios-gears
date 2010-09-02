(*
 * hyGears - doodle
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)


let v = {{
    <poll xmlns="http://doodle.com/xsd1"> [
      <type> "TEXT" 
      <hidden> "false" 
      <levels> "2" 
      <title> "PPP" 
      <description> "yuml"
      <initiator> [ 
        <name> "PAUL" ]
      <options> [
	<option> "Pasta" 
        <option> "Pizza"
        <option> "Polenta"
      ] 
    ]
  }} 



let xml_to_string xml = 
  let b = Buffer.create 256 in
  let f = Buffer.add_string b in
  let open_markup tag attrs = f ("<" ^ tag); List.iter (fun (n, v) -> f " "; f n; f "=\""; f v; f "\"") attrs in
  Ocamlduce.Print.serialize
    ~start_elem:(fun tag attrs -> open_markup tag attrs; f ">")
    ~end_elem:(fun tag -> f ("</" ^ tag ^ ">"))
    ~empty_elem:(fun tag attrs ->
      open_markup tag attrs; f ("></" ^ tag ^ ">"))
    ~text:f
    xml ;
  Buffer.contents b
  
let _ = 
  Printf.printf "This is the request: %s\n" (xml_to_string v)
  
