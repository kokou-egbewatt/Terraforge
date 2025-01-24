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
BUILDDIR ?= bin
BINDIR ?= /usr/local/bin
DATADIR ?= /usr/local/share/terraforge
ADDFLAGS ?=
TERRAFORGE_DEBUG ?= false

# Suppress directory messages
MAKEFLAGS += --no-print-directory

# Ensure the build directory exists
$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

.PHONY: clean
clean: ## removes all build artifacts
	@echo "---> Cleaning up executables and build artifacts."
	rm -rf $(BUILDDIR)

.PHONY: build
build: $(BUILDDIR) ## builds the binary in development mode
	@echo "---> Building terraforge executables in development mode."
	@$(SCRIPTS_PATH)/terraforge-build.sh $(BUILDDIR) $(ADDFLAGS)

.PHONY: release 
release: $(BUILDDIR) ## builds the binary for release
	@echo "---> Building terraforge executables for release."
	$(SCRIPTS_PATH)/terraforge-build.sh $(BUILDDIR) --release $(ADDFLAGS)

.PHONY: test
test: build ## runs tests 
	@echo "---> Running tests."
	$(SCRIPTS_PATH)/terraforge-test.sh $(BUILDDIR)

.PHONY: docker
docker: ## builds the Docker image
	@echo "---> Building Docker image $(DOCKER_IMAGE):$(GIT_TAG)."
	docker build -t $(DOCKER_IMAGE):$(GIT_TAG) .

.PHONY: install
install: build ## installs the binary and data files
	@echo "---> Installing terraforge binary and data files."
	install -m 755 $(BUILDDIR)/terraforge $(BINDIR)/terraforge
	install -d $(DATADIR)
	cp -r data/* $(DATADIR)

.PHONY: uninstall
uninstall: ## removes installed files
	@echo "---> Uninstalling terraforge."
	rm -f $(BINDIR)/terraforge
	rm -rf $(DATADIR)

# Default target: 
.PHONY: help
help: ## shows usage information
	@$(SCRIPTS_PATH)/make_help.sh "$(MAKEFILE_LIST)"

.DEFAULT_GOAL := help
