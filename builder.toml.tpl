# DO NOT EDIT - this file is the output of the 'builder.toml.tpl.tpl' template 
buildpacks = [
  { id = "io.projectriff.command", uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-0.2.0-BUILD-SNAPSHOT-20200416130833-f04a8b4e90d0cf9b.tgz" },
  { id = "io.projectriff.java", uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-0.3.0-BUILD-SNAPSHOT-20200420194155-997ca8c22f8743e6.tgz" },
  { id = "io.projectriff.node", uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-0.3.1-BUILD-SNAPSHOT-20200430134817-2149940fa6aa030f.tgz" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/build-system-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/node-engine", uri = "https://github.com/paketo-buildpacks/node-engine/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/node-engine").Version' }}/node-engine-{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/node-engine").Version' }}.tgz" },
  { id = "paketo-buildpacks/yarn-install", uri = "https://github.com/paketo-buildpacks/yarn-install/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/yarn-install").Version' }}/yarn-install-{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/yarn-install").Version' }}.tgz" },
  { id = "paketo-buildpacks/npm", uri = "https://github.com/paketo-buildpacks/npm/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/npm").Version' }}/npm-{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/npm").Version' }}.tgz" },
  { id = "org.cloudfoundry.openjdk", uri = "https://storage.googleapis.com/cnb-buildpacks/openjdk-cnb/org.cloudfoundry.openjdk-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/openjdk-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.openjdk" },
  { id = "org.cloudfoundry.buildsystem", optional = true },
  { id = "io.projectriff.java" },
]

[[order]]
group = [
  { id = "paketo-buildpacks/node-engine" },
  { id = "paketo-buildpacks/yarn-install" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "paketo-buildpacks/node-engine" },
  { id = "paketo-buildpacks/npm" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "paketo-buildpacks/node-engine" },
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
