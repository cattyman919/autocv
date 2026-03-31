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

func Write_CV(cvData *domain.CVData, tmpl *template.Template) error {

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

		log.Printf("Generated: %s\n", outputPath)
	}

	// err := write_PDF(&cvType, &cvData.General.PersonalInfo.Name)
	// if err != nil {
	// 	return fmt.Errorf("Failed to create CV [%s]: %w", cvType, err)
	// }
	return nil
}

// Runs the 'pdflatex' external command
func write_PDF(cvType *string, name *string) error {

	target_pdf := fmt.Sprintf("%s - CV (%s)", *name, *cvType)

	program := "pdflatex"
	args := []string{
		"-output-directory=../../../out",
		"-output-format=pdf",
		"-jobname",
		target_pdf,
		"main.tex",
	}

	cmd := exec.Command(program, args...)
	cmd.Dir = fmt.Sprintf("build_cv/%s/bw_cv", *cvType)

	// if DebugMode {
	// 	cmd.Stdout = os.Stdout
	// 	cmd.Stderr = os.Stderr
	// }

	log.Printf("Generating CV %s.pdf\n", target_pdf)

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("Failed to execute 'pdflatex': %w", err)
	}

	log.Printf("Generated CV %s.pdf\n", target_pdf)
	return nil
}
