#!/bin/bash

#INSTALL ZSH TERMINAL
sudo apt install zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

#INSTALL PREFERED SOFTWARES
sudo apt install chromium-browser
wget -P temp https://atom.io/download/deb
sudo dpkg -i temp/deb
rm -R temp

#CONFIGURE GITHUB
git config --global user.name "Lucas Maurice"
git config --global user.email "lucas.maurice@outlook.com"
ssh-keygen -t rsa -b 4096 -C "lucas.maurice@outlook.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
echo "Now go in your GitHub Settings and copy/paste your SSH key."
