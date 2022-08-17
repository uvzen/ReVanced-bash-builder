# About ReVanced bash builder:

A simple bash script written by me that I wrote for myself and placed here so that I can download updates whenever I want. 

#### <ins>This script doesn't have the option to exclude and include specific patches</ins>, because they can be turned on or off in ReVanced settings.

# Requirements:

### Windows user:
- [Git for Windows](https://gitforwindows.org/) or [Linux WSL](https://docs.microsoft.com/en-us/windows/wsl/about) (it will work slower, and need [Zulu JDK 17 64-bit for Linux](https://cdn.azul.com/zulu/bin/zulu17.36.13-ca-jdk17.0.4-linux_amd64.deb))
- [Zulu JDK 17 64-bit for Windows](https://cdn.azul.com/zulu/bin/zulu17.36.13-ca-jdk17.0.4-win_x64.msi)
- Internet connection for download the required packages and applications

During installation Git for Windows, choose the following options:
```
- Add a Git Bash Profile to Windows Terminal
- Git from the command line and also 3rd-party software
- Checkout Windows-style, commit Unix-style endings
- Use Windows' default console window
```
### Linux user
- [Zulu JDK 17 64-bit for Linux](https://cdn.azul.com/zulu/bin/zulu17.36.13-ca-jdk17.0.4-linux_amd64.deb)
- Internet connection for download the required packages and applications

### Android user:
- Installed [Termux APP](https://f-droid.org/en/packages/com.termux/) from [F-droid](https://f-droid.org/en/)
- Internet connection for download the required packages and applications

# How to use


### Windows
1. Create any folder and put the ReVanced-PC.sh script there
2. Run script in 2 ways:
- Launch git shell by right-clicking in an empty folder space and selecting "Git Bash Here", then run script by typing: ```./ReVanced.sh```
- Run script by double-clicking on it
3. When you run the script for the first time, download the necessary packages and applications
4. Enjoy build ReVanced

### Linux
1. Create any folder and put the ReVanced-PC.sh script 
2. Open terminal and run script ```./ReVanced-PC.sh```
3. When you run the script for the first time, download the necessary packages and applications
4. Enjoy build ReVanced

### Android
1. Open Termux app
2. After that, you have to run these commands:
```
pkg update
pkg wget openjdk-17 -y
termux-setup-storage
wget https://github.com/uvzen/ReVanced-bash-builder/releases/download/scripts/ReVanced-android.sh
chmod +x ReVanced-android.sh
```
3. Run script by typing: 
```./ReVanced-android.sh```
4. When you run the script for the first time, download the necessary packages and applications
5. Enjoy build ReVanced on android
