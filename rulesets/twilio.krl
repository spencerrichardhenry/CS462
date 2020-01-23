ruleset twilio {
  meta {
    name "Twilio"
    description <<
Twilio Key Module
>>
    author "Spencer Henry"
    logging on
    shares hello
    provides sid, authToken
    use module twilio_auth alias auth
    use module io.picolabs.twilio_v2 alias twilio
    with account_sid = keys:twilio{"account_sid"}
         auth_token =  keys:twilio{"auth_token"}
  }
  }
   
  }
   
  rule test_send_sms {
    select when test new_message
    twilio:send_sms(event:attr("to"),
             event:attr("from"),
             event:attr("message"),
             event:attr("account_sid"),
             event:attr("auth_token"))
  }

}