{ pkgs, ... }:

{
  programs.git = {
    settings = {
      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjkND6b+zYkXSG5YlUmbD4ammjF60qv+A/3f+nslQIq";
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
          family = "SauceCodePro Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "SauceCodePro Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "SauceCodePro Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "SauceCodePro Nerd Font";
          style = "Bold Italic";
        };
        size = 15.0;
      };
      env = {
        TERM = "xterm-256color";
      };
      colors = {
        primary = {
          background = "0x1d2021";
          foreground = "0xebdbb2";
        };
        normal = {
          black = "0x282828";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0xa89984";
        };
        bright = {
          black = "0x928374";
          red = "0xfb4934";
          green = "0xb8bb26";
          yellow = "0xfabd2f";
          blue = "0x83a598";
          magenta = "0xd3869b";
          cyan = "0x8ec07c";
          white = "0xebdbb2";
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
