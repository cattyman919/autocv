package main

import (
	"fmt"
	"log/slog"
)

func main() {
	cvCfg, err := parseConfigs()
	if err != nil {
		slog.Error("Error Parsing Config", "Err", err)
	}

	fmt.Println(cvCfg.generalCfg)
}
