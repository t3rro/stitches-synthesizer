let
  name = "stitches-synthesizer";
in
{
  description = name;

  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.ruby-flake-utils.url = github:t3rro/ruby-flake-utils;

  outputs = { ruby-flake-utils, nixpkgs, ... }: ruby-flake-utils.lib.mkGemSystems
    name
    nixpkgs
    ./Gemfile.lock
    ./Gemfile
    ./gemset.nix
  ;
}
