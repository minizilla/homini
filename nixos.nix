{ config, lib, pkgs, ... }:

let
  cfg = config.homini;
in
{
  imports = [ ./activation.nix ];

  config = lib.mkIf cfg.enable {
    system.userActivationScripts.homini.text = ''
      exec "${cfg.activationPackage}/bin/homini"
    '';
  };
}
