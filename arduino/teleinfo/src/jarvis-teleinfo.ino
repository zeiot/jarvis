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

#include <ESP8266wifi.h>
#include <PubSubClient.h>
#include <SoftwareSerial.h>

/************************* Configuration *********************************/

const char* ssid = "xxxxxxx";
const char* password = "xxxxxxxxxxx";
const char* mqtt_server = "192.10.10.2";
const int mqtt_port = 8083;

/************************* End configuration *****************************/


WiFiClient wifiClient;
PubSubClient mqttClient;


SoftwareSerial cptSerial(2, 3);

void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.printf("[Jarvis] Connecting to : %s\n", ssid);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.printf("[Jarvis] WiFi connected. IP: %s\n", WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.println("[Jarvis] Message arrived:  topic: " + String(topic));
  Serial.println("[Jarvis] Length: " + String(length,DEC));
  for(i=0; i<length; i++) {
    message_buff[i] = payload[i];
  }
  message_buff[i] = '\0';
  String msgString = String(message_buff);
  Serial.println("[Jarvis] Payload: " + msgString);
}

void reconnect() {
  while (!mqttClient.connected()) {
    Serial.print("[Jarvis] Attempting MQTT connection...");
    // Attempt to connect
    if (mqttClient.connect("ESP8266Client")) {
      Serial.println("[Jarvis] connected");
      mqttClient.publish("/jarvis/ping", "hello world from teleinfo");
      // client.subscribe("");
    } else {
      Serial.print("[Jarvis] failed, rc=");
      Serial.print(mqttClient.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup_mqtt() {
  mqttClient = PubSubClient(mqtt_server, mqtt_port, callback, wifiClient);
  reconnect();

}


void setup() {
  Serial.begin(1200);
  cptSerial.begin(1200);
  setup_wifi();
  setup_mqtt();
  Serial.println("[Jarvis] TeleInfo ready");

}

char character;

void loop() {
  if (cptSerial.available()) {
    char teleinfo = cptSerial.read() & 0x7F;
    client.publish("/jarvis/sensor/teleinfo", teleinfo);
  }
}
