handler = require('./index').handler

context = {
  done: (cb, result) ->
    console.log "DONE: ", result
    #NOTE: with process.exit 0 - even locally it doesn't work - probably the same thing happens on Lambda
    #      when commented out - it works locally
    #process.exit 0
    #throw new Error("Exit lambda")
    #setTimeout (-> process.exit 1), 1000
    #process.nextTick (-> process.exit 1)
    return 
}

event = {
  "topic": "my-topic",
  "value": "hello, lambda from test",
  "retain": false
}

handler event, context
