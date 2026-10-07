// lib/selu-cv.typ

// This is a custom template based on https://typst.app/universe/package/basic-resume

// Additions:
// - Ability to include promotion within the same institution by #insitution \ #role.
// - Hyphenated compounds are never broken across lines.
//
// Deletions:
// - Mentions of orcid, and therefore the need to import science icon pack
// - Two by two component is dropped in favor of one by two joined with linebreaks
// - Simplifaction of section components primitives. Theres only #institution, #role, and #certification now


#let inline-separator = "  |  "

#let resume(
  author: "",
  // PDF metadata title. Defaults to "<author>'s Resume".
  title: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  accent-color: "#000000",
  // Noto Sans CJK JP is Adobe's Source Han Sans under Google's name.
  // Its Latin glyphs are scaled-up Source Sans 3, not Noto Sans.
  // https://en.wikipedia.org/wiki/Source_Han_Sans
  // Listing Source Sans 3 first keeps Latin at its native scale, matching the English resume.
  // Glyphs it lacks (kana, kanji, full-width punctuation) fall back to Noto Sans CJK JP.
  font: ("Source Sans 3", "Noto Sans CJK JP"),
  paper: "a4",
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
  body,
) = {
  let title = if title == "" { author + "'s Resume" } else { title }

  // Sets document metadata
  set document(author: author, title: title)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    fallback: false,
    size: font-size,
    lang: lang,
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false,
    hyphenate: false,
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    margin: 0.5in,
    paper: paper,
    // Title and page number, e.g. "Gregorius Bryan's Resume        1 / 2"
    footer: context [
      #set text(size: 8pt, fill: luma(120))
      #title #h(1fr) #counter(page).display("1 / 1", both: true)
    ],
  )

  // Never break lines inside hyphenated compounds (on-premises, co-owner, Bare-Metal-as-a-Service).
  // Text extractors join line-ending hyphens as if they were soft hyphenation, corrupting the word.
  show regex("[A-Za-z0-9]+(-[A-Za-z0-9]+)+"): box

  // Link styles
  show link: underline

  // Small caps for section titles
  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #(author)]

  // Personal Info Helper
  let contact-item(value, prefix: "", link-type: "") = {
    if value != "" {
      if link-type != "" {
        link(link-type + value)[#(prefix + value)]
      } else {
        value
      }
    }
  }

  // Personal Info
  pad(
    top: 0.25em,
    align(personal-info-position)[
      #{
        let items = (
          contact-item(pronouns),
          contact-item(phone),
          contact-item(location),
          contact-item(email, link-type: "mailto:"),
          contact-item(github, link-type: "https://"),
          contact-item(linkedin, link-type: "https://"),
          contact-item(personal-site, link-type: "https://"),
        )
        items.filter(x => x != none).join(inline-separator)
      }
    ],
  )

  // Main body.
  set par(justify: true)

  body
}

// Generic one by two component for resume
#let generic-one-by-two(left: "", right: "") = left + h(1fr) + right

#let dates-helper(start-date: "", end-date: "") = start-date + " - " + end-date

// Section components below
#let institution(institution: "", location: "") = generic-one-by-two(left: strong(institution), right: emph(location))

#let role(role: "", dates: "") = generic-one-by-two(left: role, right: dates)

#let certification(name: "", issuer: "", date: "") = [ *#name*, #issuer #h(1fr) #date ]

// // Generic two by two component for resume
// #let generic-two-by-two(
//   top-left: "",
//   top-right: "",
//   bottom-left: "",
//   bottom-right: "",
// ) = {
//   [
//     #top-left #h(1fr) #top-right \
//     #bottom-left #h(1fr) #bottom-right
//   ]
// }


// #let institution(institution: "", location: "", dates: "") = {
//   let left = if location != "" {
//     strong(institution) + inline-separator + emph(location)
//   } else {
//     strong(institution)
//   }
//   generic-one-by-two(
//     left: left,
//     right: dates,
//   )
// }

// #let role(role: "", location: "", dates: "") = {
//   let left = if location != "" {
//     role + inline-separator + emph(location)
//   } else {
//     role
//   }
//   generic-one-by-two(
//     left: left,
//     right: dates,
//   )
// }
