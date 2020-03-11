ruleset wovyn_base {
  meta {
    shares __testing
    use module twilio_auth
    use module twilioApiModule alias TwilioApi
    with account_sid = keys:auth{"account_sid"}
         auth_token =  keys:auth{"auth_token"}
    use module sensor_profile alias sensor
  }
  global {
    __testing = { "queries": [ { "name": "__testing" } ],
                  "events": [ { "domain": "post", "type": "test",
                              "attrs": [ "temp", "baro" ] } ] }
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
    send_directive(event:attr("temperature") > sensor:temperature_threshold() => "There was a temperature violation." | "No temperature violation.")
    fired {
      raise wovyn event "threshold_violation"
        attributes {
          "temperature" : event:attr("temperature"),
          "timestamp" : event:attr("timestamp")
        } if (event:attr("temperature") > sensor:temperature_threshold())
    }
  }

  rule threshold_notification {
    select when wovyn threshold_violation
    pre {
    sensor = Subscriptions:established("Tx_role", "manager")
    }
    if sensor then 
    event:send({
      "eci": sensor{"Tx"},
      "domain":"wovyn",
      "type": "threshold_violation",
      "attrs": {
        "temperature" : event:attr("temperature"),
        "timestamp" : event:attr("timestamp")
      }
    })
  }  
    // TwilioApi:send_sms(sensor:receiving_phone(), sensor:sending_phone(), "Temperature on your wovyn device is above your threshold of " + sensor:temperature_threshold())
  }
