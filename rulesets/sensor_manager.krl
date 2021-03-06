ruleset sensor_manager {
  meta {
    shares __testing, showChildren, sensors, getAllSensorTemps
    use module io.picolabs.wrangler alias wrangler
    use module io.picolabs.subscription alias Subscriptions
    shares getLastFiveReports
  }
  global {
    __testing = { "events":  [ { "domain": "section", "type": "needed", "attrs": [ "sensor_name" ] } ] }
    showChildren = function() {
      wrangler:children()
    }
    sensors = function() {
      Subscriptions:established("Rx_role", "manager")
    }
    numSensors = function() {
      Subscriptions:established("Rx_role", "manager").length()
    }
    nameGenerator = function(sensor_name) {
      sensor_name + " sensor pico"
    }
    getAllSensorTemps = function() {
      sensors = Subscriptions:established("Rx_role", "manager")
       json = []
       sensors.map(function(x) {
         json.append(wrangler:skyQuery(x{"Tx"}, "temperature_store", "temperatures"))
       })     
    }
    getLastFiveReports = function() {
      json = []
      index = ent:correlationID - 1
      item = ent:reports{index.as("String")}.put("reportID", index)
      json = json.append(item)
      index = index - 1
      item = ent:reports{index.as("String")}.put("reportID", index)
      json = json.append(item)
      index = index - 1
      item = ent:reports{index.as("String")}.put("reportID", index)
      json = json.append(item)
      index = index - 1
      item = ent:reports{index.as("String")}.put("reportID", index)
      json = json.append(item)
      index = index - 1
      item = ent:reports{index.as("String")}.put("reportID", index)
      json = json.append(item)
      return json
    }
  }

  rule getAllTemps {
    select when sensor getAllTemps
    foreach sensors() setting (sub)
    pre {
      correlationID = ent:correlationID.defaultsTo(0)
    }
      event:send({
        "eci": sub{"Tx"},
        "domain":"wovyn",
        "type": "temperature_report",
        "attrs": {
          "correlationID": correlationID,
          "Manager_Rx": sub{"Rx"},
        }
      })
      fired {
        sensor_map = {"temperature_sensors": numSensors(), "responding": numSensors(), "temperatures": []}
        ent:reports := ent:reports.defaultsTo({}).put(correlationID, sensor_map) on final
        ent:correlationID := ent:correlationID + 1 on final
    }
  }

  rule setReportId {
    select when sensor setReportId
    noop()
    fired {
      ent:correlationID := 1
    }
  }

  rule gatherTemps {
    select when sensor gatherTempReport
    pre {
      correlationID = event:attr("correlationID")
      tempsAppended = ent:reports[correlationID]["temperatures"].klog("pre-append").append(event:attr("temps")).klog("test")
      tempsReportNew = {"temperature_sensors": numSensors(), "responding": numSensors(), "temperatures": tempsAppended}
    }
    noop()
     fired {
       ent:reports := ent:reports.put(correlationID, tempsReportNew)
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
    event:send({
      "eci": event:attr("eci"),
      "domain":"sensor",
      "type": "profile_updated",
      "attrs": {
        "location": "provo",
        "name": event:attr("sensor_name"),
        "receiving": 3606433965,
        "sending": 3177080143,
        "threshold": 73
      }
    })
    fired {
      raise wrangler event "subscription" attributes {
        "wellKnown_Tx": event:attr("eci"),
        "name": "sensorSubscription",
        "channel_type": "sub",
        "Rx_role": "manager",
        "Tx_role": "sensor"
      }
      ent:sensors := ent:sensors.defaultsTo({})
      ent:sensors{[sensor_name]} := sensor
    }
  }

  rule subscribe_sensor {
    select when sensor subscribe
    if event:attr("eci") then noop()
    fired {
      raise wrangler event "subscription" attributes {
        "wellKnown_Tx": event:attr("eci"),
        "name": "sensorSubscription",
        "channel_type": "sub",
        "Rx_role": "manager",
        "Tx_role": "sensor"
      }
    }
  }

  rule delete_sensor {
    select when sensor unneeded_sensor
    pre {
      sensor_name = event:attr("sensor_name")
      exists = ent:sensors >< sensor_name
    }
    if exists then send_directive("Deleting sensor", {"sensor_name":sensor_name})
    fired {
      raise wrangler event "child_deletion" attributes {
        "name": nameGenerator(sensor_name),
        "picoIDArray": ent:sensors{[sensor_name]}{"id"}
      }
      clear ent:sensors{[sensor_name]}
    }
  }

}