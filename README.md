# Homini

Homini is a minimalist dotfiles manager using Nix inspired by
[Home Manager](https://github.com/nix-community/home-manager) and
[GNU Stow](https://www.gnu.org/software/stow/).

## NixOS

```nix
{
  description = "My NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    homini.url = "github:minizilla/homini";
    homini.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, homini, ... }: {
    nixosConfigurations.machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        homini.nixosModules.homini {
          homini = {
            enable = true;
            dir = ./dotfiles;
          };
        }
      ];
    };
  };
}
```

## [WIP] MacOS (nix-darwin)
