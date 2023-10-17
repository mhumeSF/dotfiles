{ pkgs, ... }: {
  # Don't change this when you change package input. Leave it alone. backwards compat; don''t change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";
  # specify my home-manager configs
  home.packages = with pkgs; [ neovim ripgrep fd curl less lf ];
  # home.packages = with pkgs; [ bottom curl du-dust fd htop jq kubectl less neofetch neovim pv ripgrep silver-searcher tmux tree wireguard-tools zopfli ];
  home.sessionPath = [
    "$GOBIN"
    "$HOME/.cargo/bin"
    "/opt/homebrew/bin"
    "$HOME/.go/bin:/opt/homebrew/opt/go/libexec"
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "nvim";
    SSH_AUTH_SOCK="$HOME/.1password/agent.sock";
    STARSHIP_CONFIG="$HOME/.config/starship/starship.toml";
  };
  programs.atuin.enable = true;
  programs.atuin.enableZshIntegration = true;
  programs.atuin.settings.style = "compact";
  programs.atuin.settings.inline_height = 26;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.eza.enable = true;
  programs.eza.icons = true;
  programs.eza.enableAliases = true;
  programs.eza.extraOptions = [
    "--group-directories-first"
  ];
  programs.git.enable = true;
  programs.git.lfs.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  # programs.zsh.plugins = [
  #   { name = "aws"; src = ".config/zsh/aws.plugin.zsh"; }
  #   { name = "git"; src = ".config/zsh/git.plugin.zsh"; }
  #   { name = "k8s"; src = ".config/zsh/k8s.plugin.zsh"; }
  #   { name = "tf";  src = ".config/zsh/tf.plugin.zsh"; }
  # ];
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = {
    # nix
    nixswitch = "darwin-rebuild switch --flake ~/src/system-config";
    nixup = "pushd ~/src/system-config; nix flake update; nixswitch; popd";

    # Misc aliases
    vi = "nvim";
    docker = "DOCKER_BUILDKIT=1 docker";
    flushdns = "sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed";
    uuid = "python3 -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | pbcopy && pbpaste && echo";
    zreload = "exec /bin/zsh -l";

    u = "sudo softwareupdate --install --all";
    k = "kubectl";

    gst = "git status";

    # gnu rust replacements
    cat = "bat";
    top = "btm";
    htop = "btm";
    watch = "viddy ";
    du = "dust";
  };
  programs.git.ignores = [
    ### OSX ###
    ".DS_Store"
    ".AppleDouble"
    ".LSOverride"

    # Icon must end with two \r
    "Icon"

    "# Thumbnails"
    "._*"

    # Files that might appear in the root of a volume
    ".DocumentRevisions-V100"
    ".fseventsd"
    ".Spotlight-V100"
    ".TemporaryItems"
    ".Trashes"
    ".VolumeIcon.icns"

    # Directories potentially created on remote AFP share
    ".AppleDB"
    ".AppleDesktop"
    "Network Trash Folder"
    "Temporary Items"
    ".apdisk"

    ".idea"

  ];
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
      };
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
      key_bindings = [
        { key = "Left";     mods = "Alt";     chars =  "\x1bb";                        } # Skip word left
        { key = "Right";    mods = "Alt";     chars =  "\x1bf";                        } # Skip word right
        { key = "Left";     mods = "Command"; chars =  "\x1bOH";   mode = "AppCursor"; } # Home
        { key = "Right";    mods = "Command"; chars =  "\x1bOF";   mode = "AppCursor"; } # End
        { key = "Back";     mods = "Command"; chars =  "\x15";                         } # Delete line
        { key = "Back";     mods = "Alt";     chars =  "\x1b\x7f";                     } # Delete word
      ];
      animation = "EaseOutExpo";
      duration = 0;
    };
  };
  home.file.".config/starship/starship.toml".source = ../../config/starship/starship.toml;
}
