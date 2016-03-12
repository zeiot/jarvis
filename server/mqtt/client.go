// Copyright (C) 2016 Nicolas Lamirault <nicolas.lamirault@gmail.com>

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package mqtt

import (
	//"fmt"
	"log"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

const (
	mqttClientID string = "jarvis-server"
)

//define a function for the default message handler
var f mqtt.MessageHandler = func(client *mqtt.Client, msg mqtt.Message) {
	log.Printf("[INFO] [jarvis] MQTT topic: %s\n", msg.Topic())
	log.Printf("[INFO] [jarvis] MQTT msg: %s\n", msg.Payload())
}

// Client represents a MQTT client
type Client struct {
	Mqtt   *mqtt.Client
	Topics []string
}

// NewClient will create a new MQTT client
func NewClient(server string) (*Client, error) {
	log.Printf("[DEBUG] [jarvis] MQTT Create client for broker: %s", server)
	opts := mqtt.NewClientOptions().AddBroker(server)
	opts.SetClientID(mqttClientID)
	opts.SetDefaultPublishHandler(f)
	return &Client{
		Mqtt:   mqtt.NewClient(opts),
		Topics: []string{"/jarvis/ping", "/jarvis/health"},
	}, nil
}

// Connect will connect to the broker and subsribe to a topic
func (c *Client) Connect() error {
	log.Printf("[DEBUG] [jarvis] MQTT connect")
	if token := c.Mqtt.Connect(); token.Wait() && token.Error() != nil {
		return token.Error()
	}
	for _, topic := range c.Topics {
		log.Printf("[DEBUG] [jarvis] MQTT Subscribe to %s", topic)
		if token := c.Mqtt.Subscribe(topic, 0, nil); token.Wait() && token.Error() != nil {
			return token.Error()
		}
	}
	return nil
}

// Disconnect will unsubscribe to a topic and disconnect from the broker
func (c *Client) Disconnect() error {
	for _, topic := range c.Topics {
		log.Printf("[DEBUG] [jarvis] MQTT Unsubscribe to %s", topic)
		if token := c.Mqtt.Unsubscribe(topic); token.Wait() && token.Error() != nil {
			return token.Error()
		}
	}
	log.Printf("[DEBUG] [jarvis] MQTT discconnect")
	c.Mqtt.Disconnect(250)
	return nil
}

// Status display MQTT client status
func (c *Client) Status() {
	log.Printf("[INFO] [jarvis] MQTT status: %s", c.Mqtt.IsConnected())
}
