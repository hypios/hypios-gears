(*
 * hyGears - medline
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)

(* Standalone CURL getter; to be replaced by a Lwt friendly lib for the gear *)

(* Target URL: 

if ($xml = simplexml_load_'http(file://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmax=0&usehistory=y&term=' . urlencode($argv[1]))){
  if ($xml = simplexml_load_file("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&retmode=xml&query_key={$xml->QueryKey}&WebEnv={$xml->WebEnv}&retstart=0&retmax=10")){
    $docs = $xml->DocSum;
  }
}

*)

open Xmlm

open Types 
open Misc

let prerequest term = 
  let target = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmax=0&usehistory=y&field=auth&term=" ^ (Curl.escape term) in
  
  let writer accum data =
    Buffer.add_string accum data;
    String.length data in
  
  let connection = Curl.init () in
  
  Curl.setopt connection (Curl.CURLOPT_URL target);
  
  let result = Buffer.create 16384 in
  
  Curl.set_writefunction connection (writer result);
  Curl.perform connection; 
  Curl.cleanup connection; 
  
  let r = Buffer.contents result in 
  
  extract_information r

  
let request query_key web_env callback = 
  let target = Printf.sprintf "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&query_key=%s&WebEnv=%s&retstart=0&retmax=-1" query_key web_env in
  
  let writer accum data =
    Buffer.add_string accum data;
    String.length data in
  
  let connection = Curl.init () in
  
  Curl.setopt connection (Curl.CURLOPT_URL target);
    
  Curl.set_writefunction connection callback ;
  Curl.perform connection; 
  Curl.cleanup connection
  
