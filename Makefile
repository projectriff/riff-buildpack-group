PACK=go run github.com/buildpacks/pack/cmd/pack

.PHONY: build build-dev test grab-run-image templates

build: builder.toml
	$(PACK) create-builder -b builder.toml projectriff/builder

build-dev: builder-dev.toml
	$(PACK) create-builder -b builder-dev.toml projectriff/builder

test: grab-run-image
	GO111MODULE=on go test -v -tags=acceptance ./acceptance

grab-run-image:
	docker pull cloudfoundry/build:base-cnb
	docker pull cloudfoundry/run:base-cnb

builder.toml: builder.toml.tpl go.mod
	./ci/apply-template.sh builder.toml.tpl > builder.toml

builder-dev.toml: builder-dev.toml.tpl go.mod
	./ci/apply-template.sh builder-dev.toml.tpl > builder-dev.toml

clean:
	rm builder.toml
	rm builder-dev.toml

templates:
	./ci/apply-template.sh builder.toml.tpl.tpl > builder.toml.tpl
	./ci/apply-template.sh riff-application-clusterbuilder.yaml.tpl > riff-application-clusterbuilder.yaml
