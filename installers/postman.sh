#!/bin/bash
THE_PATH="/usr/local/Postman"
THE_ZIP="Postman-linux-x64.tar.gz"
THE_URL="https://dl.pstmn.io/download/latest/linux64"

GREEN='\033[1;32m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}===== Install Postman =====${NC}"

echo -e "${GREEN}Downloading${NC}"
sudo mkdir ${THE_PATH}
sudo wget $THE_URL --output-document=${THE_PATH}/${THE_ZIP}

echo -e "${GREEN}Unzipping${NC}"
sudo tar xfz ${THE_PATH}/${THE_ZIP} -C ${THE_PATH} --verbose
sudo rm ${THE_PATH}/${THE_ZIP}

UNZIPPED_DIR=$(ls -d $THE_PATH/*/)
echo -e "${GREEN}DIR: ${NC} $UNZIPPED_DIR"
echo -e "${GREEN}Fixing rights${NC}"

sudo chmod 755 $UNZIPPED_DIR -R
sudo chown $SUDO_USER:$SUDO_USER $UNZIPPED_DIR -R

echo -e "${GREEN}Installing${NC}"

${UNZIPPED_DIR}Postman & echo -e "${BLUE}===== END -- Install Postman =====${NC}"
