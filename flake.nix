{
  description = "aoc-2022";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        inherit (pkgs.lib) optional optionals;
        erlang = pkgs.beam.interpreters.erlangR25;
        elixir = pkgs.beam.packages.erlangR25.elixir_1_14;
        rebar = pkgs.rebar3;
      in
      {
        devShell = pkgs.mkShell {
          MIX_REBAR3 = "${rebar}/bin/rebar3";
          buildInputs = with pkgs; [ cacert git erlang elixir rebar ]
            ++ optional stdenv.isLinux inotify-tools
            ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
            CoreFoundation
            CoreServices
          ]);
          shellHook = ''
            alias c="iex -S mix"
          '';
        };
      }
    );
}
