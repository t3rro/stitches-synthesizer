{
  description = "stitches synthesizer";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ruby-flake-utils.url = "github:t3rro/ruby-flake-utils";

  outputs = { self, nixpkgs, flake-utils, ruby-flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        name = "stitches-synthesizer";
        system = "x86_64-linux";
        gems = pkgs.bundlerEnv configurations.bundlerConfig;
        pkgs = import nixpkgs { inherit system; };
        rflutils = ruby-flake-utils.lib;
        funcs = rflutils.mkFuncs pkgs bins;
        scripts = rflutils.mkScripts funcs;
        envs = rflutils.mkEnvs pkgs configurations;
        bins = rflutils.mkBins envs pkgs;
        configurations = rflutils.mkConfigurations { inherit name pkgs envs scripts bins; };
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          stitches = pkgs.callPackage ./package.nix { inherit pkgs; };
        };
        defaultPackage = packages.stitches;
        devShell =
          let
            derivationConfig = configurations.derivationConfig // {
              shellHook = "zsh";
              buildInputs = configurations.derivationConfig.buildInputs ++ [ pkgs.zsh ];
            };
          in
          pkgs.stdenv.mkDerivation derivationConfig;
      }
    );
}
