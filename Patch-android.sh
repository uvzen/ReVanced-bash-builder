#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN="\e[32m"
WHITE="\e[97m"
NC='\033[0m'
ytversion=17.36.37
ytmversion=5.26.52
ttversion=9.62.0
rtversion=2022.38.0
ttkversion=26.5.1
updater_file="update-android.sh"
get_latest_version_info() 
{
    printf '%b\n' "${BLUE}Obtaining information about the latest version${NC}"
    revanced_cli_version=$(curl -s -L https://github.com/revanced/revanced-cli/releases/latest | awk 'match($0, /v([0-9].*[0-9])/) {print substr($0, RSTART, RLENGTH)}' | awk -F'/' 'NR==1 {print $1}')
    revanced_cli_version=${revanced_cli_version#v}
    revanced_patches_version=$(curl -s -L https://github.com/revanced/revanced-patches/releases/latest | awk 'match($0, /v([0-9].*[0-9])/) {print substr($0, RSTART, RLENGTH)}' | awk -F'/' 'NR==1 {print $1}')
    revanced_patches_version=${revanced_patches_version#v}
    revanced_integrations_version=$(curl -s -L https://github.com/revanced/revanced-integrations/releases/latest | awk 'match($0, /v([0-9].*[0-9])/) {print substr($0, RSTART, RLENGTH)}' | awk -F'/' 'NR==1 {print $1}')
    revanced_integrations_version=${revanced_integrations_version#v}
    for i in \
        "revanced_cli_version=$revanced_cli_version" \
        "revanced_patches_version=$revanced_patches_version" \
        "revanced_integrations_version=$revanced_integrations_version"; do
        printf '%b\n' "${YELLOW}$i${NC}"
    done
}
rm_old()
{
	rm -rf /data/data/com.termux/files/usr/bin/aapt2
	rm -rf packages/revanced-cli*.jar
	rm -rf packages/revanced-patches*.jar
	rm -rf packages/app-release-unsigned.apk
	printf '%b\n' "${RED}Old packages have been removed${NC}"
}
download_needed() 
{
	# number
    n=0
    printf '%b\n' "${BLUE}Downloading revanced-cli, revanced-patches and revanced-integrations${NC}"
    for i in \
        wget https://github.com/revanced/revanced-cli/releases/download/v$revanced_cli_version/$cli_filename \
        wget https://github.com/revanced/revanced-patches/releases/download/v$revanced_patches_version/$patches_filename \
        wget https://github.com/revanced/revanced-integrations/releases/download/v$revanced_integrations_version/$integrations_filename \
        wget https://github.com/uvzen/ReVanced-bash-builder/releases/download/APPS/aapt2 \
        ; do
        n=$(($n+1))	
        printf '%b\n' "${CYAN}$n) ${YELLOW}Downloading $i${NC}"
        $downloader $i
    done
    mv aapt2 /data/data/com.termux/files/usr/bin
    mv revanced-cli-*.jar packages/
    mv revanced-patches-*.jar packages/
    mv app-release-unsigned.apk packages/

}
checker()
{
	get_latest_version_info
	rm_old
	cli_filename=revanced-cli-$revanced_cli_version-all.jar
	patches_filename=revanced-patches-$revanced_patches_version.jar
	integrations_filename=app-release-unsigned.apk
	# downloader
	if [ -z "$downloader" ] && [ "$(command -v curl)" ]; then
    	downloader="curl -qLJO"
	elif [ -z "$downloader" ] && [ "$(command -v wget)" ]; then
 	   downloader="wget"
	fi
	download_needed

}

ytpatch()
{
	printf '%b\n' "${BLUE}Removing old ReVanced YouTube apk if it exists...${NC}"
	rm -rf builds/ReVanced-*.apk
	printf '%b\n' "${YELLOW}Patching YouTube app...${NC}";
	java -jar packages/revanced-cli*.jar -a apk/YouTube.apk -o ReVanced.apk -b packages/revanced-patches*.jar -m packages/app-release-unsigned.apk --custom-aapt2-binary /data/data/com.termux/files/usr/bin/aapt2
	printf '%b\n' "";
	printf '%b\n' "${CYAN}Done${NC}";
	printf '%b\n' "";
	ytname
	printf '%b\n' "${YELLOW}Copying YouTube ReVanced to internal memory...${NC}";
	cp builds/ReVanced-*.apk /data/data/com.termux/files/home/storage/shared
	printf '%b\n' "${YELLOW}Done${NC}";
	if [[ -d "revanced-cache" ]]; then
		rm -rf revanced-cache/
	fi
	patcher
}

ytmpatch()
{
	printf '%b\n' "${BLUE}Removing old ReVanced YouTube Music apk if it exists...${NC}"
	rm -rf builds/ReVancedMusic*.apk
	printf '%b\n' "${YELLOW}Patching YouTube Music app...${NC}";
	java -jar packages/revanced-cli*.jar -a apk/YouTubeMusic.apk -o ReVancedMusic.apk -b packages/revanced-patches*.jar -m packages/app-release-unsigned.apk --custom-aapt2-binary /data/data/com.termux/files/usr/bin/aapt2
	printf '%b\n' "";
	printf '%b\n' "${CYAN}Done";
	ytmname
	printf '%b\n' "${YELLOW}Copying YouTube Music ReVanced to internal memory...${NC}";
	cp builds/ReVancedMusic-*.apk /data/data/com.termux/files/home/storage/shared
	printf '%b\n' "${YELLOW}Done${NC}";
	if [[ -d "revanced-cache" ]]; then
		rm -rf revanced-cache/
	fi
	patcher
}

ttpatch()
{
	printf '%b\n' "${BLUE}Removing old ReVanced Twitter apk if it exists...${NC}"
	rm -rf builds/Twitter-*.apk
	printf '%b\n' "${YELLOW}Patching Twitter app...${NC}";
	java -jar packages/revanced-cli*.jar -a apk/Twitter.apk -o Twitter.apk -b packages/revanced-patches*.jar -m packages/app-release-unsigned.apk --custom-aapt2-binary /data/data/com.termux/files/usr/bin/aapt2
	printf '%b\n' "";
	printf '%b\n' "${CYAN}Done${NC}";
	printf '%b\n' "";
	ttname
	printf '%b\n' "${YELLOW}Copying Twitter ReVanced to internal memory...${NC}";
	cp builds/Twitter-*.apk /data/data/com.termux/files/home/storage/shared
	printf '%b\n' "${YELLOW}Done${NC}";
	if [[ -d "revanced-cache" ]]; then
		rm -rf revanced-cache/
	fi
	patcher
}

rtpatch()
{
	printf '%b\n' "${BLUE}Removing old ReVanced Reddit apk if it exists...${NC}"
	rm -rf builds/Reddit-*.apk
	printf '%b\n' "${YELLOW}Patching Reddit app...${NC}";
	java -jar packages/revanced-cli*.jar -a apk/Reddit.apk -o Reddit.apk -b packages/revanced-patches*.jar -m packages/app-release-unsigned.apk --custom-aapt2-binary /data/data/com.termux/files/usr/bin/aapt2
	printf '%b\n' "";
	printf '%b\n' "${CYAN}Done${NC}";
	printf '%b\n' "";
	rtname
	printf '%b\n' "${YELLOW}Copying Reddit ReVanced to internal memory...${NC}";
	cp builds/Reddit-*.apk /data/data/com.termux/files/home/storage/shared
	printf '%b\n' "${YELLOW}Done${NC}";
	if [[ -d "revanced-cache" ]]; then
		rm -rf revanced-cache/
	fi
	patcher
}
ttkpatch()
{
	printf '%b\n' "${BLUE}Removing old ReVanced TikTok apk if it exists...${NC}"
	rm -rf builds/TikTok-*.apk
	printf '%b\n' "${YELLOW}Patching TikTok app...${NC}";
	java -jar packages/revanced-cli*.jar -a apk/TikTok.apk -o TikTok.apk -b packages/revanced-patches*.jar -m packages/app-release-unsigned.apk --custom-aapt2-binary /data/data/com.termux/files/usr/bin/aapt2
	printf '%b\n' "";
	printf '%b\n' "${CYAN}Done${NC}";
	printf '%b\n' "";
	ttkname
	printf '%b\n' "${YELLOW}Copying TikTok ReVanced to internal memory...${NC}";
	cp builds/TikTok-*.apk /data/data/com.termux/files/home/storage/shared
	if [[ -d "revanced-cache" ]]; then
		rm -rf revanced-cache/
	fi
	patcher
}
ytname()
{
	mv ReVanced.apk ReVanced-$ytversion-$data.apk
	mv ReVanced-$ytversion-$data.apk builds/
}
ytmname()
{
	mv ReVancedMusic.apk ReVancedMusic-$ytmversion-$data.apk
	mv ReVancedMusic-$ytmversion-$data.apk builds/
}
ttname()
{
	mv Twitter.apk Twitter-$ttversion-patched-$data.apk
	mv Twitter-$ttversion-patched-$data.apk builds/
}
rtname()
{
	mv Reddit.apk Reddit-$rtversion-patched-$data.apk
	mv Reddit-$rtversion-patched-$data.apk builds
}
ttkname()
{
	mv TikTok.apk TikTok-$ttkversion-patched-$data.apk
	mv TikTok-$ttkversion-patched-$data.apk builds/
}
diceroys()
{
	printf '%b\n' "${YELLOW}Checking folders...${NC}";
	if [[ -d "packages" ]]; then
		printf '%b\n' "${BLUE}Packages folder exists${NC}"
	else
		printf '%b\n' "${BLUE}Creating packages folder${NC}"
		mkdir -p packages
	fi
	if [[ -d "apk" ]]; then
		printf '%b\n' "${BLUE}Apk folder exists${NC}"
	else
		printf '%b\n' "${BLUE}Creating apk folder${NC}"
		mkdir -p apk
	fi
	if [[ -d "builds" ]]; then
		printf '%b\n' "${BLUE}Builds folder exists${NC}"
	else
		printf '%b\n' "${BLUE}Creating builds folder${NC}"
		mkdir -p builds
	fi
}
logo()
{
	printf '%b\n' "${RED}#-------------------------#${NC}"
	printf '%b\n' "${RED}#                         #${NC}"
	printf '%b\n' "${RED}#    Script created by    #${NC}"
	printf '%b\n' "${RED}#          uvzen          #${NC}"
	printf '%b\n' "${RED}#                         #${NC}"
	printf '%b\n' "${RED}#-------------------------#${NC}"
}
apk_dowloader()
{
	printf '%b\n' "${YELLOW}Removing YouTube apk if it exists...${NC}"
	rm -rf apk/YouTube.apk
	printf '%b\n' "${YELLOW}Removing YouTube Music apk if it exists...${NC}"
	rm -rf apk/YouTubeMusic.apk
	printf '%b\n' "${YELLOW}Removing Twitter apk if it exists...${NC}"
	rm -rf apk/Twitter.apk
	printf '%b\n' "${YELLOW}Removing Reddit apk if it exists...${NC}"
	rm -rf apk/Reddit.apk
	printf '%b\n' "${YELLOW}Removing TikTok apk if it exists...${NC}"
	rm -rf apk/TikTok.apk
	
    printf '%b\n' "${BLUE}Downloading YouTube, YouTube Music, Twitter, Reddit and TikTok...${NC}"
    curl -qLJO https://github.com/uvzen/ReVanced-bash-builder/releases/download/APPS/YouTube.apk
    mv YouTube.apk apk/
	curl -qLJO https://github.com/uvzen/ReVanced-bash-builder/releases/download/APPS/YouTubeMusic.apk
	mv YouTubeMusic.apk apk/
	curl -qLJO https://github.com/uvzen/ReVanced-bash-builder/releases/download/APPS/Twitter.apk
	mv Twitter.apk apk/
	curl -qLJO https://github.com/uvzen/ReVanced-bash-builder/releases/download/APPS/Reddit.apk
	mv Reddit.apk apk/
	curl -qLJO https://github.com/uvzen/ReVanced-bash-builder/releases/download/APPS/TikTok.apk
	mv TikTok.apk apk/
	printf '%b\n' "${YELLOW}Downloaded${NC}"
}
necessary_files()
{
	echo ""
	echo ""
	printf '%b\n' "${GREEN}NECESSARY FILES${NC}"
	printf '%b\n' "${YELLOW}Select option${NC}";
	printf '%b\n' "${WHITE}1) ${CYAN}Download necessary packages from github${NC}";
	printf '%b\n' "${WHITE}2) ${CYAN}Download necessary apk from github${NC}";
	printf '%b\n' "${WHITE}3) ${CYAN}Back to menu${NC}";
	read wybor2

	if [[ $wybor2 < 1 ]] || [[ $wybor2 > 3 ]]; then
	clear
	printf '%b\n' "${RED}Choose correctly${NC}";
	printf '%b\n' "";
	sleep 0.5
	main
	elif [[ $wybor2 == 1 ]]; then
		checker
		necessary_files
	elif [[ $wybor2 == 2 ]]; then
		apk_dowloader
		necessary_files
	elif [[ $wybor2 == 3 ]]; then
		main
	fi
}
patcher()
{
	echo ""
	echo ""
	printf '%b\n' "${GREEN}APK PATCHER${NC}"

	printf '%b\n' "${YELLOW}Select option${NC}";
	printf '%b\n' "${WHITE}1) ${CYAN}Patch YouTube${NC}";
	printf '%b\n' "${WHITE}2) ${CYAN}Patch YouTube Music${NC}";
	printf '%b\n' "${WHITE}3) ${CYAN}Patch Twitter${NC}";
	printf '%b\n' "${WHITE}4) ${CYAN}Patch Reddit${NC}"
	printf '%b\n' "${WHITE}5) ${CYAN}Patch TikTok${NC}"
	printf '%b\n' "${WHITE}6) ${CYAN}Back to menu${NC}";
	read wybor3

	if [[ $wybor3 < 1 ]] || [[ $wybor3 > 6 ]]; then
		clear
		printf '%b\n' "${RED}Choose correctly${NC}";
		printf '%b\n' "";
		sleep 0.5
		main
	elif [[ $wybor3 == 1 ]]; then
		ytpatch
	elif [[ $wybor3 == 2 ]]; then
		ytmpatch
	elif [[ $wybor3 == 3 ]]; then
		ttpatch
	elif [[ $wybor3 == 4 ]]; then
		rtpatch
	elif [[ $wybor3 == 5 ]]; then
		ttkpatch
	elif [[ $wybor3 == 6 ]]; then
		main
	fi
}
updater()
{
	if [[ -f "$updater_file" ]]; then
		printf '%b\n' "${YELLOW}Running the updater script...${NC}"
		sleep 3
		bash update-android.sh
	else
		printf '%b\n' "${YELLOW}Downloading a updater script...${NC}"
		wget https://github.com/uvzen/ReVanced-bash-builder/releases/download/scripts/update-android.sh
		printf '%b\n' "${CYAN}Done${NC}";
		chmod +x update-android.sh
		sleep 2
		printf '%b\n' "${YELLOW}Running a updater script...${NC}"
		sleep 3
		bash update-android.sh
	fi
}
clear
logo
diceroys
main()
{
	data=`date +%d.%m.%Y`
	#echo $data
	#versions
	if [[ -d "revanced-cache" ]]; then
		rm -rf revanced-cache/
	fi
	echo ""
	echo ""
	printf '%b\n' "${GREEN}MAIN MENU${NC}"

	printf '%b\n' "${YELLOW}Select option${NC}";
	printf '%b\n' "${WHITE}1) ${CYAN}Download necessary files${NC}"
	printf '%b\n' "${WHITE}2) ${CYAN}APK Patcher${NC}";
	printf '%b\n' "${WHITE}3) ${CYAN}Update script${NC}";
	printf '%b\n' "${WHITE}4) ${CYAN}Exit${NC}";
	read wybor1;

	if [[ $wybor1 < 1 ]] || [[ $wybor1 > 4 ]]; then
		clear
		printf '%b\n' "${RED}Choose correctly${NC}";
		printf '%b\n' "";
		sleep 0.5
		main
	elif [[ $wybor1 == 1 ]]; then
		necessary_files
	elif [[ $wybor1 == 2 ]]; then
		patcher
	elif [[ $wybor1 == 3 ]]; then
		updater
	elif [[ $wybor1 == 4 ]]; then
		exit 1;
	fi
}
main
