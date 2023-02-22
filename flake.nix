{
  description = "stitches synthesizer";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ruby-flake-utils.url = "github:t3rro/ruby-flake-utils";

  outputs = { self, nixpkgs, flake-utils, ruby-flake-utils }:
    let
      systems = flake-utils.lib.eachDefaultSystem
        (
          system:
          let
            gemSystem = ruby-flake-utils.lib.mkGemSystem system "stitches-synthesizer";

            inherit (gemSystem) pkgs configurations;

            thisSystem =
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
              };
          in
          thisSystem
        );
    in
    systems;
}
