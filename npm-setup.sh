#!/bin/bash

# See https://gist.github.com/rcugut/c7abd2a425bb65da3c61d8341cd4b02d

mkdir "${HOME}/.npm-packages"
echo NPM_PACKAGES="${HOME}/.npm-packages" >> ${HOME}/.zshrc
echo prefix=${HOME}/.npm-packages >> ${HOME}/.npmrc

# NOTE @ July 13 2017: the install script from above (from npmjs.com) silently
# fails and doesn't copy the npm package contents correctly (see comments below
# from @hughsw). In order to (hack)fix this you can do the following after
# running the above npm install.sh script.

curl -L https://registry.npmjs.org/npm/-/npm-5.2.0.tgz | tar xz
rm -rf $NPM_PACKAGES/lib/node_modules/npm
mv package $NPM_PACKAGES/lib/node_modules/npm
npm install -g npm

echo NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\" >> ${HOME}/.zshrc
echo PATH=\"\$NPM_PACKAGES/bin:\$PATH\" >> ${HOME}/.zshrc
source ~/.zshrc


