package cli

import (
	"os"
	"path"

	"github.com/sirupsen/logrus"
	"gopkg.in/yaml.v3"
)

type TerraforgeConfig struct {
	LogLevel string `yaml:"log-level"`
	LogFile  string `yaml:"log-file"`
}

type Config struct {
	terraforgeConfig TerraforgeConfig `yaml:"terraforge_config"`
}

func InitializeConfig(logger *logrus.Logger, configDir string, configFile string) (err error) {

	// Create the directory if it doesn't exist
	configPath := configDir
	err = os.MkdirAll(configPath, os.ModePerm)
	if err != nil {
		logger.Fatalln("Error creating directory:", err)
	}

	// create default config
	terraforgeConfig := TerraforgeConfig{
		LogLevel: "info",
		LogFile:  configPath + "/terraforge.log",
	}
	config := Config{
		terraforgeConfig: terraforgeConfig,
	}

	// Marshal the configuration to YAML
	configYAML, err := yaml.Marshal(&config)
	if err != nil {
		logger.Fatalln("Error marshaling configuration to YAML:", err)
	}

	// Write the YAML to the config file
	err = os.WriteFile(configPath+configFile, configYAML, 0600)
	if err != nil {
		logger.Fatalln("Error writing configuration to file:", err)
	}

	// create default log file
	err = os.WriteFile(terraforgeConfig.LogFile, []byte{}, 0666)
	if err != nil {
		logger.Fatalln("Error creating default log file:", err)
	}

	return nil
}

func SetupConfig(logger *logrus.Logger, configName string) (configDir string) {
	// Check config in home
	homeDir, _ := os.UserHomeDir()
	configDir = path.Join(homeDir, ".terraforge")
	configFilePath := path.Join(configDir, "/", configName)
	if _, err := os.Stat(configFilePath); os.IsNotExist(err) {
		// Initialize default config
		logger.Info("Creating new config at ", configFilePath)
		err := InitializeConfig(logger, configDir, configName)
		if err != nil {
			logger.Error(err)
		}
	} else if err != nil {
		logger.Panic(err)
	}
	return
}
