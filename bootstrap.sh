
sh brew.sh
sh brew-cask.sh
sh osx.sh

# Oh-my-zsh setup
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Vim Setup
curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh

# NPM Standalone install
mkdir "${HOME}/.npm-packages"
echo NPM_PACKAGES="${HOME}/.npm-packages" >> ${HOME}/.zshrc
echo prefix=${HOME}/.npm-packages >> ${HOME}/.npmrc
curl -L https://www.npmjs.org/install.sh | sh
echo NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\" >> ${HOME}/.zshrc
echo PATH=\"\$NPM_PACKAGES/bin:\$PATH\" >> ${HOME}/.zshrc
source ~/.zshrc

cp `pwd`/prefs/private.xml /Users/`whoami`/Library/Application\ Support/Karabiner/

