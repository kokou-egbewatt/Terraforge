package cli

import (
	"fmt"
	"io/fs"
	"os"
)

func HandleError(err error) {

}

type FileWriter struct {
	file *os.File
}

// Create New file writer
func NewFileWriter(file *os.File) *FileWriter {
	return &FileWriter{
		file: file,
	}
}

// Write implements the io.Writer interface
func (fw *FileWriter) Write(p []byte) (n int, err error) {
	return fw.file.Write(p)
}

func CreateAppStructure(appName string, dirs []string) (bool, error) {
	for _, dir := range dirs {
		err := os.MkdirAll(appName+dir, 0755)
		if err != nil {
			return false, err
		}
	}
	return true, nil
}

// Check if Directory is Empty
// Returns (Empty Directory, Error)
func IsEmptyDir(name string) (os.FileInfo, error) {
	var (
		directory fs.FileInfo
		err       error
	)

	if directory, err = os.Stat(name); os.IsNotExist(err) {
		err = os.Mkdir(name, 0755) // create new directory
		if err != nil {
			return nil, fmt.Errorf("%s directory can not be created", name)
		}
		directory, _ = os.Stat(name)
	}

	// Check if it is a directory
	if !directory.IsDir() {
		return nil, fmt.Errorf("%s is not a directory", name)
	}

	// Read the directory contents
	contents, _ := os.ReadDir(directory.Name())

	// Check if the directory is empty
	if len(contents) == 0 {
		return directory, nil
	}
	return nil, fmt.Errorf("%s is not empty", name)
}
