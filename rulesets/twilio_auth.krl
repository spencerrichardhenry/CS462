ruleset twilio_auth {
  meta {
    key twilio {
          "account_sid": "<your SID goes here>", 
          "auth_token" : "<your auth token goes here>"
    }
    provides keys twilio to io.picolabs.use_twilio_v2
  }
}