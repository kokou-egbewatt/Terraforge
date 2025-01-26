package utils

import (
	"os/exec"
	"testing"

	"github.com/Masterminds/semver/v3"
	"github.com/stretchr/testify/assert"
)

// Mock exec.Command
func mockExecCommandVersion(command string, args ...string) *exec.Cmd {
	return exec.Command("echo", "v1.2.3")
}

func mockExecCommandError(command string, args ...string) *exec.Cmd {
	return exec.Command("false")
}

func TestGetVersionFromGit_Success(t *testing.T) {
	// Mock execCommand
	execCommand = mockExecCommandVersion

	// Call the function
	version, err := getVersionFromGit()

	// Assertions
	assert.NoError(t, err)
	assert.Equal(t, "v1.2.3", version)
}

func TestGetVersionFromGit_Failure(t *testing.T) {
	// Mock execCommand to simulate failure
	execCommand = mockExecCommandError

	// Call the function
	version, err := getVersionFromGit()

	// Assertions
	assert.Error(t, err)
	assert.Equal(t, "", version)
}

func TestFullVersion(t *testing.T) {
	// Mock version
	version, _ = semver.NewVersion("1.2.3")

	// Call the function
	fullVersion := FullVersion()

	// Assertions
	assert.Equal(t, "TerraForge Version 1.2.3", fullVersion)
}

func TestVersion(t *testing.T) {
	// Mock version
	version, _ = semver.NewVersion("1.2.3")

	// Call the function
	shortVersion := Version()

	// Assertions
	assert.Equal(t, "1.2.3", shortVersion)
}
