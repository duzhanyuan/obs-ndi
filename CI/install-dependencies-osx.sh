#!/usr/bin/env bash

# Exit if something fails
set -e

# Echo all commands before executing
set -v

cd ../

# Install Packages app so we can build a package later
# http://s.sudre.free.fr/Software/Packages/about.html
wget --retry-connrefused --waitretry=1 https://s3-us-west-2.amazonaws.com/obs-nightly/Packages.pkg
sudo installer -pkg ./Packages.pkg -target /

brew update
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/fdb7c6e960e830b3bf630850c0002c5df9f68ed8/Formula/qt5.rb

# Fetch and untar prebuilt OBS deps that are compatible with older versions of OSX
wget --retry-connrefused --waitretry=1 https://s3-us-west-2.amazonaws.com/obs-nightly/osx-deps.tar.gz
tar -xf ./osx-deps.tar.gz -C /tmp

curl -kLO "https://obs-nightly.s3-us-west-2.amazonaws.com/NewTek%20NDI%20SDK%20(Apple).zip" -f --retry 5
ls
unzip "./NewTek%20NDI%20SDK%20(Apple).zip"

git clone --recursive https://github.com/jp9000/obs-studio.git
cd ./obs-studio
git checkout 19.0.2
mkdir build
cd build
cmake -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DDepsPath=/tmp/obsdeps  ..
make -j4

cd ../../obs-ndi