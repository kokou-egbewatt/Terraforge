# Make targets:
#
#  build    : build binary in development mode
#  release  : build binary for release
#  clean    : removes all build artifacts
#  test     : runs tests

VERSION = 0.0.1
DOCKER_IMAGE ?= terraforge
GIT_TAG = v$(VERSION)
SCRIPTS_PATH := ci/scripts

# Standard autotools variables
ifneq ("$(wildcard /bin/bash)", "")
	SHELL := /bin/bash -o pipefail
endif
BUILD_DIR ?= "build"
DIST_DIR ?= dist
BIN_DIR ?= "/usr/local/bin"
DATA_DIR ?= "/usr/local/share/terraforge"
ADDFLAGS ?=
TERRAFORGE_DEBUG ?= false

# Suppress directory messages
MAKEFLAGS += --no-print-directory
# Suppress command outputs
MAKEFLAGS += --silent

# Ensure the build directory exists
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

.PHONY: clean
clean: ## removes all build artifacts
	@echo "---> Cleaning up executables and build artifacts."
	rm -rf $(BUILD_DIR)

.PHONY: build
build: clean $(BUILD_DIR) ## builds the binary in development mode
	@echo "---> Building terraforge executables in development mode."
	$(SCRIPTS_PATH)/terraforge-build.sh $(BUILD_DIR) $(ADDFLAGS)

.PHONY: release 
release: $(BUILD_DIR) ## builds the binary for release
	@echo "---> Building terraforge executables for release."
	$(SCRIPTS_PATH)/terraforge-build.sh $(BUILD_DIR) --release $(ADDFLAGS)

.PHONY: test
test: build ## runs tests 
	@echo "---> Running tests."
	$(SCRIPTS_PATH)/terraforge-test.sh $(DIST_DIR)

.PHONY: docker
docker: ## builds the Docker image
	@echo "---> Building Docker image $(DOCKER_IMAGE):$(GIT_TAG)."
	docker build -t $(DOCKER_IMAGE):$(GIT_TAG) .

.PHONY: install
install: build ## installs the binary and data files
	@echo "---> Installing terraforge binary and data files."
	mv $(BUILD_DIR)/terraforge* $(BUILD_DIR)/terraforge
	sudo install -m 755 $(BUILD_DIR)/terraforge $(BIN_DIR)/terraforge
	sudo mkdir -p $(DATA_DIR) 
	sudo install -d $(DATA_DIR)
# sudo cp -r data/* $(DATA_DIR)

.PHONY: uninstall
uninstall: ## removes installed files
	@echo "---> Uninstalling terraforge."
	sudo rm -f $(BIN_DIR)/terraforge
	sudo rm -rf $(DATA_DIR)

# Default target: 
.PHONY: help
help: ## shows usage information
	@$(SCRIPTS_PATH)/make_help.sh "$(MAKEFILE_LIST)"

.DEFAULT_GOAL := help
