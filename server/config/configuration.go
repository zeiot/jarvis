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

package config

import (
	"log"

	"github.com/BurntSushi/toml"
)

// InfluxdbConfiguration defines the configuration for the InfluxDB output plugin
type InfluxdbConfiguration struct {
	URL             string `toml:"url"`
	Username        string `toml:"username"`
	Password        string `toml:"password"`
	Database        string `toml:"database"`
	RetentionPolicy string `toml:"retentionPolicy"`
}

// Configuration holds configuration for Skybox.
type Configuration struct {
	// HTTPPort is the port of the HTTP server
	Port string `toml:"http_port"`

	// MqttBrokerURL is the URL of the MQTT broker
	MqttBrokerURL string `toml:"mqtt_url"`

	// OutputPlugin is the name of the output plugin to store data
	OutputPlugin string                 `toml:"output"`
	InfluxDB     *InfluxdbConfiguration `toml:"influxdb"`
}

// New returns a Configuration with default values
func New() *Configuration {
	return &Configuration{
		Port:          "8080",
		MqttBrokerURL: "tcp://127.0.0.1:1883",
		OutputPlugin:  "influxdb",
		InfluxDB: &InfluxdbConfiguration{
			URL:      "http://localhost:8086",
			Username: "admin",
			Password: "admin"},
	}
}

// LoadFileConfig returns a Configuration from reading the specified file (a toml file).
func LoadFileConfig(file string) (*Configuration, error) {
	log.Printf("[DEBUG] Load configuration file: %s", file)
	configuration := New()
	if _, err := toml.DecodeFile(file, configuration); err != nil {
		return nil, err
	}
	log.Printf("[DEBUG] Configuration : %#v", configuration)
	return configuration, nil
}
