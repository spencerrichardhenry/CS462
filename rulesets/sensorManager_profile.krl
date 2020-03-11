ruleset sensor_profile {
  meta {
    shares __testing
    use module twilio_auth
    use module twilioApiModule alias TwilioApi
    with account_sid = keys:auth{"account_sid"}
         auth_token =  keys:auth{"auth_token"}
    provides sensor_location, sensor_name, temperature_threshold, receiving_phone, sending_phone, getProfile 
    shares sensor_location, sensor_name, temperature_threshold, receiving_phone, sending_phone, getProfile 
  }
  global {
    getProfile = function() {
      return {"location": sensor_location(), "name": sensor_name(), "threshold": temperature_threshold(), "receiving_phone": receiving_phone(), "sending_phone": sending_phone() }
    }
    sensor_location = function() {
      return ent:sensor_location.defaultsTo("provo")
    }
    sensor_name = function() {
      return ent:sensor_name.defaultsTo("wovyn")
    }
    temperature_threshold = function() {
      return ent:temperature_threshold.defaultsTo(73)
    }
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
    ent:sensor_location := event:attr("location")
    ent:sensor_name := event:attr("name")
    ent:receiving_phone := event:attr("receiving").as("Number")
    ent:sending_phone := event:attr("sending").as("Number")
    ent:temperature_threshold := event:attr("threshold").as("Number")
    }
  }

  rule updatePhones {
    select when sensor phones_updated
    always {
      ent:receiving_phone := event:attr("receiving").as("Number")
      ent:sending_phone := event:attr("sending").as("Number")
    } 
  }

  rule updateThreshold {
     select when sensor threshold_updated
     always {
      ent:temperature_threshold := event:attr("threshold").as("Number")
     }
  }

  rule clearProfile {
    select when sensor profile_reset
    always {
      clear ent:sensor_location
      clear ent:sensor_name
      clear ent:temperature_threshold
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
      test = "You are in the sms_notification rule!".klog()
    }
    TwilioApi:send_sms(receiving_phone(), sending_phone(), "Temperature on your wovyn device is above your threshold of " + temperature_threshold())
  }

}