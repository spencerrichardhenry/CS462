ruleset temperature_store {
  meta {
    shares __testing
    use module wovyn_base
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
        x{"temp"} < wovyn_base:temperature_threshold
      })
    }
  }

  rule collect_temperatures {
    select when wovyn new_temperature_reading
    always {
      ent:temperatures := {
        "temp" : event:attr("genericThing"){"data"}{"temperature"}[0]{"temperatureF"},
        "timestamp" : time:now({"tz" : "America/Denver"})
      }
    }
  }

  rule collect_threshold_violations {
    select when wovyn threshold_violation
    always {
      ent:threshold_violations := {
        "temp" : event:attr("temperature"),
        "timestamp" : event:attr("timestamp")
      }
    }
  }

  rule clear_temperatures {
    select when sensor reading_reset
    always {
      clear ent:threshold_violation
      clear ent:temperatures
    }
  }

}