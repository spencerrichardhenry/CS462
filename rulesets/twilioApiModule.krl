ruleset twilioApiModule {
  meta {
    configure using account_sid = ""
                    auth_token = ""
    provides send_sms, messages
  }
 
  global {
    send_sms = defaction(to, from, message) {
       base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
       http:post(base_url + "Messages.json", form = {
                "From":from,
                "To":to,
                "Body":message
            })
    }
    messages = function(to, from, paginated) {
      items = http.get(base_url + "Messages.json", response = data).decode().klog("http.get")
      data.klog("Data")
      response = items{"response"}.klog("pulling out response..")
      return items
    }
  }
}