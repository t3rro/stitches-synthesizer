{
  description = "stitches synthesizer";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.ruby-flake-utils.url = github:t3rro/ruby-flake-utils;

  outputs = { self, nixpkgs, flake-utils, ruby-flake-utils }@attrs:
    let
      systems = ruby-flake-utils.lib.mkGemSystems "stitches-synthesizer" nixpkgs ./Gemfile.lock ./Gemfile ./gemset.nix;
      # systems = flake-utils.lib.eachDefaultSystem
      #   (
      #     system:
      #     let
      #       gemSystem = ruby-flake-utils.lib.mkGemSystem
      #         system
      #         "stitches-synthesizer"
      #         nixpkgs
      #         ./Gemfile.lock
      #         ./Gemfile
      #         ./gemset.nix;
      #
      #       # inherit (gemSystem) pkgs configurations;
      #       #
      #       # thisSystem =
      #       #   rec {
      #       #     packages = flake-utils.lib.flattenTree { stitches = pkgs.stdenv.mkDerivation configurations.derivationConfig; };
      #       #     defaultPackage = packages.stitches;
      #       #     devShell =
      #       #       let
      #       #         derivationConfig = configurations.derivationConfig // {
      #       #           shellHook = "zsh";
      #       #           buildInputs = configurations.derivationConfig.buildInputs ++ [ pkgs.zsh ];
      #       #         };
      #       #       in
      #       #       pkgs.stdenv.mkDerivation derivationConfig;
      #       #   };
      #     in
      #     gemSystem
      #   );
    in
    systems;
}
