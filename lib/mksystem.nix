{
  nixpkgs,
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
  # machineConfig = ../machines/${name}.nix;
  # userOSConfig = ../users/${user}/${if darwin then "darwin" else "nixos" }.nix;
  userHMConfig = ../machines/${name}/home-manager.nix;

  machineConfig = {
    nix.useDaemon = true;
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    programs.zsh.enable = true;
    programs.zsh.shellInit = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix
      '';
  };
  systemFunc = inputs.darwin.lib.darwinSystem;
  home-manager = inputs.home-manager.darwinModules;

  pkgs = import nixpkgs {
    system = system;
  };

  pkgsUnstable = import nixpkgs-unstable {
    system = system;
  };

in systemFunc rec {
  inherit system;
  modules = [
    ../modules/darwin
    { nixpkgs.config.allowUnfree = true; }
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
