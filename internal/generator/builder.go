package generator

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"text/template"

	"github.com/cattyman919/autocv/internal/domain"
	"github.com/cattyman919/autocv/internal/utils"
)

const (
	FOLDER_PERMISSION = 0755
)

func GenerateCVType(cvData *domain.CVTypeData, tmpl *template.Template) error {

	log.Printf("Generating CV (%s)\n", cvData.Type)

	cvTemplatePath := filepath.Join("src")
	cvOutputPath := filepath.Join("build_cv", cvData.Type)

	utils.CopyDir(cvTemplatePath, cvOutputPath)

	templates := []string{
		"main.typ",
		"sections.typ",
	}

	for _, templateName := range templates {
		outputPath := filepath.Join(cvOutputPath, templateName)
		dirOutputPath := filepath.Dir(outputPath)
		err := os.MkdirAll(dirOutputPath, FOLDER_PERMISSION)
		if err != nil {
			log.Printf("Error creating Directory %s: %v\n", dirOutputPath, err)
			continue
		}

		file, err := os.Create(outputPath)
		if err != nil {
			log.Printf("Error creating file %s: %v", outputPath, err)
			continue
		}

		// We use ExecuteTemplate, passing the base name.
		err = tmpl.ExecuteTemplate(file, templateName, cvData)
		if err != nil {
			log.Printf("Error executing template %s: %v", templateName, err)
			file.Close()
			continue
		}

		file.Close()
	}

	return nil
}

func GeneratePDF(cvData *domain.CVTypeData) error {

	targetPDF := fmt.Sprintf("%s - CV (%s).pdf", cvData.General.PersonalInfo.Name, cvData.Type)

	cvPath := filepath.Join("build_cv", cvData.Type, "main.typ")
	outputPath := filepath.Join("out", targetPDF)

	program := "typst"
	args := []string{
		"compile",
		cvPath,
		"--root",
		".",
		outputPath,
	}

	cmd := exec.Command(program, args...)

	// DEBUG
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("Failed to execute '%s': %w", program, err)
	}

	log.Printf("Generated CV %s.pdf\n", targetPDF)

	return nil
}
