PACK ?= pack
BUILDER ?= projectriff/builder:dev-$(shell openssl dgst -md5 builder.toml | cut -d' ' -f2)

.PHONY: build test

build:
	$(PACK) create-builder -b builder.toml $(BUILDER)

test:
	BUILDER=$(BUILDER) go test -v -tags=acceptance -count=1 ./acceptance
