# Résumé TODO

## Contents

- [ ] Revisit en contents
  - [ ] `Onpremise` → `on-premises`
  - [ ] Unify Dante wording ("Dante Certification level 3" vs "Dante Certified Level 3")
  - [ ] Check the `DisjointPrefixes` finding (line 77)
  - [ ] Decide on `Python/Config` vs `Python/configuration`
  - [ ] Switch dates to numeric (`2025-01`) or full month names (also silences the `Dec`/`Jan` lint noise)
  - [ ] Add `#set text(hyphenate: false)` to the template
- [ ] Port old ja to new ja
  - [ ] Confirm `ja.typ` declares `lang: "ja"`

## Platform

- [ ] Japanese linting (textlint instead of harper on ja)
- [ ] Pass en lint
  - [ ] Add `Bahasa`, `RHEL`, `B.E.` to `.harper-dictionary.txt`
  - [ ] Fix `.harper-dictionary.txt` not loading in the editor (check the Harper output channel)
- [ ] Move check-fonts into its own script, revisit `TYPST_REQUIRED_FONTS`
  - [ ] Keep required fonts in sync with the template's `#set text(font: ...)`

## Deploy (a headache for later)

- [ ] Workers static assets: `wrangler.toml` with `[assets] directory = "./out"`
- [ ] Experiment on `workers.dev`, then a throwaway subdomain
- [ ] `_redirects` / `_headers` for clean URLs and inline PDFs
- [ ] Custom domain: decide wrangler vs Pulumi ownership
- [ ] CI: `devenv shell make`, fail on make warnings, `safe.directory` if containerized
