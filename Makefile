# Copyright 2019 Google LLC
#
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

## Open Match Documentation Make Help
## ==================================
##
## Run local version of website.
## make run-site
##
## Prepare a Pull Request
## make presubmit

# If you want information on how to edit this file checkout,
# http://makefiletutorial.com/

BASE_VERSION = 1.4.0
SHORT_SHA = $(shell git rev-parse --short=7 HEAD | tr -d [:punct:])
VERSION_SUFFIX = $(SHORT_SHA)
BRANCH_NAME = $(shell git rev-parse --abbrev-ref HEAD | tr -d [:punct:])
VERSION = $(BASE_VERSION)-$(VERSION_SUFFIX)
BUILD_DATE = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
YEAR_MONTH = $(shell date -u +'%Y%m')
MAJOR_MINOR_VERSION = $(shell echo $(BASE_VERSION) | cut -d '.' -f1).$(shell echo $(BASE_VERSION) | cut -d '.' -f2)

HUGO_VERSION = 0.82.1
NODEJS_VERSION = 16.13.2
HTMLTEST_VERSION = 0.10.3
GOLANGCI_VERSION = 1.17.1
SWAGGERUI_VERSION = 3.22.3

GO = GO111MODULE=on go
# Defines the absolute local directory of the open-match project
REPOSITORY_ROOT := $(patsubst %/,%,$(dir $(abspath $(MAKEFILE_LIST))))
GO_BUILD_COMMAND = CGO_ENABLED=0 $(GO) build -a -installsuffix cgo .
BUILD_DIR_REL = build
TOOLCHAIN_DIR_REL = build/toolchain
TOOLCHAIN_BIN_REL = build/toolchain/bin
BUILD_DIR = $(REPOSITORY_ROOT)/$(BUILD_DIR_REL)
SITE_DIR = $(REPOSITORY_ROOT)/site
TOOLCHAIN_DIR = $(REPOSITORY_ROOT)/$(TOOLCHAIN_DIR_REL)
TOOLCHAIN_BIN = $(REPOSITORY_ROOT)/$(TOOLCHAIN_BIN_REL)
NODEJS_BIN = $(TOOLCHAIN_DIR)/nodejs/bin
GCP_PROJECT_ID ?=
GCP_PROJECT_FLAG = --project=$(GCP_PROJECT_ID)
OM_SITE_GCP_PROJECT_ID = open-match-site
OM_SITE_GCP_PROJECT_FLAG = --project=$(OM_SITE_GCP_PROJECT_ID)
EXE_EXTENSION =
GO111MODULE = on
SITE_HOST = localhost
SITE_PORT = 8080
RENDERED_SITE_DIR_REL = build/site
RENDERED_SITE_DIR = $(REPOSITORY_ROOT)/build/site
HTMLTEST_REL = $(TOOLCHAIN_BIN_REL)/htmltest$(EXE_EXTENSION)
HUGO_REL = $(TOOLCHAIN_BIN_REL)/hugo$(EXE_EXTENSION)
GOLANGCI_REL = $(TOOLCHAIN_BIN_REL)/golangci-lint$(EXE_EXTENSION)
HTMLTEST = $(REPOSITORY_ROOT)/$(HTMLTEST_REL)
HUGO = $(REPOSITORY_ROOT)/$(HUGO_REL)
GOLANGCI = $(REPOSITORY_ROOT)/$(GOLANGCI_REL)
GCLOUD_ACCOUNT_EMAIL = $(shell gcloud auth list --format yaml | grep account: | cut -c 10-)
_GCB_POST_SUBMIT ?= 0
# Latest version triggers builds of :latest images and deploy to main website.
_GCB_LATEST_VERSION ?= undefined
IMAGE_BUILD_ARGS=--build-arg BUILD_DATE=$(BUILD_DATE) --build-arg=VCS_REF=$(SHORT_SHA) --build-arg BUILD_VERSION=$(BASE_VERSION)

# AppEngine variables
GAE_SITE_VERSION = om$(YEAR_MONTH)

# If the version is 0.0* then the service name is "development" as in development.open-match.dev.
ifeq ($(MAJOR_MINOR_VERSION),0.0)
	GAE_SERVICE_NAME = development
	OPEN_MATCH_REMOTE_BRANCH = main
else
	GAE_SERVICE_NAME = $(shell echo $(MAJOR_MINOR_VERSION) | tr . -)
	OPEN_MATCH_REMOTE_BRANCH = release-$(MAJOR_MINOR_VERSION)
endif

export PATH := $(REPOSITORY_ROOT)/node_modules/.bin/:$(TOOLCHAIN_BIN):$(TOOLCHAIN_DIR)/nodejs/bin:$(PATH)

# Get the project from gcloud if it's not set.
ifeq ($(GCP_PROJECT_ID),)
	export GCP_PROJECT_ID = $(shell gcloud config list --format 'value(core.project)')
endif

ifeq ($(OS),Windows_NT)
	# TODO: Windows packages are here but things are broken since many paths are Linux based and zip vs tar.gz.
	EXE_EXTENSION = .exe
	HUGO_PACKAGE = https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_Windows-64bit.zip
	NODEJS_PACKAGE = https://nodejs.org/dist/v$(NODEJS_VERSION)/node-v$(NODEJS_VERSION)-win-x64.zip
	NODEJS_PACKAGE_NAME = nodejs.zip
	HTMLTEST_PACKAGE = https://github.com/wjdp/htmltest/releases/download/v$(HTMLTEST_VERSION)/htmltest_$(HTMLTEST_VERSION)_windows_amd64.zip
	GOLANGCI_PACKAGE = https://github.com/golangci/golangci-lint/releases/download/v$(GOLANGCI_VERSION)/golangci-lint-$(GOLANGCI_VERSION)-windows-amd64.zip
	SED_REPLACE = sed -i
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		HUGO_PACKAGE = https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_Linux-64bit.tar.gz
		NODEJS_PACKAGE = https://nodejs.org/dist/v$(NODEJS_VERSION)/node-v$(NODEJS_VERSION)-linux-x64.tar.gz
		NODEJS_PACKAGE_NAME = nodejs.tar.gz
		HTMLTEST_PACKAGE = https://github.com/wjdp/htmltest/releases/download/v$(HTMLTEST_VERSION)/htmltest_$(HTMLTEST_VERSION)_linux_amd64.tar.gz
		GOLANGCI_PACKAGE = https://github.com/golangci/golangci-lint/releases/download/v$(GOLANGCI_VERSION)/golangci-lint-$(GOLANGCI_VERSION)-linux-amd64.tar.gz
		SED_REPLACE = sed -i
	endif
	ifeq ($(UNAME_S),Darwin)
		HUGO_PACKAGE = https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_macOS-64bit.tar.gz
		NODEJS_PACKAGE = https://nodejs.org/dist/v$(NODEJS_VERSION)/node-v$(NODEJS_VERSION)-darwin-x64.tar.gz
		NODEJS_PACKAGE_NAME = nodejs.tar.gz
		HTMLTEST_PACKAGE = https://github.com/wjdp/htmltest/releases/download/v$(HTMLTEST_VERSION)/htmltest_$(HTMLTEST_VERSION)_osx_amd64.tar.gz
		GOLANGCI_PACKAGE = https://github.com/golangci/golangci-lint/releases/download/v$(GOLANGCI_VERSION)/golangci-lint-$(GOLANGCI_VERSION)-darwin-amd64.tar.gz
		SED_REPLACE = sed -i ''
	endif
endif

help:
	@cat Makefile | grep ^\#\# | grep -v ^\#\#\# |cut -c 4-

local-cloud-build: LOCAL_CLOUD_BUILD_PUSH = # --push
local-cloud-build: gcloud
	cloud-build-local --config=cloudbuild.yaml --dryrun=false $(LOCAL_CLOUD_BUILD_PUSH) --substitutions SHORT_SHA=$(VERSION_SUFFIX),_GCB_POST_SUBMIT=$(_GCB_POST_SUBMIT),_GCB_LATEST_VERSION=$(_GCB_LATEST_VERSION),BRANCH_NAME=$(BRANCH_NAME) .

install-toolchain: build/toolchain/bin/hugo$(EXE_EXTENSION) build/toolchain/bin/htmltest$(EXE_EXTENSION) build/toolchain/nodejs/

$(HUGO_REL):
	mkdir -p $(TOOLCHAIN_BIN)
	mkdir -p $(TOOLCHAIN_DIR)/temp-hugo
ifeq ($(suffix $(HUGO_PACKAGE)),.zip)
	cd $(TOOLCHAIN_DIR)/temp-hugo && curl -Lo hugo.zip $(HUGO_PACKAGE) && unzip -q -o hugo.zip
else
	cd $(TOOLCHAIN_DIR)/temp-hugo && curl -Lo hugo.tar.gz $(HUGO_PACKAGE) && tar xzf hugo.tar.gz
endif
	mv $(TOOLCHAIN_DIR)/temp-hugo/hugo$(EXE_EXTENSION) $(TOOLCHAIN_BIN)/hugo$(EXE_EXTENSION)
	rm -rf $(TOOLCHAIN_DIR)/temp-hugo/

$(HTMLTEST_REL):
	mkdir -p $(TOOLCHAIN_BIN)
	mkdir -p $(TOOLCHAIN_DIR)/temp-htmltest
ifeq ($(suffix $(HTMLTEST_PACKAGE)),.zip)
	cd $(TOOLCHAIN_DIR)/temp-htmltest && curl -Lo htmltest.zip $(HTMLTEST_PACKAGE) && unzip -q -o htmltest.zip
else
	cd $(TOOLCHAIN_DIR)/temp-htmltest && curl -Lo htmltest.tar.gz $(HTMLTEST_PACKAGE) && tar xzf htmltest.tar.gz
endif
	mv $(TOOLCHAIN_DIR)/temp-htmltest/htmltest$(EXE_EXTENSION) $(TOOLCHAIN_BIN)/htmltest$(EXE_EXTENSION)
	rm -rf $(TOOLCHAIN_DIR)/temp-htmltest/

$(GOLANGCI_REL):
	mkdir -p $(TOOLCHAIN_BIN)
	mkdir -p $(TOOLCHAIN_DIR)/temp-golangci
ifeq ($(suffix $(GOLANGCI_PACKAGE)),.zip)
	cd $(TOOLCHAIN_DIR)/temp-golangci && curl -Lo golangci.zip $(GOLANGCI_PACKAGE) && unzip -j -q -o golangci.zip
else
	cd $(TOOLCHAIN_DIR)/temp-golangci && curl -Lo golangci.tar.gz $(GOLANGCI_PACKAGE) && tar xzf golangci.tar.gz --strip-components 1
endif
	mv $(TOOLCHAIN_DIR)/temp-golangci/golangci-lint$(EXE_EXTENSION) $(TOOLCHAIN_BIN)/golangci-lint$(EXE_EXTENSION)
	rm -rf $(TOOLCHAIN_DIR)/temp-golangci/

build/archives/$(NODEJS_PACKAGE_NAME):
	mkdir -p $(BUILD_DIR)/archives/
	cd $(BUILD_DIR)/archives/ && curl -L -o $(NODEJS_PACKAGE_NAME) $(NODEJS_PACKAGE)

build/toolchain/nodejs/: build/archives/$(NODEJS_PACKAGE_NAME)
	mkdir -p $(TOOLCHAIN_DIR)/nodejs/
ifeq ($(suffix $(NODEJS_PACKAGE_NAME)),.zip)
	# TODO: This is broken, there's the node-v10.15.3-win-x64 directory also windows does not have the bin/ directory.
	# https://superuser.com/questions/518347/equivalent-to-tars-strip-components-1-in-unzip
	cd $(TOOLCHAIN_DIR)/nodejs/ && unzip -q -o $(BUILD_DIR)/archives/$(NODEJS_PACKAGE_NAME)
else
	cd $(TOOLCHAIN_DIR)/nodejs/ && tar xzf $(BUILD_DIR)/archives/$(NODEJS_PACKAGE_NAME) --strip-components 1
endif

# Fake target for gcloud
docker: no-sudo

# Fake target for gcloud
gcloud: no-sudo

build:
	(cd $(SITE_DIR) && $(GO) build ./...)

test:
	(cd $(SITE_DIR) && $(GO) test ./... -race -test.count 50 -cover)

fmt:
	(cd $(SITE_DIR) && $(GO) fmt ./... && gofmt -s -w .)

vet:
	(cd $(SITE_DIR) && $(GO) vet ./...)

lint: fmt vet golangci

golangci: $(GOLANGCI_REL)
	(cd $(SITE_DIR) && $(GOLANGCI) run --config=$(REPOSITORY_ROOT)/.golangci.yaml)

node_modules/: build/toolchain/nodejs/
	-rm -r $(REPOSITORY_ROOT)/package.json $(REPOSITORY_ROOT)/package-lock.json
	-rm -rf $(REPOSITORY_ROOT)/node_modules/
	echo "{}" > $(REPOSITORY_ROOT)/package.json
	$(NODEJS_BIN)/npm install postcss
	$(NODEJS_BIN)/npm install postcss-scss
	$(NODEJS_BIN)/npm install postcss-cli autoprefixer
	$(TOOLCHAIN_DIR)/nodejs/bin/npm install postcss-cli autoprefixer
	$(TOOLCHAIN_DIR)/nodejs/bin/npm install ts-node

$(RENDERED_SITE_DIR_REL)/: $(HUGO_REL) site/static/swaggerui/ node_modules/
	rm -rf $(RENDERED_SITE_DIR)/
	mkdir -p $(RENDERED_SITE_DIR)/
	cd $(SITE_DIR) && $(HUGO) --config=config.toml --source . --destination $(RENDERED_SITE_DIR)/public/
	# Only copy the root directory since that has the AppEngine serving code.
	-cp -f $(SITE_DIR)/* $(RENDERED_SITE_DIR)
	-cp -f $(SITE_DIR)/.gcloudignore $(RENDERED_SITE_DIR)/.gcloudignore
	cp $(RENDERED_SITE_DIR)/app.yaml $(RENDERED_SITE_DIR)/.app.yaml

site/static/swaggerui/:
	mkdir -p $(TOOLCHAIN_DIR)/swaggerui-temp/
	mkdir -p $(TOOLCHAIN_BIN)
	curl -o $(TOOLCHAIN_DIR)/swaggerui-temp/swaggerui.zip -L \
		https://github.com/swagger-api/swagger-ui/archive/v$(SWAGGERUI_VERSION).zip
	(cd $(TOOLCHAIN_DIR)/swaggerui-temp/; unzip -q -o swaggerui.zip)
	cp -rf $(TOOLCHAIN_DIR)/swaggerui-temp/swagger-ui-$(SWAGGERUI_VERSION)/dist/ \
		$(SITE_DIR)/static/swaggerui
	# Update the Swagger doc URLs to point to the same version as 
	curl -L -o $(SITE_DIR)/static/swaggerui/config.json https://raw.githubusercontent.com/googleforgames/open-match/$(OPEN_MATCH_REMOTE_BRANCH)/third_party/swaggerui/config.json
	$(SED_REPLACE) 's|url:.*|configUrl: "config.json",|g' $(SITE_DIR)/static/swaggerui/index.html
	rm -rf $(TOOLCHAIN_DIR)/swaggerui-temp

md-test: docker
	docker run -t --rm -v $(CURDIR):/mnt:ro dkhamsing/awesome_bot --white-list "localhost,github.com/googleforgames/open-match/tree/release-,github.com/googleforgames/open-match/blob/release-,github.com/googleforgames/open-match/releases/download/v" --allow-dupe --allow-redirect --skip-save-results `find . -type f -name '*.md' -not -path './build/*' -not -path './node_modules/*' -not -path './site*' -not -path './.git*'`

site-test: TEMP_SITE_DIR := /tmp/open-match-site
site-test: $(RENDERED_SITE_DIR_REL)/ $(HTMLTEST_REL)
	rm -rf $(TEMP_SITE_DIR)
	mkdir -p $(TEMP_SITE_DIR)/site/
	cp -rf $(RENDERED_SITE_DIR)/public/* $(TEMP_SITE_DIR)/site/
	$(HTMLTEST) -l 1 --conf $(SITE_DIR)/htmltest.yaml $(TEMP_SITE_DIR)

browse-site: $(RENDERED_SITE_DIR_REL)/
	cd $(RENDERED_SITE_DIR) && dev_appserver.py .app.yaml

deploy-dev-site: $(RENDERED_SITE_DIR_REL)/ gcloud
	cd $(RENDERED_SITE_DIR) && gcloud $(OM_SITE_GCP_PROJECT_FLAG) app deploy .app.yaml --promote --version=$(VERSION_SUFFIX) --quiet

# The website is deployed on Post Submit of every build based on the BASE_VERSION in this file.
# If the site
ci-deploy-site: $(RENDERED_SITE_DIR_REL)/ gcloud
ifeq ($(_GCB_POST_SUBMIT),1)
	@echo "Deploying website to $(GAE_SERVICE_NAME).open-match.dev version=$(GAE_SITE_VERSION)..."
	# Replace "service:"" with "service: $(GAE_SERVICE_NAME)" example, "service: 0-5"
	$(SED_REPLACE) 's/service:.*/service: $(GAE_SERVICE_NAME)/g' $(RENDERED_SITE_DIR)/.app.yaml
	(cd $(RENDERED_SITE_DIR) && gcloud --quiet $(OM_SITE_GCP_PROJECT_FLAG) app deploy .app.yaml --promote --version=$(GAE_SITE_VERSION) --verbosity=info)
	# If the version matches the "latest" version from CI then also deploy to the default instance.
ifeq ($(MAJOR_MINOR_VERSION),$(_GCB_LATEST_VERSION))
	@echo "Deploying website to open-match.dev version=$(GAE_SITE_VERSION)..."
	$(SED_REPLACE) 's/service:.*/service: default/g' $(RENDERED_SITE_DIR)/.app.yaml
	(cd $(RENDERED_SITE_DIR) && gcloud --quiet $(OM_SITE_GCP_PROJECT_FLAG) app deploy .app.yaml --promote --version=$(GAE_SITE_VERSION) --verbosity=info)
	# Set CORS policy on GCS bucket so that Swagger UI will work against it.
	# This only needs to be set once but in the interest of enforcing a consistency we'll apply this every deployment.
	# CORS policies signal to browsers that it's ok to use this resource in services not hosted from itself (open-match.dev)
	gsutil cors set $(SITE_DIR)/gcs-cors.json gs://open-match-chart/
endif
else
	@echo "Not deploying $(GAE_SERVICE_NAME).open-match.dev because this is not a post commit change."
endif

deploy-redirect-site: gcloud
	cd $(SITE_DIR)/redirect/ && gcloud $(OM_SITE_GCP_PROJECT_FLAG) app deploy app.yaml --promote --quiet

run-site: $(HUGO_REL) site/static/swaggerui/
	cd $(SITE_DIR)/ && $(HUGO) server --debug --watch --enableGitInfo . --baseURL=http://$(SITE_HOST):$(SITE_PORT)/ --bind 0.0.0.0 --port $(SITE_PORT) --disableFastRender

# For presubmit we want to update the protobuf generated files and verify that tests are good.
presubmit: clean update-deps lint $(RENDERED_SITE_DIR_REL)/ site-test md-test

clean-site:
	rm -rf $(RENDERED_SITE_DIR)/

clean-build: clean-toolchain clean-archives
	rm -rf $(BUILD_DIR)/

clean-toolchain:
	rm -rf $(TOOLCHAIN_DIR)/

clean-archives:
	rm -rf $(BUILD_DIR)/archives/

clean-nodejs:
	rm -rf $(TOOLCHAIN_DIR)/nodejs/
	rm -rf $(REPOSITORY_ROOT)/node_modules/
	rm -f $(REPOSITORY_ROOT)/package.json
	rm -f $(REPOSITORY_ROOT)/package-lock.json

clean-swaggerui:
	rm -rf $(SITE_DIR)/static/swaggerui/

clean: clean-site clean-build clean-nodejs clean-swaggerui

update-deps:
	cd $(SITE_DIR) && $(GO) mod tidy

sync-deps:
	cd $(SITE_DIR) && GIT_SSL_NO_VERIFY=1 $(GO) mod download

# Prevents users from running with sudo.
# There's an exception for Google Cloud Build because it runs as root.
no-sudo:
ifndef ALLOW_BUILD_WITH_SUDO
ifeq ($(shell whoami),root)
	@echo "ERROR: Running Makefile as root (or sudo)"
	@echo "Please follow the instructions at https://docs.docker.com/install/linux/linux-postinstall/ if you are trying to sudo run the Makefile because of the 'Cannot connect to the Docker daemon' error."
	@echo "NOTE: sudo/root do not have the authentication token to talk to any GCP service via gcloud."
	exit 1
endif
endif

.PHONY: help local-cloud-build install-toolchain gcloud build test fmt vet golangci md-test site-test browse-site deploy-dev-site ci-deploy-site deploy-redirect-site gcloud run-site presubmit clean-site clean-build clean-toolchain clean-archives clean-nodejs clean-swaggerui clean update-deps sync-deps no-sudo
