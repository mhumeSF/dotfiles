mkdir "${HOME}/.npm-packages"
echo NPM_PACKAGES="${HOME}/.npm-packages" >> ${HOME}/.zshrc
echo prefix=${HOME}/.npm-packages >> ${HOME}/.npmrc
curl -L https://www.npmjs.org/install.sh | sh
echo NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\" >> ${HOME}/.zshrc
echo PATH=\"\$NPM_PACKAGES/bin:\$PATH\" >> ${HOME}/.zshrc
source ~/.zshrc
