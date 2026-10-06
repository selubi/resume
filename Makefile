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
BUILD_DIR ?= build

SRCS := $(wildcard $(SRC_DIR)/*.typ)
PDFS := $(SRCS:$(SRC_DIR)/%.typ=$(BUILD_DIR)/%.pdf)
DEPS := $(PDFS:%.pdf=%.d)

# Typst settings
ifeq ($(strip $(TYPST_FONT_PATHS)),)
$(error TYPST_FONT_PATHS is empty or undefined. Typst inside this makefile will only build with fonts specified in it)
endif

TYPST ?= typst
TYPST_REQUIRED_FONTS := "Source Sans 3" "Noto Sans CJK JP"
TYPST_FONT_FLAGS := --font-path $(TYPST_FONT_PATHS) --ignore-system-fonts --ignore-embedded-fonts
TYPST_COMPILE_FLAGS := --root $(REPO_ROOT) --pdf-standard ua-1 $(TYPST_FONT_FLAGS)


# ===== RECIPES STARTS HERE =====
.PHONY: all
all: $(PDFS)

$(PDFS): $(BUILD_DIR)/%.pdf: $(SRC_DIR)/%.typ | $(BUILD_DIR) check-fonts
	$(TYPST) compile $(TYPST_COMPILE_FLAGS) --deps $(BUILD_DIR)/$*.d --deps-format make $< $@

$(BUILD_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: check-fonts
.SILENT: check-fonts
check-fonts:
	fonts_available=$$($(TYPST) fonts $(TYPST_FONT_FLAGS))
	missing=0
	for font in $(TYPST_REQUIRED_FONTS); do
		if ! grep -qxF "$$font" <<< "$$fonts_available"; then
			echo "error: font '$$font' not found by typst" >&2
			missing=1
		fi
	done
	if (( missing )); then
		echo "Font paths: $(TYPST_FONT_PATHS)" >&2
		echo "Fonts available to typst:" >&2
		sed 's/^/  /' <<< "$$fonts_available" >&2
		exit 1
	fi

-include $(DEPS)