let
  username = builtins.getEnv "USER"; # or builtins.getEnv "LOGNAME"
in {
  description = "Mememe flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations."${username}" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          users.users.${username}.home = "/Users/${username}";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username}.imports = [ ./modules/home-manager ];
          };
        }
      ];
    };
  };
}

