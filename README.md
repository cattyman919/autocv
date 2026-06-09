# AutoCV

AutoCV is a Go-based CLI tool that generates multiple tailored, professional CVs from a single YAML data source using [Typst](https://typst.app/) for modern, fast typesetting. It streamlines the process of creating and maintaining job-application-specific resumes by letting you define shared personal data once and customize experiences, projects, and layout per role.

---

## Key Features

- **Single Source of Truth** — Manage all shared CV data in `config/general.yaml` (personal info, education, skills, certifications, awards). Role-specific overrides live in `config/types/*.yaml`.
- **Dynamic CV Versions** — Generate different CV variants (e.g., `main`, `fullstack`, `devops`, `rust`, `cyber`, `iot`) by defining per-type layouts, experiences, and projects.
- **Concurrent Builds** — Uses Go's `sync.WaitGroup` to compile multiple CVs in parallel, cutting generation time significantly.
- **Typst Templating** — Leverages Go's `text/template` with custom delimiters (`<<`, `>>`) to produce clean, maintainable Typst source files. Supports bold text escaping (`**text**` → `\textbf{text}`).
- **PDF Validation** — Optionally warn when a generated PDF exceeds a defined page limit (`max_pages`).
- **Dockerized Environment** — Multi-stage Dockerfile for consistent, reproducible builds without a local Typst installation.
- **CI/CD Ready** — GitHub Actions workflow included for automated upload to Azure Blob Storage and GitHub Releases on version tags.

---

## Project Structure

```
.
├── cmd/autocv/           # Application entrypoint & config parsing
│   ├── main.go           # Orchestrates concurrent CV generation
│   └── config.go         # Parses general, settings, and type YAMLs
├── internal/
│   ├── domain/           # Data models (CVTypeData, CVGeneral, CVType, etc.)
│   ├── generator/        # Template execution, Typst generation, PDF compilation
│   └── utils/            # File/directory copy helpers
├── config/
│   ├── general.yaml      # Shared personal data, education, skills, awards
│   ├── settings.yaml     # Global font & accent color
│   └── types/            # Per-CV-type definitions (layout, experiences, projects)
├── src/                  # Go text/template source files (main.typ, sections.typ)
├── template/
│   ├── template.typ      # Reusable Typst resume components & styling
│   └── location.svg      # Location icon asset
├── build_cv/             # Generated per-type Typst files (gitignored)
├── out/                  # Final PDF outputs (gitignored)
├── images/               # Profile picture and other assets
├── Dockerfile            # Multi-stage builder + Typst runtime image
├── Makefile              # Convenience commands
└── go.mod / go.sum       # Go module dependencies
```

---

## Prerequisites

- [Go](https://golang.org/dl/) 1.26+
- [Typst](https://github.com/typst/typst/releases) CLI installed and available in `$PATH`
- [Make](https://www.gnu.org/software/make/) (optional, for convenience)
- [Docker](https://www.docker.com/get-started) (optional, for containerized builds)

---

## Getting Started

### Local Build

1. **Clone the repository**

   ```bash
   git clone https://github.com/cattyman919/autocv.git
   cd autocv
   ```

2. **Install Go dependencies**

   ```bash
   go mod tidy
   ```

3. **Customize your CV data**

   - Edit `config/general.yaml` for shared personal information, education, skills, certifications, and awards.
   - Edit `config/settings.yaml` to change the global font and accent color.
   - Add or edit files in `config/types/` to define role-specific layouts, descriptions, experiences, and projects.

4. **Generate CVs**

   ```bash
   make all   # or: go run ./cmd/autocv/
   ```

   Generated PDFs will appear in the `out/` directory.

### Docker Build

If you prefer not to install Typst locally:

```bash
# Build the Docker image and run the generator
docker build -t autocv .
docker run --rm -v "$(pwd)/out:/app/out" autocv
```

The `out/` directory will contain the compiled PDFs.

---

## Customization Guide

### Adding a New CV Type

1. Create a new YAML file in `config/types/`, e.g., `config/types/data-science.yaml`:

   ```yaml
   max_pages: 1
   layout:
     - description
     - educations
     - experiences
     - skills
     - projects
   description: "Data Science focused CV"
   experiences:
     - company: Example Corp
       location: Remote
       role: Data Scientist
       dates: Jan 2024 - Present
       job_type: Full-time
       points:
         - "Built predictive models using Python and scikit-learn"
   projects:
     - name: My ML Project
       github: https://github.com/username/project
       github_handle: username/project
       points:
         - "End-to-end pipeline for sentiment analysis"
   ```

2. Run `make all`. A new PDF will be generated automatically.

### Modifying Styling

- Edit `template/template.typ` to change global typography, colors, spacing, and resume components.
- Edit `src/main.typ` or `src/sections.typ` to adjust the Go template logic that injects data into Typst.
- Change `config/settings.yaml` to switch fonts or accent colors without touching code.

### Extending the Data Model

1. Add new fields to the relevant structs in `internal/domain/`.
2. Update the YAML parsing logic in `cmd/autocv/config.go` if needed.
3. Reference the new data in `src/sections.typ` using Go template syntax.

---

## Dependencies

| Package | Purpose |
|---------|---------|
| [`github.com/goccy/go-yaml`](https://github.com/goccy/go-yaml) | Fast YAML parsing |
| [`github.com/fatih/color`](https://github.com/fatih/color) | Terminal color output |
| [`github.com/ledongthuc/pdf`](https://github.com/ledongthuc/pdf) | PDF page count validation |
| [`github.com/lmittmann/tint`](https://github.com/lmittmann/tint) | Structured, tinted logging for `slog` |
| [`@preview/fontawesome:0.5.0`](https://typst.app/universe/package/fontawesome) | FontAwesome icons in Typst |

---

## CI / CD

The included GitHub Actions workflow (`.github/workflows/deploy.yaml`) triggers on version tags (`v*`):

1. **Checkout** — Pulls the repository.
2. **Artifact Upload** — Stores the `out/` directory as a build artifact.
3. **Azure Upload** — Pushes selected PDFs to Azure Blob Storage.
4. **GitHub Release** — Creates a release, removes auto-generated source archives, and uploads all PDFs as release assets.

> **Note:** Ensure `secrets.AZURE_TOKEN` is configured in your repository settings for Azure uploads.

---

## License

This project is open source. Feel free to fork and adapt it for your own resume needs.

---

## Acknowledgments

- Built with [Typst](https://typst.app/) for modern, programmable typesetting.
- Inspired by the need to maintain multiple job-targeted CVs without duplicating content.
