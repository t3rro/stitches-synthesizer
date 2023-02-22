{
  description = "stitches synthesizer";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        system = "x86_64-linux";
        gems = pkgs.bundlerEnv common.bundlerConfig;
        common = import ./common.nix { inherit pkgs; };
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          stitches = pkgs.callPackage ./package.nix { inherit pkgs; };
        };
        defaultPackage = packages.stitches;
        devShell =
          let
            derivationConfig = common.derivationConfig // {
              shellHook = "zsh";
              buildInputs = common.derivationConfig.buildInputs ++ [ pkgs.zsh ];
            };
          in
          pkgs.stdenv.mkDerivation derivationConfig;
      }
    );
}
