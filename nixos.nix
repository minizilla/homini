{ config, lib, pkgs, ... }:

let
  cfg = config.homini;
in
{
  imports = [ ./module.nix ];

  config = lib.mkIf cfg.enable {
    system.userActivationScripts.homini.text = ''
      exec "${cfg.activationPackage}/bin/homini"
    '';
  };
}
