# Homini

Homini is a **minimalist dotfiles manager** using Nix inspired by
[Home Manager](https://github.com/nix-community/home-manager) and
[GNU Stow](https://www.gnu.org/software/stow/).

## How to use Homini?

Consider the following snipet

```nix
homini = {
  enable = true;
  dir = ./dotfiles;
};
```

this will link the `dotfiles` directory

```
dotfiles
└── .config
    └── git
        ├── config
        ├── ignore
        ├── personal
        └── work
```

to your `$HOME` directory.

```
$HOME
└── .config
    └── git
        ├── config -> /nix/store/xqj0sf5q4q35q1hp19yyhfp8sbp0zrwa-dotfiles/.config/git/config
        ├── ignore -> /nix/store/xqj0sf5q4q35q1hp19yyhfp8sbp0zrwa-dotfiles/.config/git/ignore
        ├── personal -> /nix/store/xqj0sf5q4q35q1hp19yyhfp8sbp0zrwa-dotfiles/.config/git/personal
        └── work -> /nix/store/xqj0sf5q4q35q1hp19yyhfp8sbp0zrwa-dotfiles/.config/git/work
```

### NixOS

Rebuild the following flake with `nixos-rebuild switch --flake .#machine`.

```nix
{
  description = "My NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    homini.url = "github:minizilla/homini";
    homini.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, homini, ... }: {
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

### MacOS (nix-darwin)

Rebuild the following flake with `darwin-rebuild switch --flake .#machine`.

```nix
{
  description = "My MacOS (nix-darwin) Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    homini.url = "github:minizilla/homini";
    homini.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { darwin, homini, ... }: {
    darwinConfigurations.machine = darwin.lib.darwinSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        homini.darwinModules.homini {
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

### Standalone

Run the following flake with `nix run`.

```nix
{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    homini.url = "github:minizilla/homini";
    homini.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, homini, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system: {
        default = homini.standalone {
          pkgs = nixpkgs.legacyPackages.${system};
          dir = ./dotfiles;
        };
      });
    };
}
```

## Why Homini when we have Home Manager?

This [Article](https://www.fbrs.io/nix-hm-reflections) by [Florian Beeres](https://github.com/cideM/)
is what inspired me to write Homini and this quote sums up why

> At the end of the day I really don’t need the per-user installation of packages
> and elaborate modules that Home Manager gives me.
> I’d be perfectly content with providing a list of packages to install system-wide
> and a few basic primitives to generate configuration files in my home folder.
