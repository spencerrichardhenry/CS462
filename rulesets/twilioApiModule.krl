ruleset twilioApiModule {
  meta {
    configure using account_sid = ""
                    auth_token = ""
    provides send_sms, messages
  }
 
  global {
    send_sms = defaction(to, from, message) {
       base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2020-01-23/Accounts/#{account_sid}/>>
       http:post(base_url + "Messages.json", form = {
                "From":from,
                "To":to,
                "Body":message
            })
    }
    messages = function(to, from, paginated) {
      items = http.get(base_url + "Messages.json");
      send_directive("say", {"items": items});
    }
  }
}