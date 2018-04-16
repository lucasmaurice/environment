#!/bin/bash
THE_PATH="/usr/local/jetbrains-toolbox"
THE_ZIP="jetbrains-toolbox-1.8.3678.tar.gz"
THE_URL="https://download.jetbrains.com/toolbox/$THE_ZIP"

GREEN='\033[1;32m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== Install Jetbrains Toolbox =====${NC}"

echo -e "${GREEN}Downloading${NC}"
sudo wget -P $THE_PATH $THE_URL

echo -e "${GREEN}Unzipping${NC}"
sudo tar xfz ${THE_PATH}/${THE_ZIP} -C ${THE_PATH} --verbose
sudo rm ${THE_PATH}/${THE_ZIP}

UNZIPPED_DIR=$(ls -d $THE_PATH/*/)
echo -e "${GREEN}DIR: ${NC} $UNZIPPED_DIR"
echo -e "${GREEN}Fixing rights${NC}"

sudo chmod 755 $UNZIPPED_DIR -R
sudo chown $SUDO_USER:$SUDO_USER $UNZIPPED_DIR -R

echo -e "${GREEN}Installing${NC}"

${UNZIPPED_DIR}jetbrains-toolbox & echo -e "${BLUE}===== END -- Install Jetbrains Toolbox =====${NC}"
