package cli

import (
	"bytes"
	"errors"
	"testing"

	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/stretchr/testify/assert"
)

func TestRun_Success(t *testing.T) {
	cli := &TerraforgeCli{
		logger: log.New(),
	}

	var out bytes.Buffer
	cli.logger.Out = &out

	cmd := &cobra.Command{
		Run: func(cmd *cobra.Command, args []string) {
			cmd.Println("Hello, Terraforge!")
		},
	}

	err := cli.Run(cmd)
	assert.NoError(t, err)
	assert.Contains(t, out.String(), "Hello, Terraforge!")
}

func TestRun_Failure(t *testing.T) {
	cli := &TerraforgeCli{
		logger: log.New(),
	}

	var out bytes.Buffer
	cli.logger.Out = &out

	cmd := &cobra.Command{
		RunE: func(cmd *cobra.Command, args []string) error {
			return errors.New("fatal error")
		},
	}

	assert.Panics(t, func() {
		err := cli.Run(cmd)
		if err != nil {
			t.Errorf("Expected no error, but got: %v", err)
		}
	})
}

func TestNewCli(t *testing.T) {
	cli := NewCli()
	assert.NotNil(t, cli)
	assert.Equal(t, "Terraforge", cli.Name)
	assert.NotNil(t, cli.logger)
}

func TestLogger(t *testing.T) {
	cli := NewCli()
	logger := cli.Logger()
	assert.NotNil(t, logger)
}
