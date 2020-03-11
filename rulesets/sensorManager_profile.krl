ruleset sensorManager_profile {
  meta {
    shares __testing
    use module twilio_auth
    use module twilioApiModule alias TwilioApi
    with account_sid = keys:auth{"account_sid"}
         auth_token =  keys:auth{"auth_token"}
    provides receiving_phone, sending_phone
    shares receiving_phone, sending_phone 
  }
  global {
    receiving_phone = function() {
      return ent:receiving_phone.defaultsTo(3606433965)
    }
    sending_phone = function() {
      return ent:sending_phone.defaultsTo(3177080143)
    }
  }

  rule updateProfile {
    select when sensor profile_updated
    always {
    ent:receiving_phone := event:attr("receiving").as("Number")
    ent:sending_phone := event:attr("sending").as("Number")
    }
  }

  rule updatePhones {
    select when sensor phones_updated
    always {
      ent:receiving_phone := event:attr("receiving").as("Number")
      ent:sending_phone := event:attr("sending").as("Number")
    } 
  }

  rule clearProfile {
    select when sensor profile_reset
    always {
      clear ent:receiving_phone
      clear ent:sending_phone
    }
  }

  rule auto_accept {
    select when wrangler inbound_pending_subscription_added
    fired {
      raise wrangler event "pending_subscription_approval"
        attributes event:attrs
    }
  }

  rule sms_notification {
    select when wovyn threshold_violation
    pre {
    }
    TwilioApi:send_sms(receiving_phone(), sending_phone(), "Temperature on your wovyn device is above your threshold of " + event:attr("threshold"))
  }

}