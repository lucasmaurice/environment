#!/bin/bash

# ATOM
wget -P temp https://atom.io/download/deb
sudo dpkg -i temp/deb
rm -R temp
# SPOTIFY
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client
sudo apt-get install xclip

#CONFIGURE GITHUB
git config --global user.name "Lucas Maurice"
git config --global user.email "lucas.maurice@outlook.com"
#NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
#ssh-keygen -t rsa -b 4096 -C "lucas.maurice@outlook.com"
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_rsa
#cat ~/.ssh/id_rsa.pub
#echo "Now go in your GitHub Settings and copy/paste your SSH key."


#INSTALL ZSH TERMINAL
sudo apt install zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

#INSTALL TMUX
sudo apt install tmux

#INSTALL HTOP
sudo apt install htop
