package utils

import (
	"fmt"
	"log"
	"os/exec"
	"strings"

	"github.com/Masterminds/semver/v3"

)

const Name = "TerraForge"

var (
	version *semver.Version
	execCommand = exec.Command
)

func init() {
	if version == nil {
		_version, err := getVersionFromGit()
		if err != nil {
			log.Printf("Failed to get version from git tags")
			version, _ = semver.NewVersion("v0.0.0-dev")
		} else {
			version, _ = semver.NewVersion(_version)
		}
	}
	log.Printf("version: %s ", version)
}

// Retrieve the version from the latest git tag
func getVersionFromGit() (string, error) {
	cmd := execCommand("git", "tag", "--list='v*.*.*'")
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}

	version := strings.TrimSpace(string(output))
	return version, nil
}

func FullVersion() string {
	return fmt.Sprintf("%s Version %s", Name, version)
}

func Version() string {
	return version.String()
}