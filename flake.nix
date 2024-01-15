{
  description = "Mememe flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs: let
    mksystem = import ./lib/mksystem.nix { inherit nixpkgs inputs; };
  in {

    darwinConfigurations.finn = mksystem "finn" {
      system = "aarch64-darwin";
      user = "finn";
      darwin = true;
    };

    darwinConfigurations.Michaels-MacBook-Pro = mksystem "Michaels-MacBook-Pro" {
      system = "aarch64-darwin";
      user = "michaelhume";
      darwin = true;
    };

  };
}
