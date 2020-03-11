ruleset sensor_profile {
  meta {
    shares __testing
    provides sensor_location, sensor_name, temperature_threshold, receiving_phone, sending_phone, getProfile 
    shares sensor_location, sensor_name, temperature_threshold, receiving_phone, sending_phone, getProfile 
  }
  global {
    getProfile = function() {
      return {"location": sensor_location(), "name": sensor_name(), "threshold": temperature_threshold() }
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
  }

  rule updateProfile {
    select when sensor profile_updated
    always {
    ent:sensor_location := event:attr("location")
    ent:sensor_name := event:attr("name")
    ent:temperature_threshold := event:attr("threshold").as("Number")
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
    }
  }

  rule auto_accept {
    select when wrangler inbound_pending_subscription_added
    fired {
      raise wrangler event "pending_subscription_approval"
        attributes event:attrs
    }
  }

}