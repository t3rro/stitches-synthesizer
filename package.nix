{ stdenv, bundlerEnv, pkgs, makeWrapper }:
with pkgs;
let
  common = import ./common.nix { inherit pkgs; };
  derivationConfig = common.derivationConfig;
  gems = common.bundlerConfig;
in
stdenv.mkDerivation derivationConfig
