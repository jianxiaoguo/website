# If DRYCC_REGISTRY is not set, try to populate it from legacy DEV_REGISTRY
DRYCC_REGISTRY ?= $(DEV_REGISTRY)
IMAGE_PREFIX ?= drycc
COMPONENT ?= website
SHORT_NAME ?= $(COMPONENT)
VERSION ?= git-$(shell git rev-parse --short HEAD)
IMAGE := $(DRYCC_REGISTRY)/$(IMAGE_PREFIX)/$(SHORT_NAME):${VERSION}

check-podman:
	@if [ -z $$(which podman) ]; then \
	  echo "Missing \`podman\` client which is required for development"; \
	  exit 2; \
	fi

build-image: check-podman
	podman build -t ${IMAGE} .

build: check-podman build-image
	podman run --rm -w /root/go/src/website -v $(shell pwd):/root/go/src/website ${IMAGE}