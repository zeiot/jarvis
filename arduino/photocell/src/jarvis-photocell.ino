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
#include <SPI.h>
#include <WiFi.h>
#include <WiFiClient.h>

#include <ArduinoNATS.h>

#include "config.h"

#ifndef UNIT_TEST

int photocellPin = 0; // the cell and 10K pulldown are connected to a0
int photocellReading; // the analog reading from the analog resistor divider

WiFiClient wifiClient;

NATS nats(
	&wifiClient,
	NATS_SERVER,
        NATS_DEFAULT_PORT
);


/*
 * Wifi
 */

void print_wifi_status() {
  // print the SSID of the network you're attached to:
  Serial.print("[Jarvis-Photocell] SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("[Jarvis-Photocell] IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("[Jarvis-Photocell] Signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}

void setup_wifi() {

  delay(10);
  Serial.print("[Jarvis-Photocell] Connecting to : ");
  Serial.println(WIFI_SSID);

  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("[Jarvis-Photocell] WiFi shield not present");
    // don't continue:
    while(true);
  }

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.print("[Jarvis-Photocell] WiFi connected. IP: ");
  print_wifi_status();
}

/*
 * NATS
 */

void nats_echo_handler(NATS::msg msg) {
  Serial.println("[Jarvis-Photocell] NATS Message subject: " + String(msg.subject));
  Serial.println("[Jarvis-Photocell] NATS Message reply: " + String(msg.reply));
  Serial.println("[Jarvis-Photocell] NATS Message data: " + String(msg.data));
  nats.publish(msg.reply, msg.data);
}

void nats_on_connect() {
  nats.subscribe("echo", nats_echo_handler);
}

void setup_nats() {
  Serial.println("[Jarvis-Photocell] Setup NATS");
  nats.on_connect = nats_on_connect;
  nats.connect();
}


void setup(void) {
  Serial.begin(9600);
  setup_wifi();
  setup_nats();
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
