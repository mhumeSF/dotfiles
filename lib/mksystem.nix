{ nixpkgs, inputs }:

name:
{
  system,
  user,
  darwin ? false,
}:

let
  # The config files for this system.
  # machineConfig = ../machines/${name}.nix;
  # userOSConfig = ../users/${user}/${if darwin then "darwin" else "nixos" }.nix;
  # userHMConfig = ../users/${user}/home-manager.nix;

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
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {
  inherit system;
  pkgs = import nixpkgs { system = system; };
  modules = [
    ../modules/darwin
    home-manager.home-manager {
      users.users.${user}.home = "/Users/${user}";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user}.imports = [ ../modules/home-manager ];
    }

    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        inputs = inputs;
      };
    }
  ];
}
