#!/bin/bash

brew tap caskroom/versions
brew tap caskroom/fonts

brew install brew-cask-completion

apps=(
    appcleaner
    backblaze
    caffeine
    docker
    dropbox
    font-source-code-pro
    google-chrome
    keyboard-cleaner
    selfcontrol
    sequel-pro
    skitch
    slack
    spotify
    viscosity
    vlc
    wavebox
)

for app in ${apps[@]}
do
    brew cask install $app
done
