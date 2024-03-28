#!/bin/bash

#set -e
#set -x

tool_path=$HOME/tools
linux_wechat_url=https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.wechat/com.tencent.wechat_1.0.0.238_amd64.deb

### multi arch support
read -s -p "Enter sudo Password: " sudo_passwd
echo # Move to a new line

alias kapt="echo $sudo_passwd | sudo -S aptitude"
alias ksystemctl="echo $sudo_passwd | sudo -S systemctl"
alias ktee="echo $sudo_passwd | sudo -S tee"
alias kusermod="echo $sudo_passwd | sudo -S usermod"
alias kcp="echo $sudo_passwd | sudo -S cp -rf"
alias kmkdir="echo $sudo_passwd | sudo -S mkdir"
alias kdpkg="echo $sudo_passwd | sudo -S dpkg"

kcp etc/apt/sources.list.d/ustc.debian12.bookworm.list /etc/apt/sources.list.d/
mkdir -p ${tool_path}

kdpkg --add-architecture i386
echo "$sudo_passwd" | sudo -S apt update && sudo apt install -y apt-utils aptitude

### basic
kapt install -y build-essential gcc g++ cmake gdb pkg-config sudo cppman man-db exfatprogs exfat-fuse ffmpeg \
fonts-wqy-microhei ntfs-3g gzip unzip unrar bzip2 tar liblz4-tool xz-utils \
tmux mtools  parted libudev-dev libusb-dev autoconf autotools-dev m4  libdrm-dev sed make binutils patch \
bc gawk perl curl wget cpio libncurses5 libssl-dev expect fakeroot diffstat texinfo uuid-dev locales pkg-config \
ncurses-dev gperf flex liblz4-tool time lib32ncurses-dev gnupg gcc-multilib g++-multilib \
x11proto-core-dev libx11-dev fontconfig libtool libudev-dev net-tools top htop iotop

### atzlinux mirrors
wget -c -O atzlinux-v12-archive-keyring_lastest_all.deb https://www.atzlinux.com/atzlinux/pool/main/a/atzlinux-archive-keyring/atzlinux-v12-archive-keyring_lastest_all.deb
kdpkg -i atzlinux-v12-archive-keyring_lastest_all.deb

### microsoft edge mirrors

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
echo $sudo_passwd | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
rm -f packages.microsoft.gpg
echo "$sudo_passwd" | sudo -S apt update
kapt install microsoft-edge-stable

## firewall
kapt install -y ufw
alias ufw_exe="echo $sudo_passwd | sudo -S ufw"
alias iptables_exe="echo $sudo_passwd | sudo -S iptables"
ufw_exe enable
ufw_exe allow ssh
ufw_exe allow http
ufw_exe allow https
ufw_exe allow ftp
ufw_exe allow nfs
ufw_exe allow in proto udp from any to 224.0.0.251 port 5353
ufw_exe allow out proto udp to 224.0.0.251 port 5353
ufw_exe allow proto igmp from any to 224.0.0.1
ufw_exe allow proto igmp from any to 224.0.0.251
ufw_exe default deny
ufw_exe status verbose

### adb
kapt install -y adb android-sdk-platform-tools-common

#### fcitx
kapt install -y fcitx5  fcitx5-chinese-addons

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
kapt install -y aria2
mkdir -p $HOME/.config/aria2
cp -rf aria2 $HOME/.config
pushd $HOME/.config/aria2
sed -i "1,\$s@/home/dl@$HOME@g" *.conf
popd
aria2c_path=$(which aria2c)
if [[ -n ${aria2c_path} ]]; then
  cp service/aria2@.service aria2@.service
  sed -i "1,\$s@/usr/bin/aria2c@$aria2c_path@g" aria2@.service
  kcp aria2@.service /lib/systemd/system/
  rm aria2@.service
else
  echo "aria2 not installed ok! exit now..."
  exit 1
fi
ksystemctl daemon-reload
ksystemctl start aria2@$USER
ksystemctl enable aria2@$USER

### guvcview
kapt install -y guvcview

### imagemagick
kapt install -y imagemagick

### sqlite
kapt install -y sqlite3 sqlitebrowser

### pdfgrep
kapt install -y pdfgrep

### nfs server
kapt install -y nfs-kernel-server
#printf "$HOME/Downloads\t 192.168.*.*(rw,sync,no_root_squash,insecure)" | sudo tee -a /etc/exports
#sudo nfsd restart
# sudo showmount -e

#### telnet server
#kapt install -y xinetd telnetd
#
#function configure_xinetd() {
#echo "xinetd configure now..."
#ktee -a /etc/xinetd.conf > /dev/null <<EOT
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
#  ktee -a /etc/xinetd.d/telnet > /dev/null <<EOT
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
#ksystemctl restart xinetd

### samba server
kapt install -y samba
echo $sudo_passwd | sudo -S smbpasswd -a $USER

function configure_smb() {
  ktee -a /etc/samba/smb.conf > /dev/null <<EOT
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
kapt install -y cifs-utils
# sudo mount -t cifs -o user=xxx,pass=xxx  //xxx.xxx.xxx.xxx/临时文件 /mnt

### ssh
kapt install -y openssh-client
if [ ! -f ~/.ssh/id_ecdsa.pub ]; then
  ssh-keygen -t ecdsa
fi

### sshfs
kapt install -y sshfs

### docker

## for Debian / Red Hat
have_package=$(which docker | wc -l)
if [ ${have_package} -lt 1 ]; then
  curl -sSL https://get.docker.com/ | sh
  ## for Arch Linux
  # sudo pacman -S docker

  kusermod -aG docker $USER
  kmkdir -p /etc/docker
  kcp etc/docker/daemon.json /etc/docker
  ksystemctl daemon-reload
  ksystemctl enable docker
  #ksystemctl restart docker
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
kapt install -y vim
cp home/.vimrc ~/

### git
kapt install -y git
cp home/.gitconfig ~/

## subversion
kapt install -y subversion
if [ -d ~/.subversion ]; then
  sed -i  "/^# store-passwords/c\store-passwords = yes"  ~/.subversion/servers
fi

### minicom
kapt install -y minicom
cp home/.minirc.dfl ~/


kusermod -aG dialout $USER
kusermod -aG plugdev $USER

## tmux
kapt install -y tmux

## vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
echo $sudo_passwd | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo $sudo_passwd | sudo -S sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
kapt install apt-transport-https
kapt update
kapt install code # or code-insiders

## telegram
kapt install -y telegram-desktop

## flameshot
kapt install -y flameshot

### vlc
kapt install -y vlc

### v4l2
kapt install -y v4l-utils

### imagej
kapt install -y imagej

#### YUView
kapt install -y yuview

### mediainfo
kapt install mediainfo mediainfo-gui

## repo
repo_path=~/tools/repo
mkdir -p $repo_path
wget  https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -O $repo_path/repo
chmod +x $repo_path/repo
echo "export PATH=\$PATH:$repo_path" >> ~/.bashrc
echo 'export REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/"' >> ~/.bashrc

## clash
cp service/clash@.service clash@.service
sed -i "1,\$s@/home/dl@$HOME@g" clash@.service
kcp clash@.service /lib/systemd/system
rm -f clash@.service
ksystemctl daemon-reload

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
kapt install -y libboost-all-dev ragel libpcap-dev qtbase5-dev qttools5-dev
klogg_path=${tool_path}/klogg

if [[ ! -d $klogg_path ]]; then
  git clone https://github.com/variar/klogg.git ${klogg_path}
  pushd ${klogg_path}
  mkdir build && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && cmake --build . && \
  echo "export PATH=${klogg_path}/klogg/build/output:\$PATH" >> ~/.bashrc && \
  echo "install klogg ok!"
  popd
fi

## install wps
kapt install -y wps-office wps-office-fonts ttf-mscorefonts-atzlinux fonts-adobe-source-han-cn libtiff5

### install miniconda
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda-latest-Linux-x86_64.sh -O miniconda-latest.sh
bash miniconda-latest.sh
rm miniconda-latest.sh

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
conda config --set show_channel_urls yes

### install python2 and python3
conda create -n python2 python=2.7
conda create -n python3 python=3.7

## install linux wechat
echo $sudo_passwd | sudo -S wget -O- https://deepin-wine.i-m.dev/setup.sh | sh
kapt install -y deepin-elf-verify
echo $sudo_passwd | sudo -S apt --fix-broken install
wget $linux_wechat_url -O wechat.deb
kdpkg -i wechat.deb

## nvidia driver
kapt install -y nvidia-detect
#use_nvidia_driver=$(nvidia-detect | grep nvidia-driver | wc -l)
#if [ ${use_nvidia_driver} -gt 0 ]; then
#  kapt install -y nvidia-driver
#fi
#nouveau_conf="/etc/modprobe.d/blacklist-nouveau.conf"
#if [ ! -f ${nouveau_conf} ]; then
#    echo ${sudo_passwd} | sudo -S touch ${nouveau_conf}
#    ktee ${nouveau_conf} <<EOT
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
echo "deb http://repository.spotify.com stable non-free" | ktee /etc/apt/sources.list.d/spotify.list
sudo -S apt update && sudo -S apt install -y spotify-client

### Rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

### thuner
wget https://mirrors.sdu.edu.cn/spark-store-repository/store//network/com.xunlei.download/com.xunlei.download_1.0.0.3spark2_amd64.deb -O com.xunlei.download.deb
kdpkg -i com.xunlei.download.deb
rm -f com.xunlei.download.deb