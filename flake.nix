{
  description = "Mememe flake"; inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {
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
