(*
 * hyGears - database
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)


let put_rdf connection namegraph rdf = 
  Factory.put_rdf connection namegraph rdf
    
let put_turtle connection namegraph turtle = 
  Factory.put_turtle connection namegraph turtle 
  
let exec_sparql connection query = 
  Factory.exec_sparql connection query