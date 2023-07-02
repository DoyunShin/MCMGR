#!/bin/bash
# mcmgr (setup) - Minecraft Server Manager

# ROOT CHECK
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
else if [ $(sudo -n uptime 2>&1|grep "load"|wc -l) -eq 0 ]
  then echo "Please run as root or sudoers"
  exit
fi

logo() {
  printf "███╗   ███╗ ██████╗███╗   ███╗ ██████╗ ██████╗ \n"
  printf "████╗ ████║██╔════╝████╗ ████║██╔════╝ ██╔══██╗\n"
  printf "██╔████╔██║██║     ██╔████╔██║██║  ███╗██████╔╝\n"
  printf "██║╚██╔╝██║██║     ██║╚██╔╝██║██║   ██║██╔══██╗\n"
  printf "██║ ╚═╝ ██║╚██████╗██║ ╚═╝ ██║╚██████╔╝██║  ██║\n"
  printf "╚═╝     ╚═╝ ╚═════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝\n"
}

install_deb() {
  printf "Installing dependencies for Debian/Ubuntu...\n"
  sudo apt update
  printf "Installing Java...\n"
  sudo apt install -y openjdk-17-jdk-headless jq
}

install_rhel() {
  printf "Installing dependencies for RedHat/CentOS...\n"
  sudo yum update
  sudo yum install -y curl jq
  printf "Installing Java...\n"
  curl -L https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm -o /tmp/jdk-17_linux-x64_bin.rpm
  sudo yum localinstall -y /tmp/jdk-17_linux-x64_bin.rpm
  rm -f /tmp/jdk-17_linux-x64_bin.rpm
}

yn() {
  read -p " [y/n] " yn
  case $1 in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes or no.";;
  esac
}

main() {
  printf "\n"
  printf "Minecraft Server Manager SETUP\n"
  printf "\n"
  printf "This script will install the Minecraft Server Manager (mcmgr).\n"

  printf "Do you want to continue?"
  if ! yn; then
    printf "Aborting...\n"
    exit
  fi 

  printf "\n"
  if [ -f /etc/debian_version ]; then
    install_deb
  elif [ -f /etc/redhat-release ]; then
    install_rhel
  else
    printf "Unsupported OS. Aborting...\n"
    exit
  fi

  printf "\n"
  cp mcmgr.sh /usr/local/bin/mcmgr
  chmod +x /usr/local/bin/mcmgr

  cp mcmgconf /etc/mcmgconf
  chmod 777 /etc/mcmgconf

  

  
}