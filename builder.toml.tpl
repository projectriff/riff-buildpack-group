# DO NOT EDIT - this file is the output of the 'builder.toml.tpl.tpl' template 
buildpacks = [
  { id = "io.projectriff.command",       uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-0.2.0-BUILD-SNAPSHOT-20200304161811-a66028adfc6d2ab6.tgz" },
  { id = "io.projectriff.java",          uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-0.3.0-BUILD-SNAPSHOT-20200324133014-3be580e2930f3290.tgz" },
  { id = "io.projectriff.node",          uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-0.3.0.tgz" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/build-system-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "org.cloudfoundry.node-engine", uri = "https://github.com/cloudfoundry/node-engine-cnb/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/node-engine-cnb").Version' }}/node-engine-cnb-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/node-engine-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/yarn-install",        uri = "https://github.com/cloudfoundry/yarn-install-cnb/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/yarn-install-cnb").Version' }}/yarn-install-cnb-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/yarn-install-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/npm",         uri = "https://github.com/cloudfoundry/npm-cnb/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/npm-cnb").Version' }}/npm-cnb-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/npm-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "org.cloudfoundry.openjdk",     uri = "https://storage.googleapis.com/cnb-buildpacks/openjdk-cnb/org.cloudfoundry.openjdk-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/openjdk-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.openjdk" },
  { id = "org.cloudfoundry.buildsystem", optional = true },
  { id = "io.projectriff.java" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.node-engine" },
  { id = "paketo-buildpacks/yarn-install" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.node-engine" },
  { id = "paketo-buildpacks/npm" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.node-engine" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
 { id = "io.projectriff.command" },
]

[lifecycle]
version = "0.7.2"

[stack]
id          = "io.buildpacks.stacks.bionic"
build-image = "cloudfoundry/build:base-cnb"
run-image   = "cloudfoundry/run:base-cnb"
