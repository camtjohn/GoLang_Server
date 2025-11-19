package main

import (
  "fmt"
  "time"
  "syscall"
  "os"
  "os/signal"
  "github.com/camtjohn/server/internal/mqtt_local"
  "github.com/camtjohn/server/internal/weather"
  MQTT "github.com/eclipse/paho.mqtt.golang"
)


// Monitor current time set by ntpd at bootup. Only continue when time is updated
func wait_for_current_time() {
  t := time.Now()
  // While current time shows before 2020, wait till ntpd gets current time
  for t.Before(time.Date(2020, 1, 1, 0, 0, 0, 0, time.UTC)) {
    fmt.Println("Wait 5 more seconds for ntpd to get time...")
    time.Sleep(5 * time.Second)
    t = time.Now()
  }
}

// Handler responds to mqtt messages for following topics
var msg_handler MQTT.MessageHandler = func(client MQTT.Client, msg MQTT.Message) {
	topic := string(msg.Topic())
	payload := string(msg.Payload())

	if topic == "test1" {
		fmt.Println("recvd msg for test1", payload)
    // get current temp from weather json
	}

	if topic == "dev_bootup" {
    current_temp := weather.Read_weather()
    msg_current := "0" + string(current_temp)
    mqtt_local.Publish(client, "data_update_to_0", msg_current)
	}
}

// Get weather. Write to json file
//func task_current_weather() {
//  for {
//    fmt.Println("Getting weather")
//    weather_data := weather.Get_weather()
//    weather.Store_weather(weather_data)
//    time.Sleep(10 * time.Second)
//  }
//}

func main() {
  fmt.Println("Starter up...")
  wait_for_current_time()

  // Create signal channel to keep program running
  // stackoverflow.com/questions/48872360/golang-...
  sigChan := make(chan os.Signal, 1)
  signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

  // Create mqtt client, connect to broker, subscribe to topics
  var mqtt_client MQTT.Client
  mqtt_local.Create_client(mqtt_client, msg_handler)

  <-sigChan

  mqtt_client.Disconnect(250)

  //go task_current_weather()
}
