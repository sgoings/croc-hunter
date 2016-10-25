default: build test docker_build

SHELL := /bin/bash

check-docker:
	@if [ -z $$(which docker) ]; then \
		echo "Missing \`docker\` client which is required for development"; \
		exit 2; \
	fi

clean: check-docker
	rm -rf bin/
	docker images -q ${DOCKER_IMAGE} | xargs docker rmi -f

SHORT_NAME := croc-hunter
DOCKER_IMAGE ?= quay.io/lachie83/$(SHORT_NAME)
DOCKER_TAG ?= `git rev-parse --abbrev-ref HEAD`
VCS_REF ?= `git rev-parse --short HEAD`
REPO_PATH := github.com/lachie83/${SHORT_NAME}

# The following variables describe the containerized development environment
# and other build options
DEV_ENV_IMAGE := quay.io/deis/go-dev:0.17.0
DEV_ENV_WORK_DIR := /go/src/${REPO_PATH}
DEV_ENV_CMD := docker run --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR} ${DEV_ENV_IMAGE}
DEV_ENV_CMD_INT := docker run -it --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR} ${DEV_ENV_IMAGE}

.PHONY: docker_build
docker_build:
	@docker build \
	  --build-arg VCS_REF=$(VCS_REF) \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

.PHONY: docker_push
docker_push:
	# Push to DockerHub
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

.PHONY: docker_run
docker_run:
	@docker run -p 8080:8080 $(DOCKER_IMAGE):$(DOCKER_TAG)

# go option
GO        ?= go
PKG       := $(shell glide novendor)
TAGS      :=
TESTS     := .
TESTFLAGS :=
LDFLAGS   :=
GOFLAGS   :=
BINDIR    := $(CURDIR)/bin

.PHONY: all
all: build

.PHONY: build
build:
	${DEV_ENV_CMD} make binary-build

.PHONY: binary-build
binary-build:
	GOOS=linux GOARCH=amd64 $(GO) build -o ${BINDIR}/${SHORT_NAME} $(GOFLAGS) -tags '$(TAGS)' -ldflags '$(LDFLAGS)' github.com/lachie83/croc-hunter/...

test: test-style test-unit test-functional

test-cover:
	${DEV_ENV_CMD} test-cover.sh

test-functional:
	@echo no functional tests

test-style: check-docker
	${DEV_ENV_CMD} make style-check

# This should only be executed within the containerized development environment.
style-check:
	lint

test-unit:
	${DEV_ENV_CMD} go test --cover --race -v ${GO_PACKAGES}

HAS_GLIDE := $(shell command -v glide;)
HAS_GIT := $(shell command -v git;)

.PHONY: bootstrap
bootstrap:
ifndef HAS_GLIDE
	go get -u github.com/Masterminds/glide
endif
ifndef HAS_GIT
	$(error You must install Git)
endif
	glide install
