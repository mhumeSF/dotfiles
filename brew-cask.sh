#!/bin/bash

brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

brew install brew-cask-completion

apps=(
    backblaze
    caffeine
    docker
    font-source-code-pro
    google-chrome
    hub
    keyboard-cleaner
    selfcontrol
    slack
    spotify
    viscosity
    vlc
    wavebox
    wireguard
)

for app in ${apps[@]}
do
    brew install --cask $app
done
