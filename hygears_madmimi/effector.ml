(*
 * hyGears - zementa
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                  
 *)

open Lwt 

open Connection

type request_method =
	| GET
	| POST

type request = {
	uri : string;
	request_method : request_method;
}

let http_method_of_method = function
	| GET -> Ocsigen_http_frame.Http_header.GET
	| POST -> Ocsigen_http_frame.Http_header.POST

let send ?https connection request params = 
	Ocsigen_lib.get_inet_addr connection.host >>= fun inet_addr ->

	let content_type = "application/x-www-form-urlencoded" in

	let params = ("username", connection.username) :: ("api_key", connection.api_key) :: params in
	let encoded_params = Netencoding.Url.mk_url_encoded_parameters params in

	let (uri, content) = match request.request_method with
		| POST -> request.uri, encoded_params
		| GET -> request.uri ^ "?" ^ encoded_params, ""
	in

	Ocsigen_http_client.raw_request
		?https
		~http_method:(http_method_of_method request.request_method)
		~content:(Some (Ocsigen_stream.of_string content))
		~content_length:(Int64.of_int (String.length content))
		~headers:(Http_headers.add Http_headers.content_type content_type Http_headers.empty)
		~host:connection.host
		~inet_addr
		~uri
		()
		()
