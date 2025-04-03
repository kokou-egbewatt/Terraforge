package cli

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNewFileWriter(t *testing.T) {
	homeDir, _ := os.UserHomeDir()
	tempFile, err := os.CreateTemp(homeDir, "testfile")
	assert.NoError(t, err)
	defer os.Remove(tempFile.Name())

	fw := NewFileWriter(tempFile)
	assert.NotNil(t, fw)
}

func TestCreateAppStructure(t *testing.T) {
	tempDir := t.TempDir()
	dirs := []string{"/config", "/logs"}
	success, err := CreateAppStructure(tempDir, dirs)
	assert.True(t, success)
	assert.NoError(t, err)

	for _, dir := range dirs {
		_, err := os.Stat(tempDir + dir)
		assert.NoError(t, err)
	}
}

func TestIsEmptyDir(t *testing.T) {
	homeDir, _ := os.UserHomeDir()
	tempDir := homeDir + "/temp"

	dirInfo, err := IsEmptyDir(tempDir)
	assert.NoError(t, err)
	assert.NotNil(t, dirInfo)

	defer os.Remove(tempDir)
}
