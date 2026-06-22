#!/bin/sh

# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileCopyrightText: Tristan Partin <tristan@partin.io>

files=$(find . -name "*.sh" -type f)

# shellcheck disable=SC2086
shfmt --case-indent --diff --language-dialect bash --indent 4 $files
