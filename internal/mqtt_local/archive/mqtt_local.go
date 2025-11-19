package mqtt_local

import (
  "fmt"
  "os"
  "time"
  "io/ioutil"
  "crypto/tls"
  "crypto/x509"
  MQTT "github.com/eclipse/paho.mqtt.golang"
)

var mqtt_client MQTT.Client

func Create_client(f MQTT.MessageHandler) {
	// set protocol, ip, and port of broker
	opts := MQTT.NewClientOptions().AddBroker("tcp://localhost:1883")
	opts.SetClientID("Server_Subscriber")
	opts.SetDefaultPublishHandler(f)

  opts.OnConnect = func(c MQTT.Client) {
    // Subcsribe to topic: test1
    if token := c.Subscribe("test1", 0, nil); token.Wait() && token.Error() != nil {
      fmt.Println(token.Error())
      os.Exit(1)
    }
    // Subcsribe to topic: dev_bootup
    if token := c.Subscribe("dev_bootup", 0, nil); token.Wait() && token.Error() != nil {
      fmt.Println(token.Error())
      os.Exit(1)
    }
  }

	// Connect to broker with client
	mqtt_client = MQTT.NewClient(opts)
	if token := mqtt_client.Connect(); token.Wait() && token.Error() != nil {
		panic(token.Error())
	}
}

func Publish(topic string, msg string) {
  token := mqtt_client.Publish(topic, 0, false, msg)
  token.Wait()
  time.Sleep(1 * time.Second)
}

