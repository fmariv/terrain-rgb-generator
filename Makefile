#
# First section - common variable initialization
#

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Make all .env variables available for make targets
include .env

# Docker image and container names
CONTAINER     = terrain-rgb-generator
IMAGE         = franmartin/terrain-rgb-generator
export CONTAINER
export IMAGE


define HELP_MESSAGE
====================================================================================================
 Terrain RGB generator  https://github.com/fmariv/terrain-rgb-generator

Hints for tile pyramid generation:
  make generate-pyramid-rgb            # generate the tile pyramid in RGB data

Hints for Docker management:
  make build-docker                    # build the docker container from the dockerfile
  make bash              			   # execute the shell bash inside the container
  make remove-docker-images            # remove docker images
  make list-docker-images              # show a list of available docker images
====================================================================================================
endef
export HELP_MESSAGE

#
#  TARGETS
#

.PHONY: all
all: init-dirs

.PHONY: help
help:
	@echo "$$HELP_MESSAGE" | less
 
.PHONY: init-dirs
init-dirs:
	@mkdir -p data

.PHONY: build-docker
build-docker:
	@docker build . -t $(CONTAINER)

.PHONY: bash
bash:
	@docker run --rm -it --name $(CONTAINER) -v $$(pwd)/data:/opt/dem $(IMAGE) bash

.PHONY: generate-pyramid-rgb
generate-pyramid-rgb: init-dirs
	@echo "Generating the tile pyramid in RGB..."
	@docker run --rm -it --name $(CONTAINER) -v $$(pwd)/data:/opt/dem $(IMAGE) \
	 "rio rgbify -b -10000 -i 0.1 --min-z $(MIN_ZOOM) --max-z $(MAX_ZOOM) -j $(WORKERS) --format png opt/dem/$(INPUT_FILE) opt/dem/$(OUTPUT_FILE)"
	@echo "Tile RGB pyramid generated"

.PHONY: list-docker-images
list-docker-images:
	docker images | grep terrain-rgb-generator

.PHONY: remove-docker-images
remove-docker-images:
	@echo "Deleting all related docker image(s)..."
	@docker image rm $(IMAGE)