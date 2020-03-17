buildpacks = [
  { id = "io.projectriff.command",       uri = "../command-function-buildpack/artifactory/io/projectriff/command/io.projectriff.command/latest" },
  { id = "io.projectriff.java",          uri = "../java-function-buildpack/artifactory/io/projectriff/java/io.projectriff.java/latest" },
  { id = "io.projectriff.node",          uri = "../node-function-buildpack/artifactory/io/projectriff/node/io.projectriff.node/latest" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/build-system-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "org.cloudfoundry.node-engine", uri = "https://github.com/cloudfoundry/node-engine-cnb/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/node-engine-cnb").Version' }}/node-engine-cnb-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/node-engine-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "org.cloudfoundry.yarn-install",        uri = "https://github.com/cloudfoundry/yarn-install-cnb/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/yarn-install-cnb").Version' }}/yarn-install-cnb-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/yarn-install-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
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
  { id = "org.cloudfoundry.yarn-install" },
  { id = "io.projectriff.node" },
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
