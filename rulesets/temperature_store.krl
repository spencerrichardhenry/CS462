ruleset temperature_store {
  meta {
    shares __testing
    use module sensor_profile alias sensor
    use module io.picolabs.subscription alias Subscriptions
    provides temperatures, threshold_violations, inrange_temperatures
    shares temperatures, threshold_violations, inrange_temperatures
  }
  global {
    temperatures = function() {
      return ent:temperatures
    }
    threshold_violations = function() {
      return ent:threshold_violations
    }
    inrange_temperatures = function() {
      return ent:temperatures.filter(function(x) {
        x{"temp"} < sensor:temperature_threshold
      })
    }
  }

  rule collect_temperatures {
    select when wovyn new_temperature_reading
    always {
      ent:temperatures := ent:temperatures.defaultsTo([]).append({
        "temp" : event:attr("temperature"),
        "timestamp" : time:now({"tz" : "America/Denver"})
      })
    }
  }

  rule collect_threshold_violations {
    select when wovyn threshold_violation
    always {
      ent:threshold_violations := ent:threshold_violations.defaultsTo([]).append({
        "temp" : event:attr("temperature"),
        "timestamp" : event:attr("timestamp")
      })
    }
  }

  rule generate_report {
    select when wovyn temperature_report
    pre {
      manager = Subscriptions:established("Tx_role", "manager")
    }
    event:send({
      "eci": manager.klog("In generate_report"){"Tx"},
      "domain":"sensor",
      "type": "gatherTempReport",
      "attrs": {
        "correlationID": event:attr("correlationID"),
        "Manager_Rx": event:attr("Manager_Rx"),
        "temps": temperatures()
      }
    })
  }

  rule clear_temperatures {
    select when sensor reading_reset
    always {
      clear ent:threshold_violation
      clear ent:temperatures
    }
  }

}