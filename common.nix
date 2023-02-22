{ pkgs }:
let
  name = "stitches-synthesizer";
  inherit (import ./funcs.nix { inherit name pkgs; }) configurations;
in
configurations
