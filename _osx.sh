#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Menu bar: disable transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Set highlight color to green
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable local Time Machine snapshots
sudo tmutil disablelocal

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Ask for password immediately after sleep
defaults write com.apple.screensaver askForPasswordDelay 0.0

# Disable animation when switch screens
defaults write com.apple.universalaccess reduceMotion -bool true

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable two button mouse-click (Secondary click)
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad MouseButtonMode -string "TwoButton"
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Disable "natural" (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Lock docksize
# https://www.macobserver.com/tmo/article/how-to-lock-the-dock-size-position-and-contents-in-os-x
defaults write com.apple.Dock size-immutable -bool yes; killall Dock

# Enable genie mode
defaults write com.apple.dock mineffect -string genie

# Effin' duck!
defaults write com.apple.dock autohide -bool TRUE

# Use dark menu bar and Dock
defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Automatically hide and show the menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

defaults write com.apple.dock orientation left

# Remove all 'pinned' apps on dock
dockutil --remove all

# Re-add downloads folder
dockutil --add '~/Downloads' --view grid --display folder

# https://github.com/boxen/puppet-osx/blob/master/manifests/keyboard/capslock_to_control.pp
# Capslock to control; Control to No Action
vendorId=`ioreg -n IOHIDKeyboard -r | sed -n 's/.*"VendorID" = \([0-9]*\)/\1/p'`
productId=`ioreg -n IOHIDKeyboard -r | sed -n 's/.*"ProductID" = \([0-9]*\)/\1/p'`
defaults -currentHost write NSGlobalDomain com.apple.keyboard.modifiermapping.$vendorId-$productId-0 -array \
  '<dict><key>HIDKeyboardModifierMappingDst</key><integer>2</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'

# Set Top-Right Corner to Mission Control
defaults write com.apple.dockerwvous-tr-corner 2
defaults write com.apple.docker wvous-tr-modifier 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
#defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Terminal
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Make certain Terminal only show scrollbar when scrolling
defaults write com.apple.Terminal AppleShowScrollbars WhenScrolling

open `pwd`/dirty-sneaker-summer.terminal

defaults write com.apple.Terminal "Default Window Settings" -string "dirty-sneaker-summer"
defaults write com.apple.Terminal "Startup Window Settings" -string "dirty-sneaker-summer"

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal
#
###############################################################################
# MISC
###############################################################################

# Use Plain Text Mode as Default
defaults write com.apple.TextEdit RichText -int 0


###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder"; do
    killall "${app}" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

# Command 1 + 3 for left and right

###############################################################################
# Divvy.app
###############################################################################

# Setting up Divvy shortcuts
defaults write com.mizage.Divvy.plist shortcuts -data 62706C6973743030D401020304050862635424746F7058246F626A65637473582476657273696F6E59246172636869766572D1060754726F6F748001AF1010090A152B2C333C3D45464E4F56575D5E55246E756C6CD20B0C0D0E5624636C6173735A4E532E6F626A65637473800FA60F10111213148002800580078009800B800DDD161718191A1B1C1D1E1F20210B2223242523232627282722262A5F101273656C656374696F6E456E64436F6C756D6E5F101173656C656374696F6E5374617274526F775C6B6579436F6D626F436F646557656E61626C65645D6B6579436F6D626F466C6167735F101473656C656374696F6E5374617274436F6C756D6E5B73697A65436F6C756D6E735A73756264697669646564576E616D654B657956676C6F62616C5F100F73656C656374696F6E456E64526F775873697A65526F77731005100010030910060880030880045446756C6CD22D2E2F325824636C61737365735A24636C6173736E616D65A230315853686F7274637574584E534F626A6563745853686F7274637574DD161718191A1B1C1D1E1F20210B3435362523352627392734262A100410011008090880060880045643656E746572DD161718191A1B1C1D1E1F20210B363536253F354027422736402A091200100000100A0880080880045D43656E74657220426967676572DD161718191A1B1C1D1E1F20210B34234725233540274A274C402A10120908800A0810078004544C656674DD161718191A1B1C1D1E1F20210B362350252322402753274C402A10140908800C088004555269676874DD161718191A1B1C1D1E1F20210B3534262523234C275A2722262A0908800E08800456436F726E6572D22D2E5F60A36061315E4E534D757461626C654172726179574E53417272617912000186A05F100F4E534B657965644172636869766572000800110016001F002800320035003A003C004F0055005A0061006C006E007500770079007B007D007F0081009C00B100C500D200DA00E800FF010B0116011E01250137014001420144014601470149014A014C014D014F015401590162016D017001790182018B01A601A801AA01AC01AD01AE01B001B101B301BA01D501D601DB01DD01DE01E001E101E301F1020C020E020F02100212021302150217021C02370239023A023B023D023E02400246026102620263026502660268026F027402780287028F029400000000000002010000000000000064000000000000000000000000000002A6

# Set cmd+e as global shortcut
defaults write com.mizage.Divvy globalHotkey -dict keyCode -string 14 modifiers -string 256
defaults write com.mizage.Divvy.plist useGlobalHotkey -bool true
