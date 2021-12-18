#!/bin/bash
### multi arch support
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install apt-utils aptitude

### basic
sudo aptitude install -y build-essential gcc g++ cmake gdb python pkg-config sudo cppman man-db exfat-fuse exfat-utils ffmpeg subversion fcitx  fcitx-googlepinyin fonts-wqy-microhei gzip unzip unrar bzip2 tar zlib1g-dev lib32z1 liblz4-tool xz-utils tmux mtools  parted libudev-dev libusb-1.0-0-dev autoconf autotools-dev libsigsegv2 m4 intltool libdrm-dev sed make binutils patch bc gawk perl python python-matplotlib aria2 curl wget sync cpio libncurses5 libqt4-dev libglib2.0-dev libgtk2.0-dev libglade2-dev asciidoc w3m dblatex graphviz libc6:i386 libssl-dev expect fakeroot diffstat texinfo uuid-dev locales bison pkg-config ncurses-dev gperf lib32gcc-7-dev  g++-7  libstdc++-7-dev bilson flex liblz4-tool time automake-1.15 libc6-dev-i386 lib32ncurses-dev gnupg gcc-multilib g++-multilib x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc fontconfig libtool libudev-dev

### adb
sudo aptitude install -y adb android-sdk-platform-tools-common

### arm toolchain
sudo aptitude install -y gcc-arm-linux-gnueabihf u-boot-tools device-tree-compiler python-linaro-image-tools linaro-image-tools mtd-utils

### vlc
sudo aptitude install -y vlc

### v4l2
sudo aptitude install -y v4l-utils

### guvcview
sudo aptitude install -y guvcview

### imagemagick
sudo aptitude install -y imagemagick

### sqlite
sudo aptitude install -y sqlite3 sqlitebrowser

### typora
### not free after Beta version
#wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
#sudo add-apt-repository 'deb https://typora.io/linux ./'
#sudo apt install -y typora

### pdfgrep
sudo aptitude install -y pdfgrep

### fzf
sudo aptitude install -y fzf

### deepin wechat
wget -O- https://deepin-wine.i-m.dev/setup.sh | sh
sudo aptitude install -y deepin.com.wechat

### bing wallpaper
#sudo add-apt-repository ppa:whizzzkid/bingwallpaper
#sudo apt-get update
#sudo apt-get install bingwallpaper

### nfs server
sudo aptitude install nfs-kernel-server
printf "$HOME/Downloads\t 192.168.*.*(rw,sync,no_root_squash,insecure)" | sudo tee -a /etc/exports
sudo nfsd restart
# sudo showmount -e

### telnet server
sudo aptitude install -y xinetd telnetd
printf "telnet stream tcp nowait telnetd /usr/sbin/tcpd /usr/sbin/in.telnetd\ndefaults\n{\ninstances=60\nlog_type=SYSLOG authpriv\nlog_on_success=HOST PID\nlog_on_failure=HOST\ncps=25 30\n}\nincludedir /etc/xinetd.d\n" | sudo tee -a /etc/xinetd.conf # man xinetd.conf
printf "service telnet\n{\ndisable = no\nflags = REUSE\nsocket_type = stream\nwait = no\nwait = no\nserver = /usr/sbin/in.telnetd\nserver = /usr/sbin/in.telnetd\n}\n" | sudo tee -a /etc/xinetd.d/telnet # man xinetd.conf
systemctl restart xinetd

### samba server
sudo aptitude install -y samba
sudo smbpasswd -a $USER
printf '[$USER]\npath=$HOME/Downloads\nwritable=yes\nbrowseable=yes\nsecurity=share\n' | sudo tee -a /etc/samba/smb.conf # man smb.conf
systemctl restart smbd

### samba client
sudo aptitude install -y cifs-utils
# sudo mount -t cifs -o user=xxx,pass=xxx  //xxx.xxx.xxx.xxx/临时文件 /mnt

### ssh
sudo aptitude install -y openssh-client
ssh-keygen
cp home/.ssh/config ~/.ssh

### sshfs
sudo aptitude install -y sshfs

### permission
sudo usermod -aG docker $USER
sudo usermod -aG dialout $USER
sudo usermod -aG plugdev $USER

### docker

## for Debian / Red Hat
curl -sSL https://get.docker.com/ | sh

## for Arch Linux
# sudo pacman -S docker

sudo usermod -aG docker $USER
sudo mkdir -p /etc/docker
sudo cp etc/docker/daemon.json /etc/docker
sudo systemctl daemon-reload
systemctl enable docker
systemctl restart docker
docker/docker_action.sh  build

### bash
sudo ln -sf /bin/bash /bin/sh
cp home/.bash_aliases ~/
cp home/.bashrc ~/
cp home/.profile ~/

### vim
sudo aptitude install -y vim
cp home/.vimrc ~/

### git
sudo aptitude install -y git
cp home/.gitconfig ~/

### minicom
sudo aptitude install -y minicom
cp home/.minirc.dfl ~/

## tmux
sudo aptitude install -y tmux

## vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo aptitude install apt-transport-https
sudo aptitude update
sudo aptitude install code # or code-insiders

## repo
repo_path=~/Tools/repo
mkdir -p $repo_path
wget  https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -O $repo_path/repo
chmod +x $repo_path/repo
echo "export PATH=\$PATH:$repo_path" >> ~/.bashrc
echo 'export REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/"' >> ~/.bashrc
