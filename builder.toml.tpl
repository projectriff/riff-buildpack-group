buildpacks = [
  { id = "io.projectriff.streaming-http-adapter",           latest = true, uri = "https://storage.googleapis.com/projectriff/streaming-http-adapter-buildpack/io.projectriff.streaming-http-adapter-$(curl -s https://storage.googleapis.com/projectriff/streaming-http-adapter-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.java",                             latest = true, uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-$(curl -s https://storage.googleapis.com/projectriff/java-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.node",                             latest = true, uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-$(curl -s https://storage.googleapis.com/projectriff/node-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.command",                          latest = true, uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-$(curl -s https://storage.googleapis.com/projectriff/command-function-buildpack/versions/snapshots/master).tgz" },
  { id = "org.cloudfoundry.openjdk",                        latest = true, uri = "https://repo.spring.io/libs-milestone-local/org/cloudfoundry/openjdk/org.cloudfoundry.openjdk/1.0.0-M9/org.cloudfoundry.openjdk-1.0.0-M9.tgz" },
  { id = "org.cloudfoundry.buildsystem",                    latest = true, uri = "https://repo.spring.io/libs-milestone-local/org/cloudfoundry/buildsystem/org.cloudfoundry.buildsystem/1.0.0-M9/org.cloudfoundry.buildsystem-1.0.0-M9.tgz" },
  { id = "org.cloudfoundry.node-engine",                    latest = true, uri = "https://github.com/cloudfoundry/node-engine-cnb/releases/download/v0.0.16/node-engine-cnb-0.0.16.tgz" },
  { id = "org.cloudfoundry.npm",                            latest = true, uri = "https://github.com/cloudfoundry/npm-cnb/releases/download/v0.0.12/npm-cnb-0.0.12.tgz" },
]

[[groups]]
  # java functions
  buildpacks = [
    { id = "org.cloudfoundry.openjdk",              version = "latest", optional = true },
    { id = "org.cloudfoundry.buildsystem",          version = "latest", optional = true },
    { id = "io.projectriff.streaming-http-adapter", version = 'latest', optional = true },
    { id = "io.projectriff.java",                   version = "latest" },
  ]

[[groups]]
  # node functions
  buildpacks = [
    { id = "org.cloudfoundry.node-engine",          version = "latest", optional = true },
    { id = "org.cloudfoundry.npm",                  version = "latest", optional = true },
    { id = "io.projectriff.streaming-http-adapter", version = 'latest', optional = true },
    { id = "io.projectriff.node",                   version = "latest" },
  ]

[[groups]]
  # command functions
  buildpacks = [
    { id = "io.projectriff.command", version = "latest" },
  ]

[stack]
  id = "io.buildpacks.stacks.bionic"
  build-image = "cnbs/build"
  run-image = "cnbs/run"
