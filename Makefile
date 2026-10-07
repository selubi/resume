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

# Define Sources, Dependencies, and Outputs
SRC_DIR ?= src
OUT_DIR ?= out

# Changing devenv.* requires reloading the environment (`direnv reload`, or re-entering `devenv shell`).
# Building before reloading uses the stale toolchain. Run `make rebuild` to recover.
ENV_PREREQS := Makefile devenv.nix devenv.lock devenv.yaml

SRCS := $(wildcard $(SRC_DIR)/*.typ)
COMPILE_TARGETS := $(SRCS:$(SRC_DIR)/%.typ=$(OUT_DIR)/%.pdf)
COMPILE_DEPS := $(COMPILE_TARGETS:%.pdf=%.d)
EXTRACT_TARGETS := $(COMPILE_TARGETS:%.pdf=%.txt)
LINT_TARGETS := $(COMPILE_TARGETS:%.pdf=%.lint)

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

.DEFAULT_GOAL := build

# ===== RECIPES STARTS HERE =====

# ==== Build
.PHONY: build
build: prebuild compile postbuild

.PHONY: rebuild
rebuild: clean .WAIT build

# ==== Prebuild
.PHONY: prebuild
prebuild: $(OUT_DIR)

$(OUT_DIR):
	mkdir -p $@

# ==== Compile
.PHONY: compile
compile: $(COMPILE_TARGETS)

# Fail compile when there are warnings.
# Workaround until there's a CLI flag to treat warnings as errors. (https://github.com/typst/typst/issues/6787)
$(COMPILE_TARGETS): $(OUT_DIR)/%.pdf: $(SRC_DIR)/%.typ $(ENV_PREREQS) | prebuild
	$(TYPST) compile $(TYPST_COMPILE_FLAGS) --deps $(OUT_DIR)/$*.d --deps-format make $< $@ 2>&1 | tee $(OUT_DIR)/$*.log
	if grep -q '^warning:' $(OUT_DIR)/$*.log; then echo "error: warnings found while compiling $<, failing." >&2; exit 1; fi

-include $(COMPILE_DEPS)

# ==== Postbuild
.PHONY: postbuild
postbuild: extract lint

.PHONY: lint
lint: $(LINT_TARGETS)

# A .lint file exists only if linting passed. Its content doesn't matter.
# Its existence and timestamp let make skip re-linting unchanged documents, so it's a real file, not phony.
$(LINT_TARGETS): $(OUT_DIR)/%.lint: $(OUT_DIR)/%.txt $(HARPER_DICT) $(ENV_PREREQS)
	$(HARPER_CLI) lint --user-dict-path $(HARPER_DICT) $< 2>&1 | tee $@

.PHONY: extract
extract: $(EXTRACT_TARGETS)

$(EXTRACT_TARGETS): $(OUT_DIR)/%.txt: $(OUT_DIR)/%.pdf $(ENV_PREREQS)
	$(PDFTOTEXT) $< $@

# ==== Clean
.PHONY: clean
clean:
	rm -rf $(OUT_DIR)