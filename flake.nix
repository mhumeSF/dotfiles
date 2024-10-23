{
  description = "Mememe flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }@inputs: let
    mksystem = import ./lib/mksystem.nix { inherit nixpkgs nixpkgs-unstable inputs; };
  in {

    darwinConfigurations.finn = mksystem "finn" {
      system = "aarch64-darwin";
      user = "finn";
      darwin = true;
    };

    darwinConfigurations.Mikes-MacBook-Pro = mksystem "Mikes-MacBook-Pro" {
      system = "aarch64-darwin";
      user = "mike";
      darwin = true;
    };

  };
}
