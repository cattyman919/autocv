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

// #let certificates = [
//   == Certificates
//   <<- range .General.Certifications >>
//   - (*<< .Year >>*) << .Name >>
//   <<- end >>
//
// ]

#let certificates = [
  == Certificates

  #set text(size: 0.9em)
  // #set text(size: 1.0em)

  #grid(
    columns: (1fr, 1fr), // Creates two equal-width columns
    row-gutter: 0.75em,  // Space between rows
    column-gutter: 1em,  // Space between columns
    <<- range .General.Certifications >>
    [- (*<< .Year >>*) << .Name >>],
    <<- end >>
  )
]

// #let certificates = [
//   == Certificates
//
//   // Turn off justification just for this block
//   #set par(justify: false)
//
//   #(
//     <<- range .General.Certifications >>
//     [(*<< .Year >>*) << .Name >>],
//     <<- end >>
//   ).join([ #h(0.4em) | #h(0.4em) ]) // Using a clean vertical bar instead of a heavy bullet
// ]

// #let certificates = [
//   == Certificates
//   #(
//     <<- range .General.Certifications >>
//     [(*<< .Year >>*) << .Name >>],
//     <<- end >>
//   ).join([ #h(0.5em) $bullet$ #h(0.5em) ])
// ]

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
  - << . >>
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
