ruleset post_test {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries": [ { "name": "__testing" } ],
                  "events": [ { "domain": "post", "type": "test",
                              "attrs": [ "temp", "baro" ] } ] }
    temperature_threshold = 73
                              
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
    // send_directive("temp: " + event:attr("genericThing"){"data"}{"temperature"}[0]{"temperatureF"})
  }

  rule find_high_temps {
    select when wovyn new_temperature_reading
    send_directive(event:attr("temperature") > temperature_threshold => "There was a temperature violation." | "No temperature violation.")
    fired {
      raise wovyn event (event:attr("temperature") > temperature_threshold) => "threshold_violation" | ""
    }
  }

  rule threshold_notification {
    select when wovyn threshold_violation
    send_directive("this is the threshold_notification rule.")
  }
}