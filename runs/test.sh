 #!/usr/bin/env bash

echo "I am test"

# this command is downloading Neovim version 0.10.1 source code from GitHub and placing it in the ~/personal/neovim directory on your system. 
git clone -b v0.10.1 git@github.com:neovim/neovim.git $HOME/personal/neovim 
cd $HOME/personal/neovim
sudo apt install cmake gettext lua5.1 liblua5.1-0-dev
make CMAKE_BUILD_TYPE=RelWithDebInfo #cmake
sudo make install # install neovim the The Makefile comes from the Neovim source code repository that you cloned from GitHub