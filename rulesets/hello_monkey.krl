ruleset hello_monkey {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares hello
  }
   
  global {
    hello = function(obj) {
      msg = "Hello " + obj;
      msg
    }
  }
   
  rule hello_world {
    select when echo hello
    send_directive("say", {"something": "Hello World"})
  }

  rule hello_monkey {
    select when echo monkey 
    pre {
      name = event:attr("name").klog("test")
    }
    //.defaultsTo 
    send_directive("Hello " + name.defaultsTo("Monkey"))

    //Ternary operator
    //send_directive("Hello " + name => name | "Monkey"))
    always {
    }
  }
}