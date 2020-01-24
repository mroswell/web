// +build mage

package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

type textData struct {
	Old string `json:"old"`
	New string `json:"new"`
}

type errorsModels struct {
	Type     string     `json:"type"`
	FilePath string     `json:"file_path"`
	Errors   []textData `json:"errors"`
}

func FixText() {
	err := fixText()
	if err != nil {
		log.Fatal("Could not append i18n ", err)
	}
	fmt.Println("Text Fixed successfully!")
}

func fixText() error {
	file, err := os.Open("fix_text.json")
	defer file.Close()

	if err != nil {
		return err
	}
	errorsM := []errorsModels{}
	err = json.NewDecoder(file).Decode(&errorsM)
	if err != nil {
		return err
	}
	for _, m := range errorsM {

		data, err := ioutil.ReadFile(m.FilePath)
		if err != nil {
			return err
		}
		for _, e := range m.Errors {
			out := strings.ReplaceAll(string(data), e.Old, e.New)

			f, err := os.OpenFile(m.FilePath, os.O_WRONLY|os.O_CREATE, 0700)
			if err != nil {
				return err
			}

			_, err = f.WriteString(out)
			if err != nil {
				return err
			}
			f.Close()
		}
	}
	return nil
}
