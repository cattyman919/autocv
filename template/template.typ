#import "@preview/fontawesome:0.5.0": *

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  linkedin_handle: "",
  phone: "",
  personal-site: "",
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "us-letter",
  heading-section-font-size: 14pt,
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
  body,
) = {

  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    lang: lang,
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    margin: (0.5in),
    paper: paper,
  )

  // Link styles
  // show link: underline


  // Small caps for section titles
  show heading.where(level: 2): it => [
    #set text(
      weight: 900,
      size: heading-section-font-size,
    )
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  // Disable Blue link
  // show link: set text(
  //   fill: rgb(accent-color),
  // )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 900,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #(author)]

  // Personal Info Helper
  let contact-item(value, prefix: "", link-type: "", handle: "") = {
    if value == "" { return none }

    // Determine what text to actually display
    let display-text = if handle != "" { handle } else { value }

    // Create the content with the icon prefix
    let content = if prefix != "" {
      prefix + "  " + display-text
    } else {
      display-text
    }

    // Return as a link or plain content
    if link-type != "" {
      return link(link-type + value)[#content]
    } else {
      return content
    }
  }

  let icon(path) = [#box(baseline: 20%, image(path, height: 1em))#h(-0.4em)]

  // Personal Info
  pad(
    top: 0.25em,
    align(personal-info-position)[
      #{
        let items = (
          contact-item(phone, prefix: fa-phone()),
          contact-item(location, prefix: icon("location.svg")),
          contact-item(email, prefix: fa-envelope(), link-type: "mailto:"),
          contact-item(github, prefix: fa-github(), link-type: "https://github.com/"),
          contact-item(linkedin, prefix: fa-linkedin(),  link-type: "https://www.linkedin.com/in/", handle: linkedin_handle),
          contact-item(personal-site, prefix:fa-link(), link-type: "https://"),
        )
        items.filter(x => x != none).join("  |  ")
      }
    ],
  )

  // Main body.
  set par(justify: true)

  body
}

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

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature becuase ligatures are disabled for good reasons
#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  start-date + " " + $dash.em$ + " " + end-date
}

// Section components below
#let edu(
  institution: "",
  dates: "",
  degree: "",
  gpa: "",
  location: "",
  // Makes dates on upper right like rest of components
  consistent: false,
) = {
  if consistent {
    // edu-constant style (dates top-right, location bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: dates,
      bottom-left: emph(degree),
      bottom-right: emph(location),
    )
  } else {
    // original edu style (location top-right, dates bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: location,
      bottom-left: emph(degree),
      bottom-right: emph(dates),
    )
  }
}

#let award(
  title: "",
  organization: "",
  date: "",
  points: ()
) = {
  generic-two-by-two(
    top-left: strong(title),
    top-right: date,
    bottom-left: organization
  )
  for point in points [
    - #point
  ]
}



#let experience-title-helper(role, job-type) = {
  strong(role) + " " + $dash.em$ + " " + strong(text(fill: luma(50%))[#job-type])
}


#let experience(
  company: "",
  location: "",
  role: "",
  job-type: "",
  dates: "",
  points: ()
) = [
  #generic-two-by-two(
    top-left: experience-title-helper(role, job-type),
    top-right: dates,
    bottom-left: strong(emph(company)),
    bottom-right: location
  )
  #for point in points [
    - #point
  ]
]

#let project(
  title: "",
  description:"",
  url: "",
  url-handle:"",
  points: ()
) = [
  #generic-one-by-two(
    left: strong(title),
    right: if url != "" {
      link(url)[#fa-external-link() #h(3pt) #url-handle]
    } else {
      url-handle
    }
  )
  #description
  #for point in points [
    - #point
  ]
]



#let education(
  institution: "",
  dates: "",
  degree: "",
  details: (),
) = [
  #generic-two-by-two(
    top-left: strong(institution),
    top-right: dates,
    bottom-left: degree,
  )

  #for det in details [
    - #det
  ]
]



#let skill(
  title: "",
  items: (),
) = [
  *#{title}: * #for item in items [
    #{item},
  ]
]

#let certificate(
  name: "",
  issuer: "",
  url: "",
  date: "",
) = [

  *#name*, #issuer
  #if url != "" {
    [ (#link("https://" + url)[#url])]
  }
  #h(1fr) #date
]

#let extracurriculars(
  activity: "",
  dates: "",
) = {
  generic-one-by-two(
    left: strong(activity),
    right: dates,
  )
}
