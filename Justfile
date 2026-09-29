build_dir := env("BUILD_DIR", justfile_directory() / "build")
langs := "en"

build *targets=langs:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p {{build_dir}}
    for lang in {{targets}}; do
      typst compile "resume/$lang.typ" "{{build_dir}}/$lang.pdf"
    done

test *targets=langs: (build targets)
    #!/usr/bin/env bash
    set -euo pipefail
    for lang in {{targets}}; do
      pdftotext "{{build_dir}}/$lang.pdf"
    done