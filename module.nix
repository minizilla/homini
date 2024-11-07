{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homini;
in
{
  options.homini = {
    enable = lib.mkEnableOption ''Enable homini.'';

    dir = lib.mkOption {
      type = lib.types.path;
      description = ''
        The path of the dotfiles directory that will be symlinked to $HOME.
      '';
    };

    activationPackage = lib.mkOption {
      internal = true;
      type = lib.types.package;
      description = ''
        The package containing the complete activation script.
      '';
    };
  };

  config = {
    homini.activationPackage =
      let
        activation-script = pkgs.callPackage ./activation.nix { };
      in
      pkgs.runCommand "homini" { } ''
        mkdir -p $out/bin
        cp ${activation-script} $out/bin/homini
        substituteInPlace $out/bin/homini \
          --subst-var-by OUT $out
        ln -s ${cfg.dir} $out/homini-dotfiles
      '';
  };
}
