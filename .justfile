#!/usr/bin/env -S just --justfile

set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']

esphome_files := `find . -maxdepth 1 -type f -name "*.yaml" -exec grep -l "substitutions:" {} \; | sort`

[private]
default:
    just -l

[doc('Validate all ESPHome config files')]
validate-all:
    echo "{{ esphome_files }}" | while IFS= read -r file; do \
      just validate "${file}"; \
    done

[doc('Validate ESPHome config file')]
validate file:
    if [[ -f "{{ file }}" ]]; then \
      esphome config "{{ file }}"; \
    else \
      just log error "File not found: {{ file }}"; \
    fi;

[doc('Compile all ESPHome config files')]
compile-all:
    echo "{{ esphome_files }}" | while IFS= read -r file; do \
      just compile "${file}"; \
    done

[doc('Compile ESPHome config file')]
compile file:
    if [[ -f "{{ file }}" ]]; then \
      esphome compile "{{ file }}"; \
    else \
      just log error "File not found: {{ file }}"; \
    fi;

[doc('Compile and upload all ESPHome config files')]
upload-all:
    echo "{{ esphome_files }}" | while IFS= read -r file; do \
      just upload "${file}"; \
    done

[doc('Compile and upload ESPHome config file')]
upload file:
    if [[ -f "{{ file }}" ]]; then \
      esphome upload --device OTA "{{ file }}"; \
    else \
      just log error "File not found: {{ file }}"; \
    fi;

[private]
log lvl msg *args:
    gum log -t rfc3339 -s -l "{{ lvl }}" "{{ msg }}" {{ args }}
