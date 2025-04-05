package cli

import (
	"os"
	"testing"

	"github.com/sirupsen/logrus"
	"github.com/stretchr/testify/assert"
)

func TestInitializeConfig(t *testing.T) {
	logger := logrus.New()
	tempDir := t.TempDir()
	configFile := "/config.yaml"

	err := InitializeConfig(logger, tempDir, configFile)
	assert.NoError(t, err)

	// Check if the config file is created
	_, err = os.Stat(tempDir + configFile)
	assert.NoError(t, err)

	// Check if the log file is created
	logFilePath := tempDir + "/terraforge.log"
	_, err = os.Stat(logFilePath)
	assert.NoError(t, err)
}

func TestSetupConfig(t *testing.T) {
	logger := logrus.New()
	configName := "/config.yaml"

	configDir := SetupConfig(logger, configName)
	assert.NotEmpty(t, configDir)
	_, err := os.Stat(configDir + configName)
	assert.NoError(t, err)
}
