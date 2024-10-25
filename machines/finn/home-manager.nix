{ pkgs, ... }:

{
  home.file = {
    ".ssh/allowed_signers".source = ./allowed_signers;
  };
  programs.git = {
    extraConfig = {
      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjkND6b+zYkXSG5YlUmbD4ammjF60qv+A/3f+nslQIq";
      };
    };
  };
}
