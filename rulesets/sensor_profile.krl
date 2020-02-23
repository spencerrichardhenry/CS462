ruleset temperature_store {
  meta {
    shares __testing
    provides sensor_location, sensor_name, temperature_threshold, receiving_phone, sending_phone 
    shares sensor_location, sensor_name, temperature_threshold, receiving_phone, sending_phone 
  }
  global {
    getProfile = function() {
      return {"location": sensor_location, "name": sensor_name, "threshold": temperature_threshold, "receiving_phone": receiving_phone, "sending_phone": sending_phone }
    }
    sensor_location = "provo"
    sensor_name = "wovyn"
    temperature_threshold = 73
    receiving_phone = 3606433965
    sending_phone = 3177080143
  }

  rule updateProfile {
    select when sensor profile_updated
    pre {
    sensor_location = event:attr("location")
    sensor_name = event:attr("name")
    }
  }

  rule updatePhones {
    select when sensor phones_updated
    pre {
      receiving_phone = event:attr("receiving")
      sending_phone = event:attr("sending")
    } 
  }

  rule updateThreshold {
    select when sensor threshold_updated
    pre {
      temperature_threshold = event:attr("threshold")
    }
  }

}