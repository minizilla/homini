{ config, lib, ... }:

let
  cfg = config.homini;
in
{
  imports = [ ./module.nix ];

  config = lib.mkIf cfg.enable {
    system.activationScripts.postUserActivation.text = ''
      "${cfg.activationPackage}/bin/homini"
    '';
  };
}
