#!/bin/sh

# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileCopyrightText: Tristan Partin <tristan@partin.io>

# Wrapper around pg_config that redirects --pkglibdir and --sharedir into the
# extension's own output directory instead of the read-only PostgreSQL store
# path. All other flags are forwarded to the real pg_config.
#
# @realPgConfig@ is substituted by Nix at derivation evaluation time.
# $out is resolved by the shell at install time.

# shellcheck disable=SC2154
case "$1" in
    --pkglibdir) echo "$out/lib" ;;
    --sharedir) echo "$out/share/postgresql" ;;
    *) exec @realPgConfig@ "$@" ;;
esac
