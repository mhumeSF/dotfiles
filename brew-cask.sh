#!/bin/bash

brew install caskroom/cask/brew-cask
brew tap caskroom/versions
brew tap caskroom/fonts

apps=(
appcleaner
backblaze
caffeine
docker
dropbox
font-source-code-pro
google-chrome
google-drive
hipchat
keyboard-cleaner
pritunl
selfcontrol
sequel-pro
skitch
slack
spotify
sqlitebrowser
viscosity
vlc
wavebox
zoomus
)

for app in "${apps[@]}"
do
  brew cask install "$app"
done


