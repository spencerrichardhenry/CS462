ruleset post_test {
  meta {
    shares __testing
  }
  global {
    __testing = { "queries": [ { "name": "__testing" } ],
                  "events": [ { "domain": "post", "type": "test",
                              "attrs": [ "temp", "baro" ] } ] }
  }

  rule process_heartbeat {
    select when wovyn heartbeat where event:attr("genericThing")
    send_directive(event:attr("genericThing"){"data"}{"temperature"}[0]{"temperatureF"})
  }
}