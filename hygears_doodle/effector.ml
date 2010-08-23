open Xml



let put_doodle connection namegraph turtle = 
  let writer accum data =
    Buffer.add_string accum data;
    String.length data in
    
  let conn = Curl.init () in

  let request is_hidden =
       Element ("poll", ["xmlns", "http://doodle.com/xsd1"],
                 [
                      Element ("type", [], [ PCData "TEXT" ]);
                      Element ("hidden", [], [ PCData "false" ]);
                      Element ("levels", [] , [PCData "2"]);
                      Element ("title", [], [PCData] "PPP");
                      Element ("description", [], [PCData "yum!"]);
                      Element ("initiator", [], 
                      [
                       Element (name, [], [PCData "Paul"]);
                      ]);
                      Element ("options", [], 
                      [
                       Element ("option", [], [PCData "Pasta"]);
                      ]
                      );

                 ]) in


  request true >>> Xml.xml_to_string in
  let data = Printf.sprintf  (Curl.escape turtle) (Curl.escape namegraph) in

    Curl.setopt conn (Curl.CURLOPT_POSTFIELDS data); 
    Curl.setopt conn (Curl.CURLOPT_URL (connection.http_host ^ "polls"));
    
    let result = Buffer.create 16384 in
      
      Curl.set_writefunction conn (writer result);
      Curl.perform conn; 
      Curl.cleanup conn; 
      Buffer.contents result