#!/bin/sh

BLUE='\033[0;34m'
WHITE='\033[0;37m'
RED='\033[0;31m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'

echo -e "************************************************************************"
echo -e "          ${CYAN}ECE 353 - Introduction to Microprocessor Systems${WHITE}"
echo -e "************************************************************************"
echo -e
echo -e
echo -e "Ensure that the following steps are complete before running the script:"
echo -e "  1. ModusToolbox 2.4.0 installation. ${RED}Ensure that it is installed for"
echo -e "     only current user and not all users${WHITE}"
echo -e "  2. ModusToolbox 2.4.1 patch installation"
echo -e "  3. GitLab account set up. Ensure that you have a valid GitLab ID"
echo -e
echo -e
echo -e "${ORANGE}Please reach out if you need help in any of these steps. The setup"
echo -e "script will not work if you have not completed these steps successfully${WHITE}"
echo -e
echo -e
read -p "Do you want to proceed? (y/n)" yn

case $yn in 
    [y/Y] ) echo -e;;
    [n/N] ) echo -e "${ORANGE}[STATUS] Exiting setup script${WHITE}";
        exit;;
    * ) echo -e "${RED}[ERROR] Invalid response received${WHITE}";
        exit 1;;
esac

echo -e "${GREEN}[STATUS] Proceeding forward with the setup script${WHITE}"
echo -e
echo -e "[STATUS] Creating manifest file"

read -p "Are you using a CAE machine? (y/n)" cae

cat > $HOME/.modustoolbox/manifest.loc <<EOF
https://raw.githubusercontent.com/rakshith-mb/ece-353-mtb-super-manifest/main/ece-353-mtb-super-manifest.xml
EOF

if [ "$cae" = "y" ] || [ "$cae" = "Y" ];
then
    username=$(whoami)
    echo -e "[STATUS] Creating manifest file in the C Drive of CAE machine"
    mkdir -p /c/Users/$username/.modustoolbox && cp $HOME/.modustoolbox/manifest.loc /c/Users/$username/.modustoolbox/manifest.loc
fi

echo -e "${GREEN}[STATUS] Manifest file creation successful${WHITE}"
echo -e

echo -e "[STATUS] Configuring GitLab token for cloning repo"

read -p 'Please enter GitLab username: ' USERNAME
read -p 'Please enter GitLab Personal Access Token: ' PAT
git config --global credential."https://git.doit.wisc.edu".helper store --replace-all 
GITHUB_USER=$USERNAME 
GITHUB_TOKEN=$PAT
echo "https://$GITHUB_USER:$GITHUB_TOKEN@git.doit.wisc.edu" >> ~/.git-credentials

echo -e "${GREEN}[STATUS] GitLab token configured successfully${WHITE}"
echo -e

echo -e "You should now be able to access ECE 353 BSPs and MTB applications from"
echo -e "within ModusToolbox IDE"
echo -e
echo -e
echo -e "${CYAN}[STATUS] Setup script complete${WHITE}"
