#import "/template/template.typ"

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

#let headers = (
  "<< .General.PersonalInfo.Name >>",
  "<< .General.PersonalInfo.Location >>",
  "<< .General.PersonalInfo.Email >>",
  "<< .General.PersonalInfo.Phone >>",
  "<< .General.PersonalInfo.GithubHandle >>",
  "<< .General.PersonalInfo.LinkedinHandle >>",
  "<< .General.PersonalInfo.Website >>",
)

#let projects = [
  == Projects
  <<- range .Projects >>
  #template.project(
    title: "<< .Name >>",
    url: "<< .Github >>",
    url-handle: "<< .GithubHandle >>",
    points: (
      <<- range .Points >>
      [<< . >>],
      <<- end >>
    )
  )
  <<- end >>
]

#let experiences = [
  == Experience
  <<- range .Experiences >>
  #template.experience(
    company: "<< .Company >>",
    location: "<< .Location >>",
    role: "<< .Role >>",
    job-type: "<< .JobType >>",
    dates: "<< .Dates >>",
    points: (
      <<- range .Points >>
      [<< . >>],
      <<- end >>
    )
  )
  <<- end >>
]

#let certificates = [
  == Certificates
  <<- range .General.Certifications >>
  - (*<< .Year >>*) << .Name >>
  <<- end >>
]

#let awards = [
  == Awards
  <<- range .General.Awards >>
  - #template.award(
    title: "<< .Title >>",
    organization: "<< .Organization >>",
    date: "<< .Date >>",
    points: (
      <<- range .Points >>
      [<< . >>],
      <<- end >>
    )
  )
  <<- end >>
]

#let research-interests = [
  == Research Interests
  <<- range .General.ResearchInterests >>
  - [<< . >>]
  <<- end >>
]

#let skills = [
  == Skills
  <<- range .General.Skills >>
  - #template.skill(
    title: "<< .Title >>",
    items: (
      <<- range .Items >>
      "<< . >>",
      <<- end >>
    )
  )
  <<- end >>
]

#let educations = [
  == Educations
  <<- range .General.Educations >>
  #template.education(
    institution: "<< .Institution >>",
    degree: "<< .Degree >>",
    dates: "<< .Dates >>",
    details: (
      <<- range .Details >>
      [<< . >>],
      <<- end >>
    )
  )
  <<- end >>
]
