#!/bin/bash

##############################################################################################################
### homebrew!

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install all the things
./brew.sh
./brew-cask.sh

### end of homebrew
##############################################################################################################
