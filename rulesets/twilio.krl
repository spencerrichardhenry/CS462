ruleset twilio {
  meta {
    name "Twilio"
    author "Spencer Henry"
    use module twilio_auth
    use module twilioApiModule alias TwilioApi
    with account_sid = keys:auth{"account_sid"}
         auth_token =  keys:auth{"auth_token"}
  }
   
  rule test_send_sms {
    select when test new_message
    TwilioApi:send_sms(event:attr("from"),
             event:attr("to"),
             event:attr("message"))
             
    //send_directive("send_sms completed")
  }

  rule get_messages {
    select when get messageList
    pre {
      data = TwilioApi:messages(event:attr("to"),
      event:attr("from"),
      event:attr("paginated"))
    }
    send_directive("Hello" + data);
  }

}