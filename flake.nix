{
  description = "Homini - Minimalist Dotfiles Manager using Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, ... }: {
    nixosModules = rec {
      homini = import ./nixos.nix;
      default = homini;
    };
    standalone = import ./standalone.nix;
  };
}
