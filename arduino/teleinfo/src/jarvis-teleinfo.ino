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
#include <LibTeleinfo.h>

#include <SoftwareSerial.h>
#include <SPI.h>
#include <WiFi.h>
#include <WiFiClient.h>

#include "config.h"

/* ************************ Configuration *********************************/

/* char ssid[] = "xxxxx"; */
/* char password []= "xxxx"; */

/* const char* mqtt_server = "192.10.10.2"; */
const int mqtt_port = 8083;

/* ************************ End configuration *****************************/

WiFiClient wifiClient;
PubSubClient mqttClient;
TInfo tinfo;

char message_buff[100];

// Teleinfo Serial (on D3)
SoftwareSerial teleinfoSerial(3, 4);



/* *********************** Wifi ***************************************/


void setup_wifi() {

  delay(10);
  Serial.print("[Jarvis] Connecting to : ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.print("[Jarvis] WiFi connected. IP: ");
  Serial.println(WiFi.localIP());
}


/* *********************** End Wifi ***************************************/



/* *********************** MQTT ***************************************/

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.println("[Jarvis] Message arrived:  topic: " + String(topic));
  Serial.println("[Jarvis] Length: " + String(length,DEC));
  unsigned int i;
  for(i=0; i<length; i++) {
    message_buff[i] = payload[i];
  }
  message_buff[i] = '\0';
  String msgString = String(message_buff);
  Serial.println("[Jarvis] Payload: " + msgString);
}

void reconnect() {
  while (!mqttClient.connected()) {
    Serial.println("[Jarvis] Attempting MQTT connection...");
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
  Serial.println("[Jarvis] Setup MQTT");
  mqttClient = PubSubClient(mqtt_server, mqtt_port, callback, wifiClient);
  reconnect();
}


/* *********************** End MQTT ***************************************/


/* *********************** Teleinfo ***************************************/

void ADPSCallback(uint8_t phase) {
  if (phase == 0) {
    phase = 1;
  }
  Serial.print("[jarvis] Teleinfo ADPS: ");
  Serial.println('0' + phase);
}


void DataCallback(ValueList * teleinfodata, uint8_t flags) {
  if (flags & TINFO_FLAGS_ADDED) {
    Serial.print("[jarvis] Teleinfo New : ");
  }

  if (flags & TINFO_FLAGS_UPDATED) {
    Serial.print("[jarvis] Teleinfo Update : ");
  }

  Serial.print(teleinfodata->name);
  Serial.print("=");
  Serial.println(teleinfodata->value);
}


void NewFrameCallback(ValueList * teleinfodata) {
  Serial.println("[jarvis] Teleinfo new frame");
  sendTeleinfoData(teleinfodata);
}


void UpdatedFrameCallback(ValueList * teleinfodata) {
   Serial.println("[jarvis] Teleinfo frame updated");
   sendTeleinfoData(teleinfodata);
}


void  sendTeleinfoData(ValueList * teleinfodata) {
  if (teleinfodata) {
    String output = "";
    bool firstdata = true;
    while (teleinfodata->next) {
      teleinfodata = teleinfodata->next;
      if (firstdata) {
          firstdata = false;
      } else {
          output += ", ";
      }
      output += teleinfodata->name;
      output += "=";
      output += teleinfodata->value;
    }
    Serial.print("[jarvis] Teleinfo mqtt output: ");
    Serial.println(output);
  }
}


void setup_teleinfo() {
  Serial.println("[Jarvis] Setup Teleinfo");
  tinfo.init();
  tinfo.attachADPS(ADPSCallback);
  tinfo.attachUpdatedFrame(UpdatedFrameCallback);
  tinfo.attachNewFrame(NewFrameCallback);
}


/* *********************** End Teleinfo ***************************************/



void setup() {
  Serial.begin(9600);
  teleinfoSerial.begin(1200);
  setup_wifi();
  setup_mqtt();
  setup_teleinfo();
  Serial.println("[Jarvis] TeleInfo ready");

}

String inputString = "";

void loop() {
  if (teleinfoSerial.available()) {
    /* char inChar = (char)Serial.read(); */
    /* inputString += inChar; */
    /* if (inChar == '\n') { */
    /*   //mqttClient.publish("/jarvis/sensor/teleinfo", inputString); */
    /* } */
    /* //char teleinfo = cptSerial.read() & 0x7F; */

    tinfo.process(teleinfoSerial.read());
  }
}
