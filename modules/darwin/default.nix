{ config, lib, pkgs, user, ... }:
{

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
  };

  # Here go the darwin preferences and configuration options
  # See https://daiderd.com/nix-darwin/manual/index.html
  environment = {
    shells = with pkgs; [ bash zsh ];
    pathsToLink = [ "/Applications" ];
  };

  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "dvt" ''
      #!${pkgs.stdenv.shell}
      nix flake init -t "github:the-nix-way/dev-templates#$1"
      direnv allow
    '')
    (pkgs.writeShellScriptBin "dvd" ''
      #!${pkgs.stdenv.shell}
      echo "use flake \"github:the-nix-way/dev-templates?dir=$1\"" >> .envrc
      direnv allow
    '')
  ];

  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # cleanup = "zap";
      upgrade = true;
    };
    caskArgs.no_quarantine = false;
    global.brewfile = true;
    # mas search <app> to get "<app> = xxx"
    masApps = {
      "1Password for Safari" = 1569813296;
      "WireGuard" = 1451685025;
    };
    brews = [
      "dockutil"
      "tfenv"
      "ccusage"
      {
        name = "gettext";
        link = true;  # equivalent to: brew link --force gettext
      }
    ];
    casks = [
      "1password"
      "1password-cli"
      "Discord"
      "Spotify"
      "google-chrome"
      "keyboard-cleaner"
      "leader-key"
      "notunes"
      "rar"
      "raycast"
      "rectangle"
      "slack"
      "spotify"
      "wireshark-app"
      "ghostty"
      "tailscale-app"
      "viscosity"
    ];
  };

  # Enable touchid for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.primaryUser = "${user}";
  # fonts.packages = [ pkgs.nerdfonts.source-code-pro ];
  system.defaults = {
    universalaccess.reduceMotion = true;
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock.autohide = true;
    dock.mineffect = "genie";
    dock.orientation = "left";
    dock.tilesize = 36;
    dock.mouse-over-hilite-stack = true;
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 14;
      KeyRepeat= 1;
      _HIHideMenuBar = true;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.enableSecondaryClick" = true;
      NSAutomaticSpellingCorrectionEnabled = false; # disable autocorrect while typing
    };
    CustomSystemPreferences = {};
    CustomUserPreferences = {
      # Disable AutoFill in Safari
      "com.apple.Safari" = {
        AutoFillFromAddressBook = false;
        AutoFillPasswords = false;
        AutoFillCreditCardData = false;
        AutoFillMiscellaneousForms = false;
        DebugSnapshotsUpdatePolicy = 2;
      };

      # Disable click wallpaper to reveal desktop
      "com.apple.WindowManager" = {
        EnableStandardClickToShowDesktop = 0;
        StandardHideDesktopIcons = 0; # Show items on desktop
        HideDesktop = 0; # Do not hide items on desktop & stage manager
        StageManagerHideWidgets = 0;
        StandardHideWidgets = 0;
      };

      # Use Plain Text Mode as Default in TextEdit
      "com.apple.TextEdit" = {
        RichText = 0;
      };

      # Prevent Time Machine from prompting to use new hard drives as backup volume
      "com.apple.TimeMachine" = {
        DoNotOfferNewDisksForBackup = true;
      };

      # Show Bluetooth in Control Center
      # "com.apple.controlcenter" = {
      #   "NSStatusItem Visible Bluetooth" = 1;
      # };

      "com.apple.systemuiserver" = {
        "NSStatusItem Visible com.apple.menuextra.bluetooth" = true;
      };

      # Leader Key activation shortcut = cmd+e.
      # KeyboardShortcuts stores the shortcut as a JSON string under
      # KeyboardShortcuts_<name>; "activate" is Leader Key's shortcut name.
      # carbonKeyCode 14 = E, carbonModifiers 256 = cmd.
      "com.brnbw.Leader-Key" = {
        KeyboardShortcuts_activate = ''{"carbonKeyCode":14,"carbonModifiers":256}'';
      };

      loginwindow = {
        SHOWFULLNAME = false;
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };
    };
  };
  system.stateVersion = 5;

  system.activationScripts.postActivation.text = ''
    sudo -u ${user} bash <<EOF

    # -----------------------------------------------------------------------------
    # Dock configuration
    # -----------------------------------------------------------------------------

    # Remove all 'pinned' apps on dock
    /opt/homebrew/bin/dockutil --remove all --no-restart

    # Re-add downloads folder
    /opt/homebrew/bin/dockutil --add "/Users/${user}/Downloads" --view grid --display folder

    # -----------------------------------------------------------------------------
    # 1Password SSH agent setup
    # -----------------------------------------------------------------------------

    # Setup 1password SSH agent.sock
    mkdir -p /Users/${user}/.1password
    ln -sf /Users/${user}/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock /Users/${user}/.1password/agent.sock

    # Force reload of preference cache to apply trackpad settings
    # See: https://github.com/nix-darwin/nix-darwin/issues/1572
    killall cfprefsd 2>/dev/null || true

    EOF
  '';
}
