{
  description = "Mememe flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Second time I have tried to add this thinking I needed it. IGNORE
    # _1password-shell-plugins.url = "github:1Password/shell-plugins";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }@inputs: let
    mksystem = import ./lib/mksystem.nix { inherit nixpkgs nixpkgs-unstable inputs; };
  in {

    darwinConfigurations.finn = mksystem "finn" {
      system = "aarch64-darwin";
      user = "finn";
      darwin = true;
    };

    darwinConfigurations.task = mksystem "task" {
      system = "aarch64-darwin";
      user = "mike";
      darwin = true;
    };

  };
}
