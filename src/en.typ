// src/en.typ

#import "../lib/selu-cv.typ": *

#show: resume.with(
  // Your name: the big heading at the top, and the PDF's Author field
  author: "Gregorius Bryan",
  // Title metadata for the PDF, and on the footer (defaults to "<author>'s Resume")
  title: "Gregorius Bryan's Resume",
  location: "Tokyo, Japan",
  email: "gregorius.bryan@selubi.tech",
  github: "github.com/selubi",
  linkedin: "linkedin.com/in/selubi",
  lang: "en",
  accent-color: "#14213D",
)

== Summary

Trilingual (JLPT N1/990 TOEIC) Senior Platform \& Infrastructure Engineer with a track record of accelerated promotion, specializing in the architecture of developer platforms and infrastructure at massive scale.

Proven track record of resolving organizational deadlocks by decoupling software runtimes from infrastructure, unblocking global OS migrations for 4,000+ developers and managing 60,000+ server fleets.

Highly proficient in Python ecosystem management at scale and infrastructure automation.
Combines hands-on engineering expertise with the ability to manage complex stakeholders in cross-cultural global teams.

== Work Experience

#institution(
  institution: "Woven by Toyota",
  location: "Tokyo, Japan",
)\
#role(
  role: "Platform Engineer (Contract)",
  dates: dates-helper(start-date: "Jan 2026", end-date: "Present"),
)
- Architected a Python interpreter resolution policy for 4,000+ developers across multiple Toyota group companies working within heterogeneous monorepos (Bazel, Poetry, ad-hoc scripts) in the AD/ADAS domain. Enforced this by implementing a sane-default resolution layer that decoupled Python from OS upgrade lifecycles to unblock global OS migrations with minimal developer disruption.

#institution(
  institution: "Rakuten Group, Inc.",
  location: "Tokyo, Japan",
)\
#role(
  role: "Senior Infrastructure Engineer",
  dates: "Jan 2026",
)
- Selected for merit-based promotion to Grade A (P4 / Senior Level) following the 2025 year-end performance review in recognition of leadership in the hardware lab and decommissioning projects.


#role(
  role: "Infrastructure Engineer",
  dates: dates-helper(start-date: "Jan 2025", end-date: "Dec 2025"),
)
- Spearheaded the 0 to 1 development of an isolated hardware lab for pre-purchase benchmarking. Succeeded the project's Principal Engineer as Lead Designer and Owner, taking full responsibility for architectural evolution, procurement strategy, and automated testing.
- Architected and implemented an end-to-end standardized server decommissioning workflow adopted as the current organizational standard. Retired 5,000+ legacy servers saving millions of yen monthly and mentored a successor to ensure long-term operational continuity.
- Served as a co-owner of a 200k+ line Python internal automation framework, leading its maintenance and continuous feature enhancement. Iteratively identified and resolved systemic bottlenecks through root-cause analysis (RCA) of complex failures, optimizing operational processes for multiple global departments.

#role(
  role: "Associate Infrastructure Engineer",
  dates: dates-helper(start-date: "Apr 2023", end-date: "Dec 2024"),
)
- Engineered and improved various automation pipelines (Python, Bash, Jenkins) to streamline the provisioning and configuration management (Chef Infra) of a 60,000+ server global Bare-Metal-as-a-Service (BMaaS) platform.
- Refactored the Python-based Chef cookbook delivery system to eliminate race conditions and non-deterministic behavior; reduced daily synchronization time by 12x (6h → 30m) while ensuring data integrity within each environment boundary.
- Significantly contributed to reducing server provisioning error rates from 30% to 10% by engineering automated firmware upgrades and hardware/network health-check workflows, markedly improving deployment reliability.


== Education

#institution(
  institution: "Kwansei Gakuin University",
  location: "Hyogo, Japan",
)\
#role(
  role: "Bachelor of Engineering in Computer Science and Engineering",
  dates: dates-helper(start-date: "Apr 2019", end-date: "Mar 2023"),
)
- Highest GPA in major (3.88/4.0), full curriculum completed in Japanese as a non-native speaker
- Recipient of multiple merit-based, non-repayable scholarships covering tuition and monthly living stipend (see Honors & Awards)
- First-author research publication as an undergraduate (see Publications)
- Extracurricular Activities: Culture Festival Preparation Committee, Projection Mapping Club

== Skills

- *Languages:* English (Near-Native / TOEFL iBT 108), Japanese (Near-Native / JLPT N1), Indonesian (Native)

- *Systems & Infrastructure:* Linux, Bare-Metal-as-a-Service (BMaaS), End-to-End Server Management (Physical & Logical), On-premise Private Cloud.

- *Platform & DevOps:* Bazel, Nix, Chef Infra, Ansible, Jenkins, GitHub Actions, Docker, Developer Tooling.

- *Programming Languages:* Python, Bash, Go, Ruby, C++.

== Certifications
#certification(
  name: "Dante Certification level 3",
  date: "Jan 2025",
  issuer: "Audinate",
)

#certification(
  name: "AWS Certified Solutions Architect - Associate",
  date: "Mar 2024",
  issuer: "Amazon Web Services (AWS)",
)

#certification(
  name: "Applied Information Technology Engineer Examination",
  date: "Dec 2022",
  issuer: "IPA",
)

#certification(
  name: "TOEIC L&R 990 Points (Perfect Score)",
  date: "Nov 2021",
  issuer: "ETS",
)

#certification(
  name: "Fundamental Information Technology Engineer Examination",
  date: "Mar 2021",
  issuer: "IPA",
)

#certification(
  name: "Japanese-Language Proficiency Test N1",
  date: "Jan 2019",
  issuer: "JEES",
)

#certification(
  name: "TOEFL iBT 108 Points",
  date: "Jan 2019",
  issuer: "ETS",
)

== Publications
#institution(
  institution: "The 20th Annual Workshop of the Australasian Language Technology Association",
  location: "Adelaide, Australia",
)\
#role(
  role: "Generating Code-Switched Text from Monolingual Text with Dependency Tree",
  dates: "Dec 2022",
)

== Honors & Awards
#certification(
  name: "Scholarship for Self-Supporting Students",
  date: dates-helper(start-date: "2019", end-date: "2023"),
  issuer: "Sato Yo International Scholarship Foundation (SISF)",
)

#certification(
  name: "Scholarship for highest GPA in academic year",
  date: dates-helper(start-date: "2020", end-date: "2022"),
  issuer: "Kwansei Gakuin University",
)

#certification(
  name: "Alumni award for highest GPA in major",
  date: "2023",
  issuer: "Kwansei Gakuin University",
)

== Other Experience
- Competitive Programming (Green rank at AtCoder, in C++).
- Dante Certified Level 3, hobbyist for audio equipment and AVoIP routing.
- AI Program Teaching Assistant: Facilitated student on preparing development environments and understanding API architecture.
- Mathematics Instructor for a class of international students preparing for university entrance exams (30 people).
