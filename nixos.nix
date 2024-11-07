{ config, lib, ... }:

let
  cfg = config.homini;
in
{
  imports = [ ./module.nix ];

  config = lib.mkIf cfg.enable {
    system.userActivationScripts.homini.text = ''
      "${cfg.activationPackage}/bin/homini"
    '';
  };
}
