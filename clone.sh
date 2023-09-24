#!/bin/sh

BLUE='\033[0;34m'
WHITE='\033[0;37m'
RED='\033[0;31m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'

# team02/ece353-mtb-team02-submit-app.git

GITLAB_GROUP_LINK="https://git.doit.wisc.edu/engr/ece/cmpe_courses/ece-353-student-subgroup/"

PROJECT_HEXFILE="./build/ECE353-BSP/Debug/ece353-mtb-init-app.hex"

REPOS_DIR="./ece353-submissions/repos/"
HEX_DIR="./ece353-submissions/hex/"
LOGS_DIR="./ece353-submissions/logs/"

REPO_FAIL_FILENAME="${LOGS_DIR}repo_failure.log"
REPO_SUCCESS_FILENAME="${LOGS_DIR}repo_success.log"

BUILD_FAIL_FILENAME="${LOGS_DIR}build_failure.log"
BUILD_SUCCESS_FILENAME="${LOGS_DIR}build_success.log"

if [ "$1" = "c" ]; then
    echo -e "${ORANGE}[STATUS] Cleaning submissions directory for fresh start${WHITE}"
    rm -rf ./ece353-submissions/
    echo -e "${GREEN}[STATUS] Clean complete${WHITE}"
fi


echo -e "************************************************************************"
echo -e "          ${CYAN}ECE 353 - Introduction to Microprocessor Systems${WHITE}"
echo -e "************************************************************************"
echo -e
echo -e
echo -e "This script clones all the team repos, builds the project and copies the"
echo -e "built hex files over to another directory. To ensure fairness, all the"
echo -e "projects are cloned first and then built"
echo -e
echo -e

mkdir -p $REPOS_DIR
mkdir -p $HEX_DIR
mkdir -p $LOGS_DIR

echo "File lists the teams without a valid repo:" > "$REPO_FAIL_FILENAME"
echo "File lists the teams with a valid repo:" > "$REPO_SUCCESS_FILENAME"

echo "File lists the teams with a build failure:" > "$BUILD_FAIL_FILENAME"
echo "File lists the teams with a successful build:" > "$BUILD_SUCCESS_FILENAME"

read -p "Provide the number of teams: " TEAM_CNT

echo -e
echo -e
echo -e "${CYAN}[STATUS] Cloning submission repos${WHITE}"
echo -e
echo -e

if [[ $TEAM_CNT =~ ^[0-9]+$ ]]; then
    for ((i = 1; i <= TEAM_CNT; i++)); do

        if [ ${#i} -eq 1 ]; then
            temp="0$i"
        else
            temp="$i"
        fi

        echo -e "${CYAN}[STATUS] Cloning repo of Team$temp${WHITE}"
        url="${GITLAB_GROUP_LINK}team${temp}/ece353-mtb-team${temp}-submit-app.git"
        git clone "$url" ${REPOS_DIR}Team$temp

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[STATUS] Cloning repo of Team$temp successful${WHITE}"
            echo "Team${temp}" >> "$REPO_SUCCESS_FILENAME"
        else
            echo -e "${RED}[ERROR] Cloning repo of Team$temp failed${WHITE}"
            echo "Team${temp}" >> "$REPO_FAIL_FILENAME"
        fi
        echo -e
    done

    echo -e
    echo -e
    echo -e "${GREEN}[STATUS] Clone complete. Check the logs for the results${WHITE}"
    echo -e
    echo -e
    echo -e "${CYAN}[STATUS] Building the projects${WHITE}"
    echo -e
    echo -e

    for ((i = 1; i <= TEAM_CNT; i++)); do

        if [ ${#i} -eq 1 ]; then
            temp="0$i"
        else
            temp="$i"
        fi

        echo -e "${CYAN}[STATUS] Building the project of Team$temp${WHITE}"
        cd ${REPOS_DIR}Team$temp

        if [ $? -eq 0 ]; then
            make getlibs
            make build -j16
            cd -
            cp ./${REPOS_DIR}Team$temp/$PROJECT_HEXFILE ${HEX_DIR}Team$temp.hex
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}[STATUS] Hex file of Team$temp successfully moved${WHITE}"
                echo "Team${temp}" >> "$BUILD_SUCCESS_FILENAME"
            else
                echo -e "${RED}[ERROR] Building repo of Team$temp failed${WHITE}"
                echo "Team${temp}" >> "$BUILD_FAIL_FILENAME"
            fi
        else
            echo -e "${RED}[ERROR] Building repo of Team$temp failed${WHITE}"
            echo "Team${temp}" >> "$BUILD_FAIL_FILENAME"
        fi
        echo -e
    done

    echo -e
    echo -e
    echo -e "${GREEN}[STATUS] Hex files generated and moved${WHITE}"
    echo -e
    echo -e
    echo -e "${GREEN}[STATUS] Script complete!${WHITE}"
    echo -e
    echo -e
else
    echo -e "${RED}[ERROR] Invalid input. Please enter a valid number of teams${WHITE}"
fi
