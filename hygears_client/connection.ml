(*
 * hyGears client - connection
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                       Simon Marc msimon@hypios.com
 *                       David Ruyer msimon@hypios.com
 *                       Ramdane Berkane rberkane@hypios.com
 *
 *)

type t =
    {
        host : string;
        https : bool;
    }

let create ?(https=false) host = 
    {
        host = host;
        https = https;
    }