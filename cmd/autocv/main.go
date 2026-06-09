package main

import (
	"fmt"
	"log"
	"log/slog"
	"os"
	"os/exec"
	"sync"
	"time"

	"github.com/cattyman919/autocv/internal/domain"
	"github.com/cattyman919/autocv/internal/generator"
	"github.com/lmittmann/tint"
)

func initLogger() {
	w := os.Stdout

	slog.SetDefault(slog.New(
		tint.NewHandler(w, &tint.Options{
			Level:      slog.LevelDebug,
			TimeFormat: time.Kitchen,
		}),
	))
}

func main() {
	initLogger()

	if _, err := exec.LookPath("typst"); err != nil {
		slog.Error("Program `tyspt` compiler not found in $PATH")
		fmt.Println("")
		fmt.Println("Please install tyspt compiler first before running the program")
		fmt.Println("https://typst.app/open-source/")
		return
	}

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
