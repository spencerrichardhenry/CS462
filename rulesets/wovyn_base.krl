ruleset wovyn_base {
  meta {
    shares __testing
    use module sensor_profile alias sensor
    use module sensorManager_profile alias managerProfile
    use module io.picolabs.subscription alias Subscriptions
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
      "eci": sensor[0]{"Tx"},
      "domain":"wovyn",
      "type": "threshold_violation",
      "attrs": {
        "temperature" : event:attr("temperature"),
        "timestamp" : event:attr("timestamp"),
        "threshold" : sensor:temperature_threshold()
      }
    })
  }  
}
