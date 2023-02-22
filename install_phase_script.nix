# remember this install phase script for later
{ ... }:
let wrapped =
  ''
    mkdir -p $out/{bin,share/${name}}
    cp -r * $out/share/${name}
    bin=$out/bin/${name}
    cat > $bin <<EOF
    #!/bin/sh -e
    exec ${gems}/bin/bundle exec \
      ${ruby}/bin/ruby $out/share/${name}/lib/${name}/cli/${name} "\$@"
    EOF
    chmod +x $bin
  '';
in wrapped
