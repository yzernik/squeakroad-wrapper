EMVER := $(shell yq e ".version" manifest.yaml)
SQUEAKROAD_SRC := $(shell find ./squeakroad)
S9PK_PATH=$(shell find . -name squeakroad.s9pk -print)

.DELETE_ON_ERROR:

all: verify

verify: squeakroad.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

install: squeakroad.s9pk
	embassy-cli package install squeakroad.s9pk

squeakroad.s9pk: manifest.yaml assets/* image.tar docs/instructions.md LICENSE icon.png
	embassy-sdk pack

image.tar: Dockerfile docker_entrypoint.sh assets/utils/*
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/squeakroad/main:${EMVER}	--platform=linux/arm64/v8 -f Dockerfile -o type=docker,dest=image.tar .

clean:
	rm -f squeakroad.s9pk
	rm -f image.tar
