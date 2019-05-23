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
    minicom
    mtr
    mas
)

CASKS_PACKAGES=(
    iterm2
    caffeine
    docker
    transmission
    1password
    visual-studio-code
    spotify
    dockey
    postman
    tunnelblick
)

PYTHON_PACKAGES=(
    virtualenv
    virtualenvwrapper
    ansible
    molecule
    molecule[docker]
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
    brew install coreutils
    brew install gnu-sed
    brew install gnu-tar
    brew install gnu-indent
    brew install gnu-which

    # Divers tools
    echo "${GREEN}Deployment:${NC} Installing Divers Tools"
    brew install ${PACKAGES[@]}

    # Cleaning up
    echo "${GREEN}Deployment:${NC} Cleaning Brew"
    brew cleanup

    Installing Cask
    echo "${GREEN}Deployment:${NC} Installing Cask"
    # brew install caskroom/cask

    # Installing Cask Apps
    echo "${GREEN}Deployment:${NC} Installing Cask Apps"
    brew cask install --force --require-sha ${CASKS_PACKAGES[@]}

    # Installing Python Apps
    echo "${GREEN}Deployment:${NC} Installing Python Apps"
    pip install ${PYTHON_PACKAGES[@]}

    mas install 1176895641 # Spark
    mas install 441258766  # Magnet
    mas install 1295203466 # Microsoft RDP
    mas install 494803304  # Wifi Explorer
    mas install 1191449274 # Tooth Fairy
    mas install 411643860  # Daisy Disk
    mas install 803453959  # Slack
    mas install 425424353  # The Unarchiver

    #NEXT ARE FOR SSH LOGIN CONFIGURATION ON GITHUB
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo "${GREEN}Deployment:${NC} Create SSH Key for Git"
        ssh-keygen -t rsa -b 4096 -C $GITEMAIL
        eval "$(ssh-agent -s)"
        ssh-add -K ~/.ssh/id_rsa
    fi
else
        echo "${YELLOW}Error:${NC} OS is not supported."
fi


# AUTO DEPLOYMENT - CONFIG
echo "${GREEN}Deployment:${NC} Installation of dotfiles in ./dotfiles"
for f in $(ls ./dotfiles)
do
    echo "${YELLOW}Dotfile:${NC} $(echo $f )"
    if [ ! -d ./dotfiles/${f} ]; then
        cp -f ./dotfiles/${f} ~/.${f}
    fi
done

# CONFIGURE GITHUB
echo "${GREEN}Deployment:${NC} Configure Git"
git config --global user.name $GITUSER
git config --global user.email $GITEMAIL

# DEPLOYIMG ZSH
echo "${GREEN}Deployment:${NC} Configure ZSH"
if [ ! -d ~/.oh-my-zsh ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    sudo chsh -s /bin/zsh $(whoami)
fi

# WALLPAPERS
echo "${GREEN}Deployment:${NC} Installing wallpapers"
cp -fr ./wallpapers/* ~/Pictures/

exec zsh
