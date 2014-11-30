mqtt = require('mqtt')

console.log "Loading event"

exports.handler = (event, context) ->
  console.log "event =\n", event

  client = mqtt.connect("mqtt://test.mosquitto.org:1883")
  console.log "after mqtt.connect()"

  for i in [1..1000]
    console.log "before client.publish() ", i
    client.publish event.topic, event.value, 
      retain: (event.retain? and event.retain)
    console.log "after client.publish()", i

  client.end()
  console.log "after cleint.end()"

  client.on "close", (-> context.done null, "SUCCESS")
  client.on "error", (-> context.done null, "ERROR")

  return
