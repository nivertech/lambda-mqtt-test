# lambda-mqtt-test

AWS Lambda which function as a brdge between custom events and MQTT Broker.

### Dependencies

- AWS account
    - http://aws.amazon.com/
- AWS Lambda service is currently in preview, so you need to be whitelisted to use it:
    - http://aws.amazon.com/lambda/
- AWS CLI tools
    - http://docs.aws.amazon.com/cli/latest/userguide/installing.html
    Or on Linux or OSX this probably will do the job:
    ``` bash
    sudo easy_install pip
    sudo pip install awscli
    ```


We use this public MQTT broker for testing:
- http://test.mosquitto.org/

We use following npm module which implements MQTT client for Node.js:
- https://www.npmjs.org/package/mqtt

We'll need an MQTT CLI client.
We can use one that comes with Mosquitto MQTT broker:
- http://mosquitto.org/download/

Or we can use the MQTT CLI client that comes with `mqtt` npm module (which is much easier to install):

``` bash
npm install -g mqtt
```

Test that it works:

``` bash
mqtt_sub 1883 test.mosquitto.org '#'
...
<topic> <value>
...
CTRL-C
```

or same thing with mosquitto CLI client:

``` bash
mosquitto_sub -h test.mosquitto.org -t '#' -v
...
<topic> <value>
...
CTRL-C
```

You should receive a bunch of messages. Press CTRL-C to kill the client.



Replace lambda execution role for the script `upload.sh`:

``` bash
export lambda_execution_role_arn="arn:aws:iam::************:role/lambda_exec_role"
```

Prepare and upload function to the AWS Lambda service with:

``` bash
./upload.sh
```

Now in one terminal window run:

``` bash
mqtt_sub 1883 test.mosquitto.org my-topic
```

or alternatively using mosquitto CLI client:

``` bash
mosquitto_sub -h test.mosquitto.org -t my-topic -v
```


We subscribed and listening to all messages published to MQTT topic `my-topic`. 


The lambda function expects custom events like this (see `event-mqtt.json` file):

``` json
{
    "topic": "my-topic",
    "value": "hello, lambda!",
    "retain": false
}
```

In another terminal window let's invoke lambda function with:

``` bash
aws lambda invoke-async --function-name "lambda-mqtt-test" --invoke-args event-mqtt.json
```

You should receive the message in the first terminal.

Testing lambda function locally (using CoffeeScript):

``` bash
coffee index_test.coffee
```

or using Javascript:

``` bash
node index_test.js
```
