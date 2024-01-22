{ pkgs, ... }: {
  programs.zsh.enable = true;
  # Here go the darwin preferences and configuration options
  # See https://daiderd.com/nix-darwin/manual/index.html
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    pathsToLink = [ "/Applications" ];
  };
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  fonts.fontDir.enable = true; # DANGER
  fonts.fonts =  with pkgs; [ (nerdfonts.override { fonts = [ "SourceCodePro" ]; }) ];
  services.nix-daemon.enable = true;
  system.defaults = {
    # universalaccess.reduceMotion = true;
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock.autohide = true;
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 14;
      KeyRepeat= 1;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.enableSecondaryClick" = true;
    };
    CustomSystemPreferences = {};
    CustomUserPreferences = {
      # Disable AutoFill in Safari
      "com.apple.Safari".AutoFillFromAddressBook = false;
      "com.apple.Safari".AutoFillPasswords = false;
      "com.apple.Safari".AutoFillCreditCardData = false;
      "com.apple.Safari".AutoFillMiscellaneousForms = false;
    };
  };
  # backwards compat; don't change
  system.stateVersion = 4;
}
