# DO NOT EDIT - this file is the output of the 'builder.toml.tpl.tpl' template 
buildpacks = [
  { id = "io.projectriff.command",       uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-0.0.10-BUILD-SNAPSHOT-20200204162215-5d779e379756b1d2.tgz" },
  { id = "io.projectriff.java",          uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-0.2.0-BUILD-SNAPSHOT-20200204191020-a4f1864263af3726.tgz" },
  { id = "io.projectriff.node",          uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-0.2.0-BUILD-SNAPSHOT-20200204190933-c76e08c9aedab124.tgz" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/build-system-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "org.cloudfoundry.node-engine", uri = "https://github.com/cloudfoundry/node-engine-cnb/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/node-engine-cnb").Version' }}/node-engine-cnb-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/node-engine-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "org.cloudfoundry.npm",         uri = "https://github.com/cloudfoundry/npm-cnb/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/npm-cnb").Version' }}/npm-cnb-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/npm-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
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
  { id = "org.cloudfoundry.npm" },
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

[stack]
id          = "io.buildpacks.stacks.bionic"
build-image = "cloudfoundry/build:base-cnb"
run-image   = "cloudfoundry/run:base-cnb"
