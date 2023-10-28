# Homini

Homini is a minimalist dotfiles manager using Nix inspired by
[Home Manager](https://github.com/nix-community/home-manager) and
[GNU Stow](https://www.gnu.org/software/stow/).

## Why Homini when we have Home Manager?

This [Article](https://www.fbrs.io/nix-hm-reflections) by [Florian Beeres](https://github.com/cideM/)
is what inspired me to write Homini and this quote sums up why

> At the end of the day I really don’t need the per-user installation of packages
> and elaborate modules that Home Manager gives me.
> I’d be perfectly content with providing a list of packages to install system-wide
> and a few basic primitives to generate configuration files in my home folder.

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
