ruleset wovyn_base {
  meta {
    shares __testing
    use module twilio_auth
    use module twilioApiModule alias TwilioApi
    with account_sid = keys:auth{"account_sid"}
         auth_token =  keys:auth{"auth_token"}
    provides temperature_threshold
  }
  global {
    __testing = { "queries": [ { "name": "__testing" } ],
                  "events": [ { "domain": "post", "type": "test",
                              "attrs": [ "temp", "baro" ] } ] }
    temperature_threshold = 73
    receiving_phone = 3606433965
    sending_phone = 3177080143
  }

  rule process_heartbeat {
    select when wovyn heartbeat where event:attr("genericThing")
    fired {
    raise wovyn event "new_temperature_reading" 
      attributes {
        "temperature" : event:attr("genericThing"){"data"}{"temperature"}[0]{"temperatureF"},
        "timestamp" : time:now({"tz" : "America/Denver"})
      }
    }
  }

  rule find_high_temps {
    select when wovyn new_temperature_reading
    send_directive(event:attr("temperature") > temperature_threshold => "There was a temperature violation." | "No temperature violation.")
    fired {
      raise wovyn event "threshold_violation"
        attributes {
          "temperature" : event:attr("temperature"),
          "timestamp" : event:attr("timestamp")
        } if (event:attr("temperature") > temperature_threshold)
    }
  }

  rule threshold_notification {
    select when wovyn threshold_violation
    TwilioApi:send_sms(receiving_phone, sending_phone, "Temperature on your wovyn device is above your threshold of " + temperature_threshold)
  }
}