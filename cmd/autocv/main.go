package main

import (
	"log"
	"log/slog"
	"sync"

	"github.com/cattyman919/autocv/internal/domain"
	"github.com/cattyman919/autocv/internal/generator"
)

func main() {
	cvCfg, err := parseConfigs()
	if err != nil {
		slog.Error("Error Parsing Config", "Err", err)
	}

	tmpl, err := generator.NewTemplate()
	if err != nil {
		log.Fatalln(err)
	}

	var wg sync.WaitGroup

	for _, cvType := range cvCfg.cvTypesCfg {
		cvData := domain.CVData{
			General: &cvCfg.generalCfg,
			CVType:  cvType,
		}

		wg.Go(func() {
			generator.Write_CV(&cvData, tmpl)
		})

	}

	wg.Wait()
}
