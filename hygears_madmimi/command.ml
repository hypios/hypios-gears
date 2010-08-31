(*
 * hyGears - zementa
 *
 * (c) 2010 Hypios SAS - William Le Ferrand william@hypios.com
 *                  
 *)

open Connection

module Mailer = struct
	let send text_param_name connection ?mailing_list ~promotion ~from ~recipient ?bcc ?reply_to ~subject text =
		let params = [
			("promotion_name", promotion);
			("recipient", recipient);
			("subject", subject);
			("from", from);
		] in
		let issome lst name = function
			| None -> lst
			| Some v -> (name, v) :: lst
		in
		let params = issome params "bcc" bcc in
		let params = issome params "reply_to" reply_to in

		let (url, params) = match mailing_list with
			| None -> ("/mailer", params)
			| Some l -> ("/mailer/to_list", ("list_name", l) :: params)
		in
		Effector.send connection params ...... (* TODO *)

	let message = send "body"

	let html = send "raw_html"

	let plain_text = send "raw_plain_text"
end

