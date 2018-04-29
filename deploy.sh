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
	echo -e "${GREEN}Deployment:${NC} Update Aptitude packages."
	sudo apt updat
	sudo apt-get -f install -y -qq
	sudo apt upgrade -y -qq

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

	# SPOTIFY
	if hash spotify 2>/dev/null; then
	    echo -e "${GREEN}Deployment:${NC} Spotify already installed..."
	else
	    echo -e "${GREEN}Deployment:${NC} Install Spotify"
	    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
	    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
	    sudo apt-get update -qq
	    sudo apt-get install spotify-client -y -qq
	fi

	# GOOGLE CHROME
	if hash google-chrome 2>/dev/null; then
	    echo -e "${GREEN}Deployment:${NC} Google Chrome already installed..."
	else
	    echo -e "${GREEN}Deployment:${NC} Install Google Chrome"
	    sudo apt install -y libxss1 libappindicator1 libindicator7
	    wget -P temp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	    sudo dpkg -i temp/google-chrome-stable_current_amd64.deb
	    rm -R temp
	fi

	# Divers tools
	echo -e "${GREEN}Deployment:${NC} Install Divers Tools"
	sudo apt install git nmap tree htop zsh tmux -y -qq

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

	#CONFIGURE GITHUB
	echo -e "${GREEN}Deployment:${NC} Configure Git"
	git config --global user.name "Lucas Maurice"
	git config --global user.email "lucas.maurice@outlook.com"

	#NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
	if [ ! -f ~/.ssh/id_rsa ]; then
	    echo -e "${GREEN}Deployment:${NC} Create SSH Key for Git"
	    ssh-keygen -t rsa -b 4096 -C "lucas.maurice@outlook.com"
	    eval "$(ssh-agent -s)"
	    ssh-add ~/.ssh/id_rsa
	fi

	# Settings ZSH
	if [! -d "~/.oh-my-zsh" ]; then
		echo -e "${GREEN}Deployment:${NC} Configure ZSH"
		sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	fi
fi
