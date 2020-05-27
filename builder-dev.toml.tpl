buildpacks = [
  { id = "io.projectriff.command", uri = "../command-function-buildpack/artifactory/io/projectriff/command/io.projectriff.command/latest" },
  { id = "io.projectriff.java", uri = "../java-function-buildpack/artifactory/io/projectriff/java/io.projectriff.java/latest" },
  { id = "io.projectriff.node", uri = "../node-function-buildpack/artifactory/io/projectriff/node/io.projectriff.node/latest" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-{{ go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/build-system-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/node-engine", uri = "https://github.com/paketo-buildpacks/node-engine/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/node-engine").Version' }}/node-engine-{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/node-engine").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/yarn-install", uri = "https://github.com/paketo-buildpacks/yarn-install/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/yarn-install").Version' }}/yarn-install-{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/yarn-install").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/npm", uri = "https://github.com/paketo-buildpacks/npm/releases/download/{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/npm").Version' }}/npm-{{ go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/npm").Version' | sed -e 's/^v//g' }}.tgz" },
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
version = "{{ go mod download -json | jq -r 'select(.Path == "github.com/buildpacks/lifecycle").Version' | sed -e 's/^v//g' }}"

[stack]
id          = "io.buildpacks.stacks.bionic"
build-image = "gcr.io/paketo-buildpacks/build:base-cnb"
run-image   = "gcr.io/paketo-buildpacks/run:base-cnb"
