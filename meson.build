# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileCopyrightText: 2024 Tristan Partin <tristan@partin.io>

project(
  'pg_extension',
  'c',
  version: files('VERSION'),
  default_options: {
    'buildtype': 'debugoptimized',
    'c_std': 'gnu11',
    'warning_level': '2',
  },
  meson_version: '>=1.3',
)

fs = import('fs')

cc = meson.get_compiler('c')
pg_config = find_program('pg_config')

# Strip relative path prefixes from the code if possible, otherwise hide them.
relative_path = fs.relative_to(
  meson.global_source_root(),
  meson.global_build_root(),
)

add_project_arguments(
  cc.first_supported_argument(
    '-fmacro-prefix-map=@0@='.format(relative_path),
    '-DPG_EXTENSION_REL_SRC_DIR="@0@"'.format(relative_path)
  ),
  language: 'c',
)

add_project_arguments(
  cc.get_supported_arguments(
    '-D_POSIX_C_SOURCE=200112L',
    '-Wdeclaration-after-statement',
    '-Wdouble-promotion',
    '-Wduplicated-branches',
    '-Wduplicated-cond',
    '-Wendif-labels',
    '-Wformat=2',
    '-Wformat-overflow=2',
    '-Wformat-signedness',
    '-Wformat-truncation=1',
    '-Winit-self',
    '-Wlogical-op',
    '-Wmissing-prototypes',
    '-Wnull-dereference',
    '-Wshadow',
    '-Wuninitialized',
    '-Wvla',
    # Postgres headers will trigger the following warnings.
    '-Wno-conversion',
    '-Wno-unused-parameter',
  ),
  language: 'c',
)

dirs = run_command(
  pg_config,
  '--includedir-server',
  '--pkglibdir',
  '--sharedir',
  check: true,
).stdout().strip().split('\n')

includedir_server = include_directories(dirs[0])
pkglibdir = dirs[1]
sharedir = dirs[2] / 'extension'

configure_file(
  input: '@0@.control.in'.format(meson.project_name()),
  output: '@0@.control'.format(meson.project_name()),
  configuration: configuration_data({
    'NAME': meson.project_name(),
    'VERSION': meson.project_version(),
  }),
  install: true,
  install_dir: sharedir,
)

install_data(
  'sql/pg_extension.sql',
  install_dir: sharedir,
)

shared_module(
  meson.project_name(),
  'src/extension.c',
  name_prefix: '',
  include_directories: [
    includedir_server,
  ],
  install: true,
  install_dir: pkglibdir,
)
