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

package v1

import (
	//"fmt"
	"log"
)

// WebService represents the Restful API
type WebService struct {
}

// APIVersion represents version of the REST API
type APIVersion struct {
	Version string `json:"version"`
}

// APIErrorResponse reprensents an error in JSON
type APIErrorResponse struct {
	Error string `json:"error"`
}

// NewWebService creates a new WebService instance
func NewWebService() *WebService {
	log.Printf("[DEBUG] [jarvis] Creates webservice")
	return &WebService{}
}
