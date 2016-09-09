/*
 * Copyright (C) 2016  Nicolas Lamirault <nicolas.lamirault@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Arduino.h"

#include <ESP8266wifi.h>
#include <PubSubClient.h>

#include <SPI.h>
#include <WiFi.h>
#include <WiFiClient.h>

#include "config.h"

#ifndef UNIT_TEST

/*
 * Configuration
 */

/* char ssid[] = "xxxxx"; */
/* char password []= "xxxx"; */

/* const char* mqtt_server = "xx.xx.xx.xx"; */
const int mqtt_port = 8083;

WiFiClient wifiClient;
PubSubClient mqttClient;

char message_buff[100];

int photocellPin = 0; // the cell and 10K pulldown are connected to a0
int photocellReading; // the analog reading from the analog resistor divider

/*
 * Wifi
 */

void setup_wifi() {

  delay(10);
  Serial.print("[Jarvis-Photocell] Connecting to : ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.print("[Jarvis-Photocell] WiFi connected. IP: ");
  Serial.println(WiFi.localIP());
}

/*
 * MQTT
 */

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.println("[Jarvis-DHT] Message arrived:  topic: " + String(topic));
  Serial.println("[Jarvis-DHT] Length: " + String(length,DEC));
  unsigned int i;
  for(i=0; i<length; i++) {
    message_buff[i] = payload[i];
  }
  message_buff[i] = '\0';
  String msgString = String(message_buff);
  Serial.println("[Jarvis-DHT] Payload: " + msgString);
}

void reconnect() {
  while (!mqttClient.connected()) {
    Serial.println("[Jarvis-DHT] Attempting MQTT connection...");
    // Attempt to connect
    if (mqttClient.connect("ESP8266Client")) {
      Serial.println("[Jarvis-DHT] connected");
      mqttClient.publish("/jarvis/ping", "hello world from teleinfo");
      // client.subscribe("");
    } else {
      Serial.print("[Jarvis-DHT] failed, rc=");
      Serial.print(mqttClient.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup_mqtt() {
  Serial.println("[Jarvis-DHT] Setup MQTT");
  mqttClient = PubSubClient(mqtt_server, mqtt_port, callback, wifiClient);
  reconnect();
}

void setup(void) {
  Serial.begin(9600);
  setup_wifi();
  setup_mqtt();
}

void loop(void) {
  photocellReading = analogRead(photocellPin);
  Serial.print("\n[Jarvis-Photocell] Reading = ");
  Serial.print(photocellReading);
  if (photocellReading < 10) {
    Serial.print(" - Night");
  } else if (photocellReading < 200) {
    Serial.print(" - Dark");
  } else if (photocellReading < 500) {
    Serial.print(" - Light");
  } else if (photocellReading < 800) {
    Serial.print(" - Bright");
  } else {
    Serial.print(" - Very bright");
  }
  delay(5000);
}

#endif
