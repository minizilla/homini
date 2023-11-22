{ pkgs, dir }:

let
  activation-script = pkgs.callPackage ./activation.nix { };
in
pkgs.runCommand "homini" { } ''
  mkdir -p $out/bin
  cp ${activation-script} $out/bin/homini
  substituteInPlace $out/bin/homini \
    --subst-var-by OUT $out
  ln -s ${dir} $out/homini-dotfiles
''
