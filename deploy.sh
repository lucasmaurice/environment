#/bin/bash
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

# Git User
GITUSER="Lucas Maurice"
GITEMAIL="lucas.maurice@outlook.com"

# Packages to install
PACKAGES=(
    ack
    autoconf
    automake
    boot2docker
    ffmpeg
    gettext
    gifsicle
    git
    graphviz
    hub
    imagemagick
    jq
    libjpeg
    libmemcached 
    lynx
    markdown
    memcached
    mercurial
    npm
    pkg-config
    postgresql
    python
    python3
    pypy
    rabbitmq
    rename
    ssh-copy-id
    terminal-notifier
    the_silver_searcher
    tmux
    tree
    vim
    wget
	zsh
	nmap
	htop
)

CASKS=(
    gpgtools
    iterm2
    slack
	caffeine
	docker
	transmission
	1password
	visual-studio-code
	spotify
	dockey
	postman
)

PYTHON_PACKAGES=(
    virtualenv
    virtualenvwrapper
	ansible
	asn1crypto
	bcrypt
	cffi
	cryptography
	idna
	Jinja2
	MarkupSafe
)

# Filter by system type
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "${GREEN}Begin:${NC} Run deployment as Linux system."

	# Prepare
	echo -e "${GREEN}Deployment:${NC} Update Aptitude packages."
	sudo apt update -qqq
	sudo apt-get -f install -y -qqq
	sudo apt upgrade -y -qqq

	# Divers tools
	echo -e "${GREEN}Deployment:${NC} Installing Divers Tools"
	sudo apt install git nmap tree htop zsh tmux vim -y -qqq

	#NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
	if [ ! -f ~/.ssh/id_rsa ]; then
		echo -e "${GREEN}Deployment:${NC} Create SSH Key for Git"
		ssh-keygen -t rsa -b 4096 -C $GITEMAIL
		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/id_rsa
	fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "${GREEN}Begin:${NC} Run deployment as Mac OS system."

	# Prepare
	if test ! $(which brew); then
		echo "${GREEN}Deployment:${NC} Installing Brew."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# Updating Brew Packages
	echo "${GREEN}Deployment:${NC} Updating Brew packages."
	brew update
	
	# Installing MacOS Command Line Tools
	echo -e "${GREEN}Deployment:${NC} Installing MacOS Command Line Tools"
	xcode-select --install

	# Accept licences
	echo -e "${GREEN}Deployment:${NC} Accept licences"
	sudo xcodebuild -license

	# Installing GNU core utilities (those that come with OS X are outdated)
	echo -e "${GREEN}Deployment:${NC} Installing GNU core utilities"
	brew tap homebrew/dupes
	brew install coreutils
	brew install gnu-sed --with-default-names
	brew install gnu-tar --with-default-names
	brew install gnu-indent --with-default-names
	brew install gnu-which --with-default-names
	brew install gnu-grep --with-default-names

	# Divers tools
	echo -e "${GREEN}Deployment:${NC} Installing Divers Tools"
	brew install ${PACKAGES[@]}

	# Cleaning up
	echo -e "${GREEN}Deployment:${NC} Cleaning Brew"
	brew cleanup

	# Installing Cask
	echo -e "${GREEN}Deployment:${NC} Installing Cask"
	brew install caskroom/cask/brew-cask

	# Installing Cask Apps
	echo -e "${GREEN}Deployment:${NC} Installing Cask Apps"
	brew cask install ${CASKS[@]}

	# Installing Python Apps
	echo -e "${GREEN}Deployment:${NC} Installing Python Apps"
	sudo pip install ${PYTHON_PACKAGES[@]}

	#NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
	if [ ! -f ~/.ssh/id_rsa ]; then
		echo -e "${GREEN}Deployment:${NC} Create SSH Key for Git"
		ssh-keygen -t rsa -b 4096 -C $GITEMAIL
		eval "$(ssh-agent -s)"
		ssh-add -K ~/.ssh/id_rsa
	fi
else
        echo "${YELLOW}Error:${NC} OS is not supported."
fi


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

# CONFIGURE GITHUB
echo -e "${GREEN}Deployment:${NC} Configure Git"
git config --global user.name $GITUSER
git config --global user.email $GITEMAIL

# DEPLOYIMG ZSH
echo -e "${GREEN}Deployment:${NC} Configure ZSH"
if [ ! -d ~/.oh-my-zsh ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
chsh -s /bin/zsh

# 	# WALLPAPERS
# 	echo -e "${GREEN}Deployment:${NC} Installing wallpapers"
# 	cp -fr ./wallpapers/* ~/Pictures/

# 	if $INSTALL_AUTO
# 	then
# 		# AUTO DEPLOYMENT - INSTALL
# 		echo -e "${GREEN}Deployment:${NC} Installation of contents in ./installers."
# 		for f in `ls ./installers/*.sh `
# 		do
# 		    if [ ! -d ${f} ]; then
# 		        echo -e "${RED}Installation:${NC} $(echo $f | cut --delimiter='/' --fields=3 | cut --delimiter='.' --fields=1)"
# 		        ${f}
# 		    fi
# 		done
# 	fi
