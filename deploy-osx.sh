#!/bin/bash

# Install MacOS Command Line Tools
xcode-select --install

# Accept licences
sudo xcodebuild -license

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#### WGET ####
brew install wget

#### TMUX ####
# install tmux
brew install tmux
# install dotfile
cp dotfiles/tmux.conf ~/.tmux.conf
# install tmuxinator
sudo gem install tmuxinator

#### ZSH ####
# install zsh
brew install zsh
# install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


echo "" >> ~/.zshrc
echo "export EDITOR='vim'" >> ~/.zshrc
echo "# Environment Variables" >> ~/.zshrc
