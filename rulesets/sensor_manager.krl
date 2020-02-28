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
    nameGenerator = function(sensor_name) {
      sensor_name + " sensor pico"
    }
  }

  rule sensors_empty {
    select when sensor empty
    always {
      ent:sensors := {}
    }
  }

  rule sensor_already_exists {
    select when sensor sensor_needed
    pre {
      sensor_name = event:attr("sensor_name")
      exists = ent:sensors >< sensor_name
    }
    if exists then 
      send_directive("sensor_ready", {"sensor_name": sensor_name})
  }

  rule sensor_needed {
    select when sensor new_sensor
    pre {
      sensor_name = event:attr("name")
      exists = ent:sensors >< sensor_name
      eci = meta:eci
    }
    if exists then noop()
    notfired {
      raise wrangler event "child_creation" attributes {
        "name": nameGenerator(sensor_name),
        "color": "#2e4dc7",
        "sensor_name": sensor_name,
        "rids": ["sensor_profile", "temperature_store", "wovyn_base"]
      }
    }
  }

  rule store_new_sensor {
    select when wrangler child_initialized
    pre {
      sensor = {
        "id": event:attr("id"), 
        "eci": event:attr("eci"), 
      }
      sensor_name = event:attr("sensor_name")
    }
      if sensor_name then noop()
      fired {
        ent:sensors := ent:sensors.defaultsTo({})
        ent:sensors{[sensor_name]} := sensor

      }
    
  }

}