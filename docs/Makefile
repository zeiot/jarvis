# Copyright (C) 2016-2017 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


APPNAME="jarvis-doc"

SHELL = /bin/bash

DOCKER=/usr/bin/docker

DOCKER_IMAGE=rochdev/alpine-asciidoctor

BOOK = index.adoc

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-20s\033[0m

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APPNAME) ====$(NO_COLOR)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Cleanup environment
	find . -type f -name \*.html -exec rm -f {} \;
	find . -type f -name \*.pdf -exec rm -f {} \;
	find . -type f -name \*.pdfmarks -exec rm -f {} \;
	find . -type f -name \*.epub -exec rm -f {} \;

.PHONY: doc-html
doc-html: ## Make HTML version of the documentation (lang=xx)
	@echo -e "$(OK_COLOR)[$(APPNAME)] Documentation HTML $(NO_COLOR)"
	@docker run -it -v `pwd`:/documents/ rochdev/alpine-asciidoctor \
	    asciidoctor ${lang}/$(BOOK) \
	    -a stylesheet=default.css \
	    -a stylesdir=/documents/resources -d book -a toc2

.PHONY: doc-pdf
doc-pdf: ## Generate PDF version of the documentation (lang=xx)
	@echo -e "$(OK_COLOR)[$(APPNAME)] Documentation PDF $(NO_COLOR)"
	@docker run -it -v `pwd`:/documents/ rochdev/alpine-asciidoctor \
	    asciidoctor-pdf ${lang}/$(BOOK) \
	    -a imagesdir=/documents \
	    -a pdf-stylesdir=/documents/resources \
	    -a pdf-fontsdir=/documents/assets/fonts \
	    -a pdf-style=custom -d book -a toc2

.PHONY: epub
epub: ## Generate ePUB version of the documentation (lang=xx)
	$(DOCKER) run --rm=true \
		-it -v `pwd`:/documents/ \
		$(DOCKER_IMAGE) asciidoctor-epub3 ${lang}/$(BOOK)
