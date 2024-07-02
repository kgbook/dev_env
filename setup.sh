#!/bin/bash

#set -e
#set -x

tool_path=$HOME/tools
linux_wechat_url=https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.wechat/com.tencent.wechat_1.0.0.241_amd64.deb

### multi arch support
read -s -p "Enter sudo Password: " sudo_passwd
echo # Move to a new line


echo $sudo_passwd | sudo -S cp -rf etc/apt/sources.list.d/ustc.debian12.bookworm.list /etc/apt/sources.list.d/
mkdir -p ${tool_path}

echo $sudo_passwd | sudo -S dpkg --add-architecture i386
echo "$sudo_passwd" | sudo -S apt update && sudo apt install -y apt-utils aptitude

### basic
echo $sudo_passwd | sudo -S aptitude install -y build-essential gcc g++ cmake gdb pkg-config sudo cppman man-db exfatprogs exfat-fuse ffmpeg \
fonts-wqy-microhei ntfs-3g gzip unzip unrar bzip2 tar liblz4-tool xz-utils \
tmux mtools  parted libudev-dev libusb-dev autoconf autotools-dev m4  libdrm-dev sed make binutils patch \
bc gawk perl curl wget cpio libncurses5 libssl-dev expect fakeroot diffstat texinfo uuid-dev locales pkg-config \
ncurses-dev gperf flex liblz4-tool time lib32ncurses-dev gnupg gcc-multilib g++-multilib \
x11proto-core-dev libx11-dev fontconfig libtool libudev-dev net-tools top htop iotop

### atzlinux mirrors
wget -c -O atzlinux-v12-archive-keyring_lastest_all.deb https://www.atzlinux.com/atzlinux/pool/main/a/atzlinux-archive-keyring/atzlinux-v12-archive-keyring_lastest_all.deb
echo $sudo_passwd | sudo -S dpkg -i atzlinux-v12-archive-keyring_lastest_all.deb

### microsoft edge mirrors

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
echo $sudo_passwd | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
rm -f packages.microsoft.gpg
echo "$sudo_passwd" | sudo -S apt update
echo $sudo_passwd | sudo -S aptitude install microsoft-edge-stable

## firewall
echo $sudo_passwd | sudo -S aptitude install -y ufw
echo $sudo_passwd | sudo -S ufw enable
echo $sudo_passwd | sudo -S ufw allow ssh
echo $sudo_passwd | sudo -S ufw allow http
echo $sudo_passwd | sudo -S ufw allow https
echo $sudo_passwd | sudo -S ufw allow ftp
echo $sudo_passwd | sudo -S ufw allow nfs
echo $sudo_passwd | sudo -S ufw allow in proto udp from any to 224.0.0.251 port 5353
echo $sudo_passwd | sudo -S ufw allow out proto udp to 224.0.0.251 port 5353
echo $sudo_passwd | sudo -S ufw allow proto igmp from any to 224.0.0.1
echo $sudo_passwd | sudo -S ufw allow proto igmp from any to 224.0.0.251
echo $sudo_passwd | sudo -S ufw default deny
echo $sudo_passwd | sudo -S ufw status verbose

### adb
echo $sudo_passwd | sudo -S aptitude install -y adb android-sdk-platform-tools-common

#### fcitx
echo $sudo_passwd | sudo -S aptitude install -y fcitx5  fcitx5-chinese-addons

mkdir -p ~/.config/environment.d
tee  ~/.config/environment.d/fcitx5.conf <<EOT
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
INPUT_METHOD=fcitx
GLFW_IM_MODULE=ibus
EOT

mkdir -p ~/.config/autostart
cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/

### aria2
echo $sudo_passwd | sudo -S aptitude install -y aria2
cp -rf HOME/.config/aria2 $HOME/.config
pushd $HOME/.config/aria2
sed -i "1,\$s@/home/dl@$HOME@g" *.conf
popd
echo $sudo_passwd | sudo -S cp -rf service/*.service /lib/systemd/system/
echo $sudo_passwd | sudo -S systemctl daemon-reload
echo $sudo_passwd | sudo -S systemctl start aria2_yt-dlp@$USER
echo $sudo_passwd | sudo -S systemctl start aria2_browser@$USER
echo $sudo_passwd | sudo -S systemctl enable aria2_yt-dlp@$USER
echo $sudo_passwd | sudo -S systemctl enable aria2_browser@$USER

### guvcview
echo $sudo_passwd | sudo -S aptitude install -y guvcview

### imagemagick
echo $sudo_passwd | sudo -S aptitude install -y imagemagick

### sqlite
echo $sudo_passwd | sudo -S aptitude install -y sqlite3 sqlitebrowser

### pdfgrep
echo $sudo_passwd | sudo -S aptitude install -y pdfgrep

### nfs server
echo $sudo_passwd | sudo -S aptitude install -y nfs-kernel-server
#printf "$HOME/Downloads\t 192.168.*.*(rw,sync,no_root_squash,insecure)" | sudo tee -a /etc/exports
#sudo nfsd restart
# sudo showmount -e

#### telnet server
#echo $sudo_passwd | sudo -S aptitude install -y xinetd telnetd
#
#function configure_xinetd() {
#echo "xinetd configure now..."
#echo $sudo_passwd | sudo -S tee -a /etc/xinetd.conf > /dev/null <<EOT
#  telnet stream tcp nowait telnetd /usr/sbin/tcpd /usr/sbin/in.telnetd
#  defaults
#  {
#    instances=60
#    log_type=SYSLOG authpriv
#    log_on_success=HOST PID
#    log_on_failure=HOST
#    cps=25 30
#  }
#  includedir /etc/xinetd.d
#EOT
#}
#
#function configure_telnetd() {
#  echo "xinetd telnetd now..."
#  echo $sudo_passwd | sudo -S tee -a /etc/xinetd.d/telnet > /dev/null <<EOT
#  service telnet
#  {
#    disable = no
#    flags = REUSE
#    socket_type = stream
#    wait = no
#    server = /usr/sbin/in.telnetd
#  }
#EOT
#}
#
#configured=$(grep xinetd /etc/xinetd.conf | wc -l)
#if [[ ${configured} -lt 1 ]];
#then
#  configure_xinetd
#fi
#
#configured=$(grep telnetd /etc/xinetd.d/telnet | wc -l)
#if [[ ${configured} -lt 1 ]];
#then
#  configure_telnetd
#fi
#echo $sudo_passwd | sudo -S systemctl restart xinetd

### samba server
echo $sudo_passwd | sudo -S aptitude install -y samba
echo $sudo_passwd | sudo -S smbpasswd -a $USER

function configure_smb() {
  echo $sudo_passwd | sudo -S tee -a /etc/samba/smb.conf > /dev/null <<EOT
  [$USER]
  path=$HOME/Downloads
  writable=yes
  browseable=yes
  security=share
EOT
}
configured=$(grep $USER /etc/samba/smb.conf | wc -l)
if [[ ${configured} -lt 1 ]];
then
  configure_smb
fi

### samba client
echo $sudo_passwd | sudo -S aptitude install -y cifs-utils
# sudo mount -t cifs -o user=xxx,pass=xxx  //xxx.xxx.xxx.xxx/临时文件 /mnt

### ssh
echo $sudo_passwd | sudo -S aptitude install -y openssh-client
if [ ! -f ~/.ssh/id_ecdsa.pub ]; then
  ssh-keygen -t ecdsa
fi

### sshfs
echo $sudo_passwd | sudo -S aptitude install -y sshfs

### docker

## for Debian / Red Hat
have_package=$(which docker | wc -l)
if [ ${have_package} -lt 1 ]; then
  curl -sSL https://get.docker.com/ | sh
  ## for Arch Linux
  # sudo pacman -S docker

  echo $sudo_passwd | sudo -S usermod -aG docker $USER
  echo $sudo_passwd | sudo -S mkdir -p /etc/docker
  echo $sudo_passwd | sudo -S cp -rf etc/docker/daemon.json /etc/docker
  echo $sudo_passwd | sudo -S systemctl daemon-reload
  echo $sudo_passwd | sudo -S systemctl enable docker
  echo $sudo_passwd | sudo -S usermod -aG docker ${USER}
  #echo $sudo_passwd | sudo -S systemctl restart docker
  #docker/docker_action.sh  build
fi

### add docker compose
if [[ ! -f /usr/bin/docker-compose ]]; then
  echo $sudo_passwd | sudo -S curl -SL https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
  echo $sudo_passwd | sudo -S ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  echo $sudo_passwd | sudo -S chmod +x $USER /usr/local/bin/docker-compose
fi

### bash
echo $sudo_passwd | sudo -S chsh -s /usr/bin/bash
cp home/.bash_aliases ~/
cp home/.bashrc ~/
cp home/.proxyrc ~/

### vim
echo $sudo_passwd | sudo -S aptitude install -y vim
cp home/.vimrc ~/

### git
echo $sudo_passwd | sudo -S aptitude install -y git
cp home/.gitconfig ~/

## subversion
echo $sudo_passwd | sudo -S aptitude install -y subversion
if [ -d ~/.subversion ]; then
  sed -i  "/^# store-passwords/c\store-passwords = yes"  ~/.subversion/servers
fi

### minicom
echo $sudo_passwd | sudo -S aptitude install -y minicom
cp home/.minirc.dfl ~/


echo $sudo_passwd | sudo -S usermod -aG dialout $USER
echo $sudo_passwd | sudo -S usermod -aG plugdev $USER

## tmux
echo $sudo_passwd | sudo -S aptitude install -y tmux

## vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
echo $sudo_passwd | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo $sudo_passwd | sudo -S sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
echo $sudo_passwd | sudo -S aptitude install apt-transport-https
echo $sudo_passwd | sudo -S aptitude update
echo $sudo_passwd | sudo -S aptitude install code # or code-insiders

## telegram
echo $sudo_passwd | sudo -S aptitude install -y telegram-desktop

## flameshot
echo $sudo_passwd | sudo -S aptitude install -y flameshot

### vlc
echo $sudo_passwd | sudo -S aptitude install -y vlc

### v4l2
echo $sudo_passwd | sudo -S aptitude install -y v4l-utils

### imagej
echo $sudo_passwd | sudo -S aptitude install -y imagej

#### YUView
echo $sudo_passwd | sudo -S aptitude install -y yuview

### mediainfo
echo $sudo_passwd | sudo -S aptitude install mediainfo mediainfo-gui

## repo
repo_path=~/tools/repo
mkdir -p $repo_path
wget  https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -O $repo_path/repo
chmod +x $repo_path/repo
echo "export PATH=\$PATH:$repo_path" >> ~/.bashrc
echo 'export REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/"' >> ~/.bashrc

## github gh
function install_gh() {
  echo "install github gh now ..."
  echo $sudo_passwd | mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y
}

have_package=$(which gh | wc -l)
if [ ${have_package} -lt 1 ]; then
    install_gh
fi

## klogg, install from source code
wget https://github.com/kgbook/klogg/releases/download/22.7.0.0/klogg-22.7.0-Linux.deb -O klogg.deb
sudo apt install ./klogg.deb
rm klogg.deb

## maven
echo $sudo_passwd | sudo -S aptitude install -y maven

## install wps
echo $sudo_passwd | sudo -S aptitude install -y wps-office wps-office-fonts ttf-mscorefonts-atzlinux fonts-adobe-source-han-cn libtiff5

### install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda-latest.sh
bash miniconda-latest.sh
rm miniconda-latest.sh

#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
#conda config --set show_channel_urls yes
#
#### install python2 and python3
#conda create -n python2 python=2.7
conda create -n python3 python=3.11.2

## install linux wechat
echo $sudo_passwd | sudo -S wget -O- https://deepin-wine.i-m.dev/setup.sh | sh
echo $sudo_passwd | sudo -S aptitude install -y deepin-elf-verify
echo $sudo_passwd | sudo -S apt --fix-broken install
wget $linux_wechat_url -O wechat.deb
echo $sudo_passwd | sudo -S dpkg -i wechat.deb

## nvidia driver
echo $sudo_passwd | sudo -S aptitude install -y nvidia-detect
#use_nvidia_driver=$(nvidia-detect | grep nvidia-driver | wc -l)
#if [ ${use_nvidia_driver} -gt 0 ]; then
#  echo $sudo_passwd | sudo -S aptitude install -y nvidia-driver
#fi
#nouveau_conf="/etc/modprobe.d/blacklist-nouveau.conf"
#if [ ! -f ${nouveau_conf} ]; then
#    echo ${sudo_passwd} | sudo -S touch ${nouveau_conf}
#    echo $sudo_passwd | sudo -S tee ${nouveau_conf} <<EOT
#    blacklist nouveau
#    options nouveau modeset=0
#EOT
#fi

### pam_environment
tee -a $HOME/.pam_environment > /dev/null <<EOT
LANG=en_US.UTF-8
LANGUAGE=en_US:en
LC_CTYPE=zh_CN.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_COLLATE=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
LC_TIME=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
EOT

echo "### language" >> ~/.bashrc
echo "export LANGUAGE=en_US" >> ~/.bashrc

### spotify
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo -S gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | echo $sudo_passwd | sudo -S tee /etc/apt/sources.list.d/spotify.list
sudo -S apt update && sudo -S apt install -y spotify-client

### Rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

### thuner
wget https://mirrors.sdu.edu.cn/spark-store-repository/store//network/com.xunlei.download/com.xunlei.download_1.0.0.3spark2_amd64.deb -O com.xunlei.download.deb
echo $sudo_passwd | sudo -S dpkg -i com.xunlei.download.deb
rm -f com.xunlei.download.deb