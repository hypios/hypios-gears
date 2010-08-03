(*
 * hyGears - misc
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *
 *)

open Hygears_misc.Utils

let users connection = Factory.create connection "/DAV/home/users.rdf" "<rdf:RDF
 xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"
 xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"
 xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\">
    <rdf:Description rdf:about=\"http://ggg.milanstankovic.org/foaf.rdf#milstan\">
        <rdf:type rdf:resource=\"http://xmlns.com/foaf/0.1/Person\"/>
        <foaf:firstName>Milan</foaf:firstName>
        <foaf:homepage rdf:resource=\"http://www.milanstankovic.org/\"/>
        <foaf:basedNear rdf:resource=\"http://sws.geonames.org/2988507/\"/>
        <foaf:openid rdf:resource=\"http://milstan.net\"/>
        <foaf:img rdf:resource=\"http://www.milanstankovic.org/img/malaSlika.jpg\"/>
          <foaf:mbox>milan.stankovic@gmail.com</foaf:mbox>
          <foaf:mbox>milstan@gmail.com</foaf:mbox>
            <foaf:mbox>milan@milstan.net</foaf:mbox>
        <foaf:nick>MilStan</foaf:nick>
        <foaf:schoolHomepage rdf:resource=\"http://www.u-psud.fr/\"/>
        <foaf:surname>Stankovic</foaf:surname>
        <foaf:title>Mr</foaf:title>
      <foaf:gender>male</foaf:gender>
        <foaf:myersBriggs>ENTJ</foaf:myersBriggs>
      <foaf:weblog rdf:resource =\"http://www.milanstankovic.org/blog/\"/>
      <foaf:interest rdf:resource =\"http://en.wikipedia.org/wiki/Semantic_Web\"/>
      <foaf:interest rdf:resource =\"http://en.wikipedia.org/wiki/World_Wide_Web\"/>
      <foaf:interest rdf:resource =\"http://en.wikipedia.org/wiki/Web_Science\"/>
<foaf:holdsAccount>
    <foaf:OnlineAccount>
      <rdf:type rdf:resource=\"http://xmlns.com/foaf/0.1/OnlineAccount\"/>
      <foaf:accountServiceHomepage rdf:resource=\"http://del.icio.us/\"/>
      <foaf:accountName>milstan</foaf:accountName>
    </foaf:OnlineAccount>
  </foaf:holdsAccount>
<foaf:holdsAccount>
    <foaf:OnlineAccount>
      <rdf:type rdf:resource=\"http://xmlns.com/foaf/0.1/OnlineAccount\"/>
      <foaf:accountServiceHomepage rdf:resource=\"http://www.flickr.com/\"/>
      <foaf:accountName>milstan</foaf:accountName>
    </foaf:OnlineAccount>
  </foaf:holdsAccount>
        <foaf:knows rdf:parseType=\"Resource\">
            <rdf:type rdf:resource=\"http://xmlns.com/foaf/0.1/Person\"/>
            <foaf:firstName>Vladan</foaf:firstName>
            <foaf:homepage rdf:resource=\"http://fon.fon.bg.ac.yu/~devedzic/\"/>
            <foaf:mbox_sha1sum>186620097abf46f5dfb3a5b115baf023450729b6</foaf:mbox_sha1sum>
            <foaf:surname>Devedzic</foaf:surname>
        </foaf:knows>
        <foaf:knows rdf:parseType=\"Resource\">
            <rdf:type rdf:resource=\"http://xmlns.com/foaf/0.1/Person\"/>
            <foaf:firstName>Uros</foaf:firstName>
            <foaf:homepage rdf:resource=\"http://www.krcadinac.com\"/>
            <foaf:mbox_sha1sum>b768abedfce60c452cf69f748fb9ecfcefbc7c28</foaf:mbox_sha1sum>
            <foaf:surname>Krcadinac</foaf:surname>
        </foaf:knows>
        <foaf:knows rdf:parseType=\"Resource\">
            <rdf:type rdf:resource=\"http://xmlns.com/foaf/0.1/Person\"/>
            <foaf:firstName>Jelena</foaf:firstName>
            <foaf:mbox_sha1sum>5ddd6730daa6dc71c732d2416a378b2dacf99c73</foaf:mbox_sha1sum>
            <foaf:surname>Jovanovic</foaf:surname>
            <foaf:homepage rdf:resource=\"http://www.jelenajovanovic.net/\"/>
        <rdfs:seeAlso rdf:resource=\"http://jelenajovanovic.net/foaf.rdf#jeljov\"/>
        </foaf:knows>       
    </rdf:Description>
</rdf:RDF>"

let _ =
  debug "@@@ Hello\n"  ;
  try 
    let connection = Connection.create "dav" "ar27bfhy" in 
    let result = users connection in 
      debug "@@@ Result: %s\n" result 
  with Curl.CurlException (code, e, s) -> debug "@@@ Error: %s\n" s
