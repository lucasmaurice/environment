#/bin/bash
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

LUCAS=true
LUCASPARAM=true
HELP=false
while getopts "ahln" opt; do
	case "$opt" in
	        a)      INSTALL_AUTO=true ;;
                n)      LUCAS=false ; LUCASPARAM=true ;;
                h)      echo "SYNOPSIS:"
                        echo "DJLs workspace deployment [options]"
                        echo "OPTIONS:"
                        echo " -h  Show this help synopsis"
                        echo " -n  Install for people who are not Lucas"
                        HELP=true  ;;
	esac
done
shift $(( OPTIND - 1 ))

if ! $HELP 
then
	if ! $LUCASPARAM
	then
		read -e -p "
		Are you Lucas? [Y/n] " YN

		if [[ $YN == "y" || $YN == "Y" || $YN == "" ]]; then
			LUCAS=true
		fi
	fi

	if $LUCAS ; then
		echo "Welcome Lucas!"
		GITUSER="Lucas Maurice"
		GITEMAIL="lucas.maurice@outlook.com"
	else
		echo "Welcome _NOT_ Lucas!"
		read -e -p "Enter your git name:`echo $'\n> '`" GITUSER
		read -e -p "Enter your git email:`echo $'\n> '`" GITEMAIL
	fi

	echo -e "${GREEN}Deployment:${NC} Update Aptitude packages."
	sudo apt update -qq
	sudo apt-get -f install -y -qq
	sudo apt upgrade -y -qq

	# Divers tools
	echo -e "${GREEN}Deployment:${NC} Install Divers Tools"
	sudo apt install git nmap tree htop zsh tmux vim -y -qq

	#CONFIGURE GITHUB
	echo -e "${GREEN}Deployment:${NC} Configure Git"
	git config --global user.name $GITUSER
	git config --global user.email $GITEMAIL

	#NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
	if [ ! -f ~/.ssh/id_rsa ]; then
	    echo -e "${GREEN}Deployment:${NC} Create SSH Key for Git"
	    ssh-keygen -t rsa -b 4096 -C $GITEMAIL
	    eval "$(ssh-agent -s)"
	    ssh-add ~/.ssh/id_rsa
	fi

	# Settings ZSH
	if [ ! -d "~/.oh-my-zsh" ]; then
		echo -e "${GREEN}Deployment:${NC} Configure ZSH"
		sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	fi
fi

