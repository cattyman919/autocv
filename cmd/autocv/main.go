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
		cvData := domain.CVTypeData{
			General:  &cvCfg.generalCfg,
			Settings: &cvCfg.settingsCfg,
			CVType:   cvType,
		}

		wg.Go(func() {
			err := generator.GenerateCVType(&cvData, tmpl)
			if err != nil {
				slog.Error("Error generating CV Type", "err", err)
			}
			err = generator.GeneratePDF(&cvData)
			if err != nil {
				slog.Error("Error generating PDF CV Type", "err", err)
			}
		})

	}

	wg.Wait()
}
