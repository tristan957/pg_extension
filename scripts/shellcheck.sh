#!/bin/sh

# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileCopyrightText: Tristan Partin <tristan@partin.io>

files=$(find . -name "*.sh" -type f)

# shellcheck disable=SC2086
shellcheck --shell bash --source-path bash -x $files
