# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileCopyrightText: Tristan Partin <tristan@partin.io>
{
  description = "pg_extension - A Postgres extension template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    nixpkgs,
    systems,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      buildExtension = postgresql: let
        # Wrap pg_config so that --pkglibdir and --sharedir point into $out
        # rather than into the PostgreSQL store path. The meson.build uses
        # pg_config to determine where to install the .so and extension files,
        # so without this the build would try to write into the read-only
        # PostgreSQL derivation.
        pgConfigWrapper = pkgs.replaceVars ./nix/pg_config_wrapper.sh {
          realPgConfig = "${postgresql.pg_config}/bin/pg_config";
        };
      in
        pkgs.stdenv.mkDerivation {
          pname = "pg_extension";
          version = pkgs.lib.trim (builtins.readFile ./VERSION);

          src = ./.;

          nativeBuildInputs = with pkgs; [
            meson
            ninja
            pkg-config
            postgresql.pg_config
          ];

          buildInputs = [postgresql.dev];

          preConfigure = ''
            mkdir -p "$TMPDIR/pg_config_wrap/bin"
            install -m755 ${pgConfigWrapper} "$TMPDIR/pg_config_wrap/bin/pg_config"
            export PATH="$TMPDIR/pg_config_wrap/bin:$PATH"
          '';

          meta = {
            description = "A Postgres extension template";
            homepage = "https://github.com/tristan957/pg_extension";
            license = pkgs.lib.licenses.cc0;
            platforms = pkgs.lib.platforms.unix;
          };
        };
    in {
      default = buildExtension pkgs.postgresql_18;
      postgresql_14 = buildExtension pkgs.postgresql_14;
      postgresql_15 = buildExtension pkgs.postgresql_15;
      postgresql_16 = buildExtension pkgs.postgresql_16;
      postgresql_17 = buildExtension pkgs.postgresql_17;
      postgresql_18 = buildExtension pkgs.postgresql_18;
    });

    devShells = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            alejandra
            clang
            clang-tools
            markdownlint-cli2
            meson
            muon
            ninja
            nixd
            pkgconf
            postgresql_18
            prettier
            reuse
            shellcheck
            shfmt
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs; [
            gcc
          ]);

        env = pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {CC = "clang";};
      };
    });
  };
}
