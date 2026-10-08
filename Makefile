# Makefile

# Run recipes with bash from PATH, in strict mode (exit on error, unset vars, pipe failures).
SHELL := bash
.SHELLFLAGS := -euo pipefail -c

# Run each recipe in a single shell instead of one shell per line.
.ONESHELL:

# Delete a target if its recipe fails, so partial outputs never look up to date.
.DELETE_ON_ERROR:

# Warn when referencing an undefined variable, like `set -u` for make.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in implicit rules such as %.o: %.c, so only rules defined here apply.
MAKEFLAGS += --no-builtin-rules

# Keep building independent targets after a failure, reporting all errors in one run.
MAKEFLAGS += --keep-going

# Print each target before its recipe, with the reason it's being rebuilt.
MAKEFLAGS += --trace

# Build independent targets in parallel, one job per CPU, with each target's output kept together.
MAKEFLAGS += --jobs=$(shell nproc)
MAKEFLAGS += --output-sync=target

# Determine the repo root and exit with an error if it cannot be determined.
ifndef REPO_ROOT
REPO_ROOT := $(shell git rev-parse --show-toplevel)
endif

ifeq ($(strip $(REPO_ROOT)),)
$(error REPO_ROOT is empty or undefined and could not be determined with `git rev-parse --show-toplevel`)
endif

# Changing devenv.* requires reloading the environment (`direnv reload`, or re-entering `devenv shell`).
# Building before reloading uses the stale toolchain. Run `make rebuild` to recover.
ENV_PREREQS := $(MAKEFILE_LIST) devenv.nix devenv.lock devenv.yaml

.DEFAULT_GOAL := build

SRC_DIR ?= src
BUILD_DIR ?= out
DIST_DIR ?= dist

RESUME_SRCS := $(wildcard $(SRC_DIR)/resumes/*.typ)
RESUME_PDFS := $(RESUME_SRCS:$(SRC_DIR)/%.typ=$(BUILD_DIR)/%.pdf)
RESUME_DEPS := $(RESUME_PDFS:%.pdf=%.d)
RESUME_EXTRACTS := $(RESUME_PDFS:%.pdf=%.txt)
RESUME_LINTS := $(RESUME_PDFS:%.pdf=%.lint)
RESUME_DISTS := $(RESUME_PDFS:$(BUILD_DIR)/resumes/%.pdf=$(DIST_DIR)/%.pdf)

STATIC_SRCS := $(wildcard $(SRC_DIR)/static/*)
STATIC_DISTS := $(STATIC_SRCS:$(SRC_DIR)/static/%=$(DIST_DIR)/%)

# Typst settings
# Fonts are pinned. In this Makefile, Typst only uses fonts from TYPST_FONT_PATHS (system and embedded fonts are ignored).
ifeq ($(strip $(TYPST_FONT_PATHS)),)
$(error TYPST_FONT_PATHS is not set. Run inside devenv or set it explicitly)
endif

TYPST ?= typst
TYPST_COMPILE_FLAGS := --root $(REPO_ROOT) --pdf-standard ua-1 --font-path $(TYPST_FONT_PATHS) --ignore-system-fonts --ignore-embedded-fonts

HARPER_CLI ?= harper-cli
HARPER_DICT ?= $(REPO_ROOT)/.harper-dictionary.txt

PDFTOTEXT ?= pdftotext

WRANGLER ?= wrangler

# ===== HIGH LEVEL TARGETS =====
.PHONY: build
build: compile extract lint

.PHONY: rebuild
rebuild: clean .WAIT build

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR)

.PHONY: deploy
deploy: predeploy
	$(WRANGLER) deploy

.PHONY: predeploy
predeploy: $(RESUME_DISTS) $(STATIC_DISTS)

# ==== build:compile
.PHONY: compile
compile: $(RESUME_PDFS)

# Fail compile when there are warnings.
# Workaround until there's a CLI flag to treat warnings as errors. (https://github.com/typst/typst/issues/6787)
$(RESUME_PDFS): $(BUILD_DIR)/%.pdf: $(SRC_DIR)/%.typ $(ENV_PREREQS)
	mkdir -p $(@D)
	$(TYPST) compile $(TYPST_COMPILE_FLAGS) --deps $(BUILD_DIR)/$*.d --deps-format make $< $@ 2>&1 | tee $(BUILD_DIR)/$*.log
	if grep -q '^warning:' $(BUILD_DIR)/$*.log; then echo "error: warnings found while compiling $<, failing." >&2; exit 1; fi

-include $(RESUME_DEPS)


# ==== build:extract
.PHONY: extract
extract: $(RESUME_EXTRACTS)

$(RESUME_EXTRACTS): $(BUILD_DIR)/%.txt: $(BUILD_DIR)/%.pdf $(ENV_PREREQS)
	$(PDFTOTEXT) $< $@


# ==== build:lint
.PHONY: lint
lint: $(RESUME_LINTS)

# A .lint file exists only if linting passed. Its content doesn't matter.
# Its existence and timestamp let make skip re-linting unchanged documents, so it's a real file, not phony.
$(RESUME_LINTS): $(BUILD_DIR)/%.lint: $(BUILD_DIR)/%.txt $(HARPER_DICT) $(ENV_PREREQS)
	$(HARPER_CLI) lint --user-dict-path $(HARPER_DICT) $< 2>&1 | tee $@


# ==== predeploy
# Depending on the .lint stamp means only linted PDFs can ever reach dist/
$(RESUME_DISTS): $(DIST_DIR)/%.pdf: $(BUILD_DIR)/resumes/%.pdf $(BUILD_DIR)/resumes/%.lint
	mkdir -p $(@D)
	cp $< $@

$(STATIC_DISTS): $(DIST_DIR)/%: $(SRC_DIR)/static/%
	mkdir -p $(@D)
	cp $< $@