{ pkgs, ... }:

{
  home.file = {
    ".ssh/allowed_signers".source = ./allowed_signers;
  };
}
