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

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "BerkeleyMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "BerkeleyMono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "BerkeleyMono Nerd Font Mono";
          style = "Oblique";
        };
        bold_italic = {
          family = "BerkeleyMono Nerd Font Mono";
          style = "Bold Oblique";
        };
        size = 15.0;
      };
      env = {
        TERM = "xterm-256color";
      };
      colors = {
        primary = {
          background = "0x1a1b26";
          foreground = "0xd4be99";
        };
        normal = {
          black = "0x282828";
          blue = "0x458588";
          cyan = "0x689d6a";
          green = "0x98971a";
          magenta = "0xb16286";
          red = "0xcc241d";
          white = "0xa89984";
          yellow = "0xd79921";
        };
        bright = {
          black = "0x928374";
          blue = "0x83a598";
          cyan = "0x8ec07c";
          green = "0xb8bb26";
          magenta = "0xd3869b";
          red = "0xfb4934";
          white = "0xebdbb2";
          yellow = "0xfabd2f";
        };
      };
      keyboard.bindings = [
        { key = "Left";     mods = "Alt";     chars =  "\x1bb";                        } # Skip word left
        { key = "Right";    mods = "Alt";     chars =  "\x1bf";                        } # Skip word right
        { key = "Left";     mods = "Command"; chars =  "\x1bOH";   mode = "AppCursor"; } # Home
        { key = "Right";    mods = "Command"; chars =  "\x1bOF";   mode = "AppCursor"; } # End
        { key = "Back";     mods = "Command"; chars =  "\x15";                         } # Delete line
        { key = "Back";     mods = "Alt";     chars =  "\x1b\x7f";                     } # Delete word
      ];
      # animation = "EaseOutExpo";
      # duration = 0;
      window.decorations = "none";
    };
  };
}
