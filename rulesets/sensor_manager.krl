ruleset sensor_manager {
  meta {
    shares __testing
  }
  global {
    __testing = { "events":  [ { "domain": "section", "type": "needed", "attrs": [ "sensor_name" ] } ] }
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
        //TODO: Fill in the rest of the pertinent info for the pico
      }
    }
  }
}