#/bin/bash
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

INSTALL_AUTO=false
HELP=false
while getopts "ahrv:x" opt; do
	case "$opt" in
		a)	INSTALL_AUTO=true ;;
		h)	echo "SYNOPSIS:"
			echo "DJLs workspace deployment [options]"
			echo "OPTIONS:"
			echo " -a  automated installation in folders"
			echo " -h  show this help synopsis"
			HELP=true  ;;
	esac
done
shift $(( OPTIND - 1 ))

if ! $HELP
then
	#ASK FOR YOUR GITHUB CREDENTIALS
	echo "Write your name:"
	read namePerson
	echo "Write your github email:"
	read email

	##INSTALLATION
	echo -e "${GREEN}Deployment:${NC} Update Aptitude packages."
	sudo apt update -qqq
	sudo apt-get -f install -y -qqq
	sudo apt upgrade -y -qqq

	# ATOM
	if hash atom 2>/dev/null; then
	    echo -e "${GREEN}Deployment:${NC} Atom already installed..."
	else
	    echo -e "${GREEN}Deployment:${NC} Install Atom"
	    wget -P temp https://atom.io/download/deb
	    sudo dpkg -i temp/deb
	    rm -R temp
	fi
	export EDITOR=atom

	# Divers tools
	echo -e "${GREEN}Deployment:${NC} Install Divers Tools"
	sudo apt install git nmap tree htop zsh tmux vim -y -qqq

	# Slack
	echo -e "${GREEN}Deployment:${NC} Install Slack"
	sudo snap install slack --classic

	# WALLPAPERS
	echo -e "${GREEN}Deployment:${NC} Install wallpapers"
	cp -fr ./wallpapers/* ~/Pictures/

	if $INSTALL_AUTO
	then
		# AUTO DEPLOYMENT - INSTALL
		echo -e "${GREEN}Deployment:${NC} Installation of contents in ./installers."
		for f in `ls ./installers/*.sh `
		do
		    if [ ! -d ${f} ]; then
		        echo -e "${RED}Installation:${NC} $(echo $f | cut --delimiter='/' --fields=3 | cut --delimiter='.' --fields=1)"
		        ${f}
		    fi
		done
		# AUTO DEPLOYMENT - CONFIG
		echo -e "${GREEN}Deployment:${NC} Installation of dotfiles in ./dotfiles"
		for f in `ls ./dotfiles`
		do
		    echo -e "${YELLOW}Config:${NC} $(echo $f | cut --delimiter='/' --fields=3)"
		    if [ -d ./dotfiles/${f} ]; then
		        mkdir -p ~/.${f}
		        cp -f -r ./dotfiles/${f}/* ~/.${f}
		    else
		        cp ./dotfiles/${f} ~/.${f}
		    fi
		done
	fi

	#MAKE SURE EVERY PACKAGE AS ITS DEPENDENCIES
	sudo apt-get -f install	

	#CONFIGURE GITHUB
	echo -e "${GREEN}Deployment:${NC} Configure Git"
	git config --global user.name $namePerson
	git config --global user.email $email

	#NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
	if [ ! -f ~/.ssh/id_rsa ]; then
	    echo -e "${GREEN}Deployment:${NC} Create SSH Key for Git"
	    ssh-keygen -t rsa -b 4096 -C $email 
	    eval "$(ssh-agent -s)"
	    ssh-add ~/.ssh/id_rsa
	fi

	# Settings ZSH
	if [ ! -d "~/.oh-my-zsh" ]; then
		echo -e "${GREEN}Deployment:${NC} Configure ZSH"
		sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	fi
fi
