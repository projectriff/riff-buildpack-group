.PHONY: build build-dev test grab-run-image templates

build:
	pack create-builder -b builder.toml projectriff/builder

build-dev:
	pack create-builder -b builder-dev.toml projectriff/builder

test: grab-run-image
	GO111MODULE=on go test -v -tags=acceptance ./acceptance

grab-run-image:
	docker pull cloudfoundry/build:base-cnb
	docker pull cloudfoundry/run:base-cnb

templates:
	./apply-template.sh builder.toml.tpl builder.toml
	./apply-template.sh riff-application-clusterbuilder.yaml.tpl riff-application-clusterbuilder.yaml
