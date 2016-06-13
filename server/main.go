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

package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/labstack/echo/engine/standard"

	"github.com/zeiot/jarvis/server/api"
	"github.com/zeiot/jarvis/server/config"
	"github.com/zeiot/jarvis/server/logging"
	"github.com/zeiot/jarvis/server/messages"
	"github.com/zeiot/jarvis/server/version"
)

var (
	debug          bool
	displayVersion bool
)

func init() {
	// parse flags
	flag.BoolVar(&displayVersion, "version", false, "print version and exit")
	flag.BoolVar(&displayVersion, "v", false, "print version and exit (shorthand)")
	flag.BoolVar(&debug, "d", false, "run in debug mode")
	flag.Parse()
}

func userHomeDir() string {
	return os.Getenv("HOME")
}

func getConfigurationFile() string {
	return fmt.Sprintf("%s/.config/jarvis/jarvis.toml", userHomeDir())
}

func main() {
	if displayVersion {
		fmt.Printf("Jarvis server v%s\n", version.Version)
		return
	}
	if debug {
		logging.SetLogging("DEBUG")
	} else {
		logging.SetLogging("INFO")
	}

	conf, err := config.LoadFileConfig(getConfigurationFile())
	if err != nil {
		log.Printf("[ERROR] [jarvis] Error with configuration: %v", err.Error())
		return
	}

	mqttClient, err := messages.NewSubscriber(conf.MqttBrokerURL)
	if err != nil {
		log.Printf("[ERROR] [jarvis] Can't create the MQTT client: %v", err)
		return
	}
	err = mqttClient.Connect()
	if err != nil {
		log.Printf("[ERROR] [jarvis] Can't connect the MQTT broker: %v", err)
		return
	}
	mqttClient.Status()

	ws := api.GetWebService(nil)
	if debug {
		ws.Debug()
	}
	ws.Run(standard.New(fmt.Sprintf(":%s", "8080")))
}
