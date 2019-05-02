.PHONY: build build-dev test grab-run-image

build:
	pack create-builder -b builder.toml projectriff/builder

build-dev:
	pack create-builder -b builder-dev.toml projectriff/builder

test: grab-run-image
	go test -v -tags=acceptance ./acceptance

grab-run-image:
	docker pull packs/run:0.1.0

