buildpacks = [
  { id = "io.projectriff.command",       uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-$(curl -s https://storage.googleapis.com/projectriff/command-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.java",          uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-$(curl -s https://storage.googleapis.com/projectriff/java-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.node",          uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-$(curl -s https://storage.googleapis.com/projectriff/node-function-buildpack/versions/snapshots/master).tgz" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-1.0.40.tgz" },
  { id = "org.cloudfoundry.node-engine", uri = "https://buildpacks.cloudfoundry.org/dependencies/org.cloudfoundry.node-engine/org.cloudfoundry.node-engine-0.0.56-any-stack-a47881f8.tgz" },
  { id = "org.cloudfoundry.npm",         uri = "https://buildpacks.cloudfoundry.org/dependencies/org.cloudfoundry.npm/org.cloudfoundry.npm-0.0.33-any-stack-07c7a3d5.tgz" },
  { id = "org.cloudfoundry.openjdk",     uri = "https://storage.googleapis.com/cnb-buildpacks/openjdk-cnb/org.cloudfoundry.openjdk-1.0.19.tgz" },
  { id = "org.cloudfoundry.yarn",        uri = "https://buildpacks.cloudfoundry.org/dependencies/org.cloudfoundry.yarn/org.cloudfoundry.yarn-0.0.33-any-stack-de797152.tgz" },
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
  { id = "org.cloudfoundry.yarn" },
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
