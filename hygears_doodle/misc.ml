let (>>>) f g = g f

let debug fmt = 
  Printf.ksprintf (fun s -> print_string s; flush stdout) fmt

let display fmt = 
  Printf.ksprintf (fun s -> print_string s; flush stdout) fmt
