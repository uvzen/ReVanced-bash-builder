#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN="\e[32m"
WHITE="\e[97m"
NC='\033[0m'
file="Patch-android.sh"
	printf '%b\n' "${RED}#-------------------------#${NC}"
	printf '%b\n' "${RED}#                         #${NC}"
	printf '%b\n' "${RED}#    Updater created by   #${NC}"
	printf '%b\n' "${RED}#          uvzen          #${NC}"
	printf '%b\n' "${RED}#                         #${NC}"
	printf '%b\n' "${RED}#-------------------------#${NC}"

if [[ -f "$file" ]]; then
	printf '%b\n' "${YELLOW}Deleting old file${NC}"
	rm "$file"
	printf '%b\n' "${CYAN}Done${NC}";
	printf '%b\n' "${YELLOW}Downloading script from github...${NC}"
	wget https://github.com/uvzen/ReVanced-bash-builder/releases/download/scripts/Patch-android.sh
	printf '%b\n' "${CYAN}Done${NC}";
	chmod +x Patch-android.sh
	sleep 2
	printf '%b\n' "${YELLOW}Running a new script...${NC}";
	sleep 3
	bash Patch-android.sh
fi
