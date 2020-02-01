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
    select when wovyn heartbeat
    send_directive("Hello there. This is a heartbeat event." + (event:attr("genericThing") => event:attr("genericThing"){"heartbeatSeconds"} | "no generic thing"))
  }
}