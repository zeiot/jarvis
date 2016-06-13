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

package messages

import (
	//"fmt"
	"log"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

const (
	mqttClientID string = "jarvis-server"
)

//define a function for the default message handler
var defaultHandler mqtt.MessageHandler = func(client mqtt.Client, msg mqtt.Message) {
	log.Printf("[INFO] [jarvis] mqtt topic: %s\n", msg.Topic())
	log.Printf("[INFO] [jarvis] mqtt msg: %s\n", msg.Payload())
}

// Subscriber represents a mqtt subscriber
type Subscriber struct {
	Client mqtt.Client
	Topics []string
}

// NewSubscriber will create a new mqtt client
func NewSubscriber(server string) (*Subscriber, error) {
	log.Printf("[DEBUG] [jarvis] mqtt Create client for broker: %s", server)
	opts := mqtt.NewClientOptions().AddBroker(server)
	opts.SetClientID(mqttClientID)
	opts.SetDefaultPublishHandler(defaultHandler)
	return &Subscriber{
		Client: mqtt.NewClient(opts),
		Topics: []string{"/jarvis/ping", "/jarvis/health"},
	}, nil
}

// Connect will connect to the broker and subsribe to a topic
func (s *Subscriber) Connect() error {
	log.Printf("[DEBUG] [jarvis] mqtt connect")
	if token := s.Client.Connect(); token.Wait() && token.Error() != nil {
		return token.Error()
	}
	for _, topic := range s.Topics {
		log.Printf("[DEBUG] [jarvis] mqtt Subscribe to %s", topic)
		if token := s.Client.Subscribe(topic, 0, nil); token.Wait() && token.Error() != nil {
			return token.Error()
		}
	}
	return nil
}

// Disconnect will unsubscribe to a topic and disconnect from the broker
func (s *Subscriber) Disconnect() error {
	for _, topic := range s.Topics {
		log.Printf("[DEBUG] [jarvis] mqtt Unsubscribe to %s", topic)
		if token := s.Client.Unsubscribe(topic); token.Wait() && token.Error() != nil {
			return token.Error()
		}
	}
	log.Printf("[DEBUG] [jarvis] mqtt discconnect")
	s.Client.Disconnect(250)
	return nil
}

// Status display mqtt client status
func (s *Subscriber) Status() {
	log.Printf("[INFO] [jarvis] MQTT status: %s", s.Client.IsConnected())
}
