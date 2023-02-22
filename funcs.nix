{ pkgs, name }:
let
  # store some gem defaults you'll probably use again
  gemDefaults = rec {
    funcs = {
      mkRubyScript =
        # take script and dispatch it with the local bundle binary
        script: pkgs.writeShellScriptBin script "${gemDefaults.bins.bundle} exec ${script} $@";
    };

    scripts = {
      rake = gemDefaults.funcs.mkRubyScript "rake";
      rubyDevScripts = [ gemDefaults.scripts.rake ];
    };

    envs = {
      gems = pkgs.bundlerEnv configurations.bundlerConfig;
    };

    bins = {
      ruby = pkgs.ruby_3_1;
      bundle = "${gemDefaults.envs.gems}/bin/bundle";
    };

    configurations = {

      bundlerConfig = {
        inherit name;
        ruby = gemDefaults.bins.ruby;
        lockfile = ./Gemfile.lock;
        gemfile = ./Gemfile;
        gemset = ./gemset.nix;
      };

      derivationConfig = {
        src = ./.;
        inherit name;
        buildInputs = [
          gemDefaults.bins.ruby
          gemDefaults.envs.gems
          pkgs.makeWrapper
          pkgs.git
        ] ++ gemDefaults.scripts.rubyDevScripts;
        installPhase = ''
          mkdir -p $out/{bin,share/${name}}
          cp -r * $out/share/${name}
        '';

      };
    };
  };
in
gemDefaults
