/*
 * Copyright 2018 The original author or authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"github.com/BurntSushi/toml"
)

type testcases struct {
	Common    testcase   `toml:"common"`
	Testcases []testcase `toml:"testcases"`
}

type testcase struct {
	metadata
	Repo        string `toml:"repo"`
	Refspec     string `toml:"refspec"`
	SubPath     string `toml:"sub-path"`
	ContentType string `toml:"content-type"`
	Input       string `toml:"input"`
	Output      string `toml:"output"`
	SkipRebuild bool   `toml:"skip-rebuild"`
}

func (t testcase) merge(c testcase) testcase {
	t.metadata = t.metadata.merge(c.metadata)

	if t.Repo == "" {
		t.Repo = c.Repo
	}
	if t.Refspec == "" {
		t.Refspec = c.Refspec
	}
	if t.SubPath == "" {
		t.SubPath = c.SubPath
	}
	if t.ContentType == "" {
		t.ContentType = c.ContentType
	}
	if t.Input == "" {
		t.Input = c.Input
	}
	if t.Output == "" {
		t.Output = c.Output
	}

	return t
}

type metadata struct {
	Artifact string `toml:"artifact"`
	Handler  string `toml:"handler"`
	Override string `toml:"override"`
}

func (m metadata) merge(c metadata) metadata {
	if m.Artifact == "" {
		m.Artifact = c.Artifact
	}
	if m.Handler == "" {
		m.Handler = c.Handler
	}
	if m.Override == "" {
		m.Override = c.Override
	}

	return m
}

func main() {
	rand.Seed(time.Now().UnixNano())

	tests := testcases{}
	_, err := toml.DecodeFile("tests.toml", &tests)
	if err != nil {
		log.Fatalf("could not read tests.toml file: %v", err)
	}

	for _, t := range tests.Testcases {
		t = t.merge(tests.Common)
		appdir, err := ioutil.TempDir("", "riff-buildpack-group-")
		if err != nil {
			log.Fatalf("could not create temp dir: %v", err)
		} else {
			defer func() { _ = os.RemoveAll(appdir) }()
		}
		fndir := filepath.Join(appdir, t.SubPath)

		cloneRepo(t, appdir)

		lastSlash := strings.LastIndex(t.Repo, "/")
		fnImg := fmt.Sprintf("builder-tests/%s-%d", t.Repo[lastSlash+1:], rand.Int31n(10000))

		createFunctionImg(t.metadata, fnImg, fndir)

		localPort, docker := startServer(fnImg)

		invokeFunction(t, localPort)

		stopFunctionContainer(docker)

		if !t.SkipRebuild {
			// Re-create function, should use cache
			createFunctionImg(t.metadata, fnImg, fndir)
			localPort2, docker := startServer(fnImg)
			invokeFunction(t, localPort2)
			stopFunctionContainer(docker)
		}

		deleteImage(fnImg)

	}
}

func deleteImage(fnImg string) {
	if err := runCmd("docker", "rmi", "--force", fnImg); err != nil {
		log.Fatalf("could not remove image %q: %v", fnImg, err)
	}
}

func invokeFunction(t testcase, localPort int32) {
	if resp, err := http.Post(fmt.Sprintf("http://localhost:%d", localPort), t.ContentType, strings.NewReader(t.Input)); err != nil {
		log.Fatalf("could not post to function: %v", err)
	} else {
		if result, err := ioutil.ReadAll(resp.Body); err != nil {
			log.Fatalf("could not read response from function: %v", err)
		} else if string(result) != t.Output {
			log.Fatalf("unexpected result from function: %q != %q", string(result), t.Output)
		}
	}
}

func stopFunctionContainer(docker *exec.Cmd) {
	if err := docker.Process.Signal(syscall.SIGINT); err != nil {
		log.Fatalf("could not kill app: %v", err)
	}
}

func startServer(fnImg string) (int32, *exec.Cmd) {
	localPort := 1024 + rand.Int31n(65535-1024)
	var docker *exec.Cmd
	docker, err := startCmd("docker", "run", "-p", fmt.Sprintf("%d:8080", localPort), fnImg)
	if err != nil {
		log.Fatalf("could not run built function: %v", err)
	}
	addr := fmt.Sprintf("http://localhost:%d", localPort)

	until := time.Now().Add(20 * time.Second)
	for ; time.Now().Before(until); time.Sleep(1 * time.Second) {
		_, err := http.Get(addr)
		if err == nil {
			break
		}
		fmt.Printf("Could not connect to %s, retrying...\n", addr)
	}

	return localPort, docker
}

func createFunctionImg(m metadata, fnImg string, appdir string) {
	err := runCmd("pack", "build", "--no-pull",
		"--builder", "projectriff/builder",
		"--path", appdir,
		"--env", fmt.Sprintf("%s=%s", "RIFF", "true"),
		"--env", fmt.Sprintf("%s=%s", "RIFF_ARTIFACT", m.Artifact),
		"--env", fmt.Sprintf("%s=%s", "RIFF_HANDLER", m.Handler),
		"--env", fmt.Sprintf("%s=%s", "RIFF_OVERRIDE", m.Override),
		fnImg)
	if err != nil {
		log.Fatalf("could not build: %v", err)
	}
}

func cloneRepo(t testcase, appdir string) {
	if err := runCmd("git", "clone", t.Repo, appdir); err != nil {
		log.Fatalf("could not clone into %q: %v", appdir, err)
	}
	if t.Refspec != "" {
		dir, _ := os.Getwd()
		defer os.Chdir(dir)
		os.Chdir(appdir)
		if err := runCmd("git", "checkout", t.Refspec); err != nil {
			log.Fatalf("could not checkout %q: %v", t.Refspec, err)
		}
	}
}

func runCmd(c string, s ...string) error {
	if cmd, err := startCmd(c, s...); err != nil {
		return err
	} else {
		return cmd.Wait()
	}
}
func startCmd(c string, s ...string) (*exec.Cmd, error) {
	fmt.Printf("RUNNING %s %s\n", c, strings.Join(s, " "))
	command := exec.Command(c, s...)
	command.Stderr = os.Stderr
	command.Stdout = os.Stdout
	return command, command.Start()
}
