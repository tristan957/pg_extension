<!--
SPDX-License-Identifier: CC0-1.0

SPDX-FileCopyrightText: 2024 Tristan Partin <tristan@partin.io>
-->

# `pg_extension`

This is a template repository for writing C-based Postgres extensions.

Any code in this repository is marked as [`CC0-1.0`](./LICENSES/CC0-1.0.txt)
unless marked otherwise.

## Building

```shell
meson setup build
ninja -C build
```

## Installing

```shell
meson install -C build
```
