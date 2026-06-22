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
    in {
      default = pkgs.postgresql.pkgs.buildPostgresqlExtension {
        pname = "pg_extension";
        version = pkgs.lib.trim (builtins.readFile ./VERSION);

        src = ./.;

        nativeBuildInputs = with pkgs; [
          meson
          muon
          ninja
          pkgconf
        ];

        meta = {
          description = "A Postgres extension template";
          homepage = "https://github.com/tristan957/pg_extension";
          license = pkgs.lib.licenses.cc0;
          platforms = pkgs.lib.platforms.unix;
        };
      };
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
            postgresql
            prettier
            reuse
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs; [
            gcc
          ]);

        env = pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {CC = "clang";};
      };
    });
  };
}
