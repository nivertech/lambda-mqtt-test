handler = require('./index').handler

context = {
  done: (cb, result) ->
    console.log "DONE: ", result
    process.exit 0
    return 
}

event = {
  "topic": "my-topic",
  "value": "hello, lambda from test",
  "retain": false
}

handler event, context
