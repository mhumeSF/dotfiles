{ pkgs, ... }:

{
  programs.git = {
    extraConfig = {
      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICb3n4z7EaWA60t7g9cywU370HUn4YR4TZwVB6WB2VM5";
      };
    };
  };

  home.file = {
    ".ssh/allowed_signers".source = ./allowed_signers;
  };
}
