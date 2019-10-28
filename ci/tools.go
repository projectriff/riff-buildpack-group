// +build tools

// This package imports things required by build scripts, to force `go mod` to see them as dependencies
package tools

import (
	_ "github.com/cloudfoundry/build-system-cnb/buildsystem"
	_ "github.com/cloudfoundry/node-engine-cnb/node"
	_ "github.com/cloudfoundry/npm-cnb/npm"
	_ "github.com/cloudfoundry/openjdk-cnb/jdk"
)
