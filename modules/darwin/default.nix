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

  homebrew = {
    enable = true;
    onActivation = {
      # Both off so a switch is deterministic: brew is not contacted for
      # updates and installed versions only move when explicitly asked
      # (`brew update && brew upgrade`). With these on, every nixswitch
      # produced a different machine and paid a network round-trip.
      autoUpdate = false;
      upgrade = false;

      # cleanup = "zap" would make the lists below authoritative, but 11
      # installed packages are currently undeclared and would be destroyed.
      # Reconcile those first (see TODO in commit) before enabling.
      # cleanup = "zap";
    };
    caskArgs.no_quarantine = false;
    global.brewfile = true;
    # mas search <app> to get "<app> = xxx"
    masApps = {
      "1Password for Safari" = 1569813296;
      "WireGuard" = 1451685025;
    };
    taps = [
      "suzuki-shunsuke/pinact" # provides the pinact cask
    ];
    brews = [
      "dockutil"
      "tfenv"
      "ccusage"

      # Adopted from pre-existing manual installs so this list can become
      # authoritative once cleanup is enabled.
      "bun"
      "container"
      "gnupg"
      "mise"
      "opencode"
      "qemu"
      "regclient"
      "tree-sitter-cli"
      "zizmor"
      {
        name = "gettext";
        link = true;  # equivalent to: brew link --force gettext
      }
    ];
    casks = [
      "1password"
      "1password-cli"
      "Discord"
      "divvy"
      "google-chrome"
      "keyboard-cleaner"
      "notunes"
      "rar"
      "raycast"
      "slack"
      "spotify"
      "ghostty"
      "tailscale-app"
      "viscosity"
      "pinact"
    ];
  };

  # Enable touchid for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  networking.applicationFirewall.enable = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.primaryUser = "${user}";
  # fonts.packages = [ pkgs.nerdfonts.source-code-pro ];
  system.defaults = {
    universalaccess.reduceMotion = true;
    finder.AppleShowAllExtensions = true;
    finder.AppleShowAllFiles = true;
    finder._FXShowPosixPathInTitle = true;
    finder.ShowPathbar = true;
    finder.FXEnableExtensionChangeWarning = false;
    finder.FXDefaultSearchScope = "SCcf"; # search current folder, not This Mac
    finder.FXPreferredViewStyle = "Nlsv"; # list view by default
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.mineffect = "scale";
    dock.orientation = "left";
    dock.tilesize = 36;
    dock.mouse-over-hilite-stack = true;
    dock.show-recents = false;
    dock.mru-spaces = false; # don't reorder Spaces by recent use
    dock.expose-animation-duration = 0.1;
    trackpad.Clicking = true; # tap to click
    controlcenter.Bluetooth = true;
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };
    screencapture = {
      location = "/Users/${user}/Pictures/screenshots";
      disable-shadow = true;
      type = "png";
    };
    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
      DisableConsoleAccess = true;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;
      ApplePressAndHoldEnabled = false;
      AppleKeyboardUIMode = 3; # full keyboard access in dialogs
      InitialKeyRepeat = 14;
      KeyRepeat= 1;
      _HIHideMenuBar = true;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.mouse.tapBehavior" = 1; # tap to click
      NSAutomaticSpellingCorrectionEnabled = false; # disable autocorrect while typing
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false; # save to disk, not iCloud
      NSNavPanelExpandedStateForSaveMode = true; # expanded save dialogs
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
    CustomUserPreferences = {
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

    # Screenshot location must exist before screencapture writes there
    mkdir -p /Users/${user}/Pictures/screenshots

    # Setup 1password SSH agent.sock
    mkdir -p /Users/${user}/.1password
    ln -sf /Users/${user}/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock /Users/${user}/.1password/agent.sock

    # -----------------------------------------------------------------------------
    # Divvy.app
    # -----------------------------------------------------------------------------

    # Setting up Divvy shortcuts (cask build uses the com.mizage.direct.Divvy
    # bundle id, unlike the sandboxed Mac App Store version)
    defaults write com.mizage.direct.Divvy shortcuts -data 62706C6973743030D401020304050862635424746F7058246F626A65637473582476657273696F6E59246172636869766572D1060754726F6F748001AF1010090A152B2C333C3D45464E4F56575D5E55246E756C6CD20B0C0D0E5624636C6173735A4E532E6F626A65637473800FA60F10111213148002800580078009800B800DDD161718191A1B1C1D1E1F20210B2223242523232627282722262A5F101273656C656374696F6E456E64436F6C756D6E5F101173656C656374696F6E5374617274526F775C6B6579436F6D626F436F646557656E61626C65645D6B6579436F6D626F466C6167735F101473656C656374696F6E5374617274436F6C756D6E5B73697A65436F6C756D6E735A73756264697669646564576E616D654B657956676C6F62616C5F100F73656C656374696F6E456E64526F775873697A65526F77731005100010030910060880030880045446756C6CD22D2E2F325824636C61737365735A24636C6173736E616D65A230315853686F7274637574584E534F626A6563745853686F7274637574DD161718191A1B1C1D1E1F20210B3435362523352627392734262A100410011008090880060880045643656E746572DD161718191A1B1C1D1E1F20210B363536253F354027422736402A091200100000100A0880080880045D43656E74657220426967676572DD161718191A1B1C1D1E1F20210B34234725233540274A274C402A10120908800A0810078004544C656674DD161718191A1B1C1D1E1F20210B362350252322402753274C402A10140908800C088004555269676874DD161718191A1B1C1D1E1F20210B3534262523234C275A2722262A0908800E08800456436F726E6572D22D2E5F60A36061315E4E534D757461626C654172726179574E53417272617912000186A05F100F4E534B657965644172636869766572000800110016001F002800320035003A003C004F0055005A0061006C006E007500770079007B007D007F0081009C00B100C500D200DA00E800FF010B0116011E01250137014001420144014601470149014A014C014D014F015401590162016D017001790182018B01A601A801AA01AC01AD01AE01B001B101B301BA01D501D601DB01DD01DE01E001E101E301F1020C020E020F02100212021302150217021C02370239023A023B023D023E02400246026102620263026502660268026F027402780287028F029400000000000002010000000000000064000000000000000000000000000002A6

    # Set cmd+e as global shortcut
    defaults write com.mizage.direct.Divvy globalHotkey -dict keyCode -string 14 modifiers -string 256
    defaults write com.mizage.direct.Divvy useGlobalHotkey -bool true

    # Force reload of preference cache to apply trackpad settings
    # See: https://github.com/nix-darwin/nix-darwin/issues/1572
    killall cfprefsd 2>/dev/null || true

    EOF
  '';
}
