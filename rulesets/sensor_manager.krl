ruleset sensor_manager {
  meta {
    shares __testing, showChildren, getSensors
    use module io.picolabs.wrangler alias wrangler
  }
  global {
    __testing = { "events":  [ { "domain": "section", "type": "needed", "attrs": [ "sensor_name" ] } ] }
    showChildren = function() {
      wrangler:children()
    }
    getSensors = function() {
      return ent:sensors
    }
  }

  rule sensors_empty {
    select when sensor empty
    always {
      ent:sensors := {}
    }
  }

  rule sensor_needed {
    select when sensor new_sensor
    pre {
      sensor_name = event:attr("name")
      exists = ent:sensors >< sensor_name
      eci = meta:eci
    }
    if exists then send_directive("sensor already exists", {"sensor_name":sensor_name})
    notfired {
      ent:sensors := ent:sensors.defaultsTo([]).union([sensor_name]);
      raise wrangler event "child_creation" attributes {
        "name": sensor_name,
        "color": "#2e4dc7"
        //TODO: Fill in the rest of the pertinent info for the pico
      }
    }
  }
}