{
  nixpkgs-unstable,
  inputs,
}:
name: {
  system,
  user,
  darwin ? false,
}:

let
  # The config files for this system.
  userHMConfig = ../machines/${name}/home-manager.nix;

  systemFunc = inputs.darwin.lib.darwinSystem;
  home-manager = inputs.home-manager.darwinModules;

  pkgsUnstable = import nixpkgs-unstable {
    system = system;
    config.allowUnfree = true;
  };

in systemFunc rec {
  inherit system;
  modules = [
    ../modules/darwin
    { nixpkgs.config.allowUnfree = true; }
    { nix.enable = false; }
    home-manager.home-manager {
      users.users.${user}.home = "/Users/${user}";
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { pkgs-unstable = pkgsUnstable; };
        users.${user}.imports = [ ../modules/home-manager ] ++ [ userHMConfig ];
      };
    }
  ];
  specialArgs = { inherit user; pkgs-unstable = pkgsUnstable; };
}
