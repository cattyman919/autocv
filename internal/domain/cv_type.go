package domain

type Layout string

const (
	LayoutExperiences  Layout = "experiences"
	LayoutEducations   Layout = "educations"
	LayoutSkills       Layout = "skills"
	LayoutCertificates Layout = "certificates"
	LayoutAwards       Layout = "awards"
)

type Experience struct {
	Role     string   `yaml:"role"`
	JobType  string   `yaml:"job_type"`
	Company  string   `yaml:"company"`
	Location string   `yaml:"location"`
	Dates    string   `yaml:"dates"`
	Points   []string `yaml:"points"`
}

type Project struct {
	Name         string   `yaml:"name"`
	Github       string   `yaml:"github"`
	GithubHandle string   `yaml:"github_handle"`
	Points       []string `yaml:"points"`
}

type CVType struct {
	Type        string
	Layouts     []Layout     `yaml:"layout"`
	Projects    []Project    `yaml:"projects"`
	Experiences []Experience `yaml:"experiences"`
}
