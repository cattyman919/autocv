package main

import (
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"strings"
	"sync"

	"github.com/cattyman919/autocv/internal/domain"
	yaml "github.com/goccy/go-yaml"
)

type CVConfig struct {
	settingsCfg domain.CVSettings
	generalCfg  domain.CVGeneral
	cvTypesCfg  []domain.CVType
}

func parseConfigs() (*CVConfig, error) {
	configPath := "config"
	dirCvTypes, err := os.ReadDir(filepath.Join(configPath, "types"))
	if err != nil {
		return nil, fmt.Errorf("Failed to read directory types: %w", err)
	}

	// General Config
	var generalCfg domain.CVGeneral

	// Settings Config
	var settingsCfg domain.CVSettings

	type ResultChan struct {
		err    error
		cvType domain.CVType
	}

	resultChan := make(chan ResultChan, len(dirCvTypes)+1)
	var wg sync.WaitGroup

	// Read General Cfg
	wg.Go(func() {
		generalCfgPath := filepath.Join(configPath, "general.yaml")
		generalCfgBytes, err := os.ReadFile(generalCfgPath)
		if err != nil {
			resultChan <- ResultChan{
				err: fmt.Errorf("Failed to open %s: %w", generalCfgPath, err),
			}
			return
		}

		if err := yaml.Unmarshal(generalCfgBytes, &generalCfg); err != nil {
			resultChan <- ResultChan{
				err: fmt.Errorf("Failed to parse %s: %w", generalCfgPath, err),
			}
			return
		}
	})

	// Read Settings Cfg
	wg.Go(func() {
		settingsCfgPath := filepath.Join(configPath, "settings.yaml")
		settingsCfgBytes, err := os.ReadFile(settingsCfgPath)
		if err != nil {
			resultChan <- ResultChan{
				err: fmt.Errorf("Failed to open %s: %w", settingsCfgPath, err),
			}
			return
		}

		if err := yaml.Unmarshal(settingsCfgBytes, &settingsCfg); err != nil {
			resultChan <- ResultChan{
				err: fmt.Errorf("Failed to parse %s: %w", settingsCfgPath, err),
			}
			return
		}
	})

	for _, cvType := range dirCvTypes {
		wg.Go(func() {
			if cvType.IsDir() {
				return
			}

			cvTypeFilePath := filepath.Join(configPath, "types", cvType.Name())
			cvTypeBytes, err := os.ReadFile(cvTypeFilePath)
			if err != nil {
				resultChan <- ResultChan{
					err: fmt.Errorf("Failed to open %s: %w", cvTypeFilePath, err),
				}
				return
			}

			cvTypeCfg := domain.CVType{
				Type: strings.TrimSuffix(cvType.Name(), ".yaml"),
			}

			if err := yaml.Unmarshal(cvTypeBytes, &cvTypeCfg); err != nil {
				resultChan <- ResultChan{
					err: fmt.Errorf("Failed to parse %s: %w", cvTypeFilePath, err),
				}
				return
			}

			resultChan <- ResultChan{
				cvType: cvTypeCfg,
			}

		})
	}

	go func() {
		wg.Wait()
		close(resultChan)
	}()

	cvTypesCfg := make([]domain.CVType, 0, len(dirCvTypes))
	for res := range resultChan {
		if res.err != nil {
			return nil, res.err
		}

		cvTypesCfg = append(cvTypesCfg, res.cvType)
	}

	slog.Debug("Parse Config Success")

	return &CVConfig{
		settingsCfg: settingsCfg,
		generalCfg:  generalCfg,
		cvTypesCfg:  cvTypesCfg,
	}, nil
}
