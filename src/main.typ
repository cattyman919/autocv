#import "/template/template.typ": *
#import "sections.typ"

#show: resume.with(
  author: "<< .General.PersonalInfo.Name >>",
  location: "<< .General.PersonalInfo.Location >>",
  email: "<< .General.PersonalInfo.Email >>",
  github: "<< .General.PersonalInfo.GithubHandle >>",
  linkedin: "<< .General.PersonalInfo.LinkedinHandle >>",
  phone: "<< .General.PersonalInfo.Phone >>",
  personal-site: "<< .General.PersonalInfo.Website >>",
  accent-color: "#26428b",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: center,
  personal-info-position: center,
)

// Dynamically render the document layout using Go's context
<<- range .Layouts >>
  <<- if eq . "experiences" >>
    #sections.experiences
  <<- else if eq . "educations" >>
    #sections.educations
  <<- else if eq . "projects" >>
    #sections.projects
  <<- else if eq . "skills" >>
    #sections.skills
  <<- else if eq . "certificates" >>
    #sections.certificates
  <<- else if eq . "awards" >>
    #sections.awards
  <<- else if eq . "research_interests" >>
    #sections.research-interests
  <<- end >>
<<- end >>
