ruleset twilio {
  meta {
    name "Twilio"
    description <<
Twilio Key Module
>>
    author "Spencer Henry"
    use module twilio_auth
    use module twilioApiModule alias TwilioApi
    with account_sid = keys:auth{"account_sid"}
         auth_token =  keys:auth{"auth_token"}
  }
   
  rule test_send_sms {
    select when test new_message
    TwilioApi:send_sms(event:attr("to"),
             event:attr("from"),
             event:attr("message"))
  }

}