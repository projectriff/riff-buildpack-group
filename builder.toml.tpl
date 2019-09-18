buildpacks = [
  { id = "io.projectriff.java",          uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-$(curl -s https://storage.googleapis.com/projectriff/java-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.node",          uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-$(curl -s https://storage.googleapis.com/projectriff/node-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.command",       uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-$(curl -s https://storage.googleapis.com/projectriff/command-function-buildpack/versions/snapshots/master).tgz" },
  { id = "org.cloudfoundry.openjdk",     uri = "https://repo.spring.io/libs-milestone-local/org/cloudfoundry/openjdk/org.cloudfoundry.openjdk/1.0.0-M9/org.cloudfoundry.openjdk-1.0.0-M9.tgz" },
  { id = "org.cloudfoundry.buildsystem", uri = "https://repo.spring.io/libs-milestone-local/org/cloudfoundry/buildsystem/org.cloudfoundry.buildsystem/1.0.0-M9/org.cloudfoundry.buildsystem-1.0.0-M9.tgz" },
  { id = "org.cloudfoundry.node-engine", uri = "https://github.com/cloudfoundry/node-engine-cnb/releases/download/v0.0.16/node-engine-cnb-0.0.16.tgz" },
  { id = "org.cloudfoundry.npm",         uri = "https://github.com/cloudfoundry/npm-cnb/releases/download/v0.0.12/npm-cnb-0.0.12.tgz" },
]

[[order]]
  # java functions
  group = [
    { id = "org.cloudfoundry.openjdk",     optional = true },
    { id = "org.cloudfoundry.buildsystem", optional = true },
    { id = "io.projectriff.java" },
  ]

[[order]]
  # node functions
  group = [
    { id = "org.cloudfoundry.node-engine", optional = true },
    { id = "org.cloudfoundry.npm",         optional = true },
    { id = "io.projectriff.node" },
  ]

[[order]]
  # command functions
  group = [
    { id = "io.projectriff.command" },
  ]

[lifecycle]
  version = "0.4.0"

[stack]
  id = "io.buildpacks.stacks.bionic"
  build-image = "cnbs/build"
  run-image = "cnbs/run"
