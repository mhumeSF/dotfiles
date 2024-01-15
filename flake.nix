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

  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {

    darwinConfigurations.finn = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          users.users.finn.home = "/Users/finn";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.finn.imports = [ ./modules/home-manager ];
          };
        }
      ];
    };

    darwinConfigurations.Michaels-MacBook-Pro = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          users.users.michaelhume.home = "/Users/michaelhume";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.michaelhume.imports = [ ./modules/home-manager ];
          };
        }
      ];
    };

  };
}
