#!/bin/bash
### multi arch support
read -s -p "Enter sudo Password: " sudo_passwd
echo # Move to a new line

alias kapt="echo $sudo_passwd | sudo -S aptitude"
alias ksystemctl="echo $sudo_passwd | sudo -S systemctl"
alias ktee="echo $sudo_passwd | sudo -S tee"
alias kusermod="echo $sudo_passwd | sudo -S usermod"
alias kcp="echo $sudo_passwd | sudo -S cp"
alias kmkdir="echo $sudo_passwd | sudo -S mkdir"
alias kdpkg="echo $sudo_passwd | sudo -S dpkg"

kcp etc/apt/sources.list.d/ustc.debian12.bookworm.list /etc/apt/sources.list.d/

kdpkg --add-architecture i386
kapt update
echo "$sudo_passwd" | sudo -S apt install apt-utils aptitude

### basic
kapt install -y build-essential gcc g++ cmake gdb pkg-config sudo cppman man-db exfatprogs exfat-fuse ffmpeg fcitx5  fcitx5-chinese-addons fonts-wqy-microhei ntfs-3g gzip unzip unrar bzip2 tar liblz4-tool xz-utils tmux mtools  parted libudev-dev libusb-dev autoconf autotools-dev m4  libdrm-dev sed make binutils patch bc gawk perl curl wget cpio libncurses5 libssl-dev expect fakeroot diffstat texinfo uuid-dev locales pkg-config ncurses-dev gperf flex liblz4-tool time lib32ncurses-dev gnupg gcc-multilib g++-multilib x11proto-core-dev libx11-dev fontconfig libtool libudev-dev

### adb
kapt install -y adb android-sdk-platform-tools-common

### vlc
kapt install -y vlc

### v4l2
kapt install -y v4l-utils

### aria2
kapt install -y aria2
mkdir -p $HOME/.config/aria2
cp -rf aria2 $HOME/.config
sed -i "1,\$s@/home/dl@$HOME@g" aria2.conf
sed -i "1,\$s@/home/dl@$HOME@g" script.conf
aria2c_path=$(which aria2c)
sed -i "1,\$s@/usr/bin/aria2c@$aria2c_path@g" service/aria2@.service
kcp service/aria2@.service /lib/systemd/system
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

### telnet server
kapt install -y xinetd telnetd
ktee -a /etc/xinetd.conf > /dev/null <<EOT
telnet stream tcp nowait telnetd /usr/sbin/tcpd /usr/sbin/in.telnetd
defaults
{
  instances=60
  log_type=SYSLOG authpriv
  log_on_success=HOST PID
  log_on_failure=HOST
  cps=25 30
}
includedir /etc/xinetd.d
EOT

ktee -a /etc/xinetd.d/telnet > /dev/null <<EOT
service telnet
{
  disable = no
  flags = REUSE
  socket_type = stream
  wait = no
  wait = no
  server = /usr/sbin/in.telnetd
  server = /usr/sbin/in.telnetd
}
EOT
ksystemctl restart xinetd

### samba server
kapt install -y samba
echo $sudo_passwd | sudo -S smbpasswd -a $USER
ktee -a /etc/samba/smb.conf > /dev/null <<EOT
[$USER]
path=$HOME/Downloads
writable=yes
browseable=yes
security=share
EOT

### samba client
kapt install -y cifs-utils
# sudo mount -t cifs -o user=xxx,pass=xxx  //xxx.xxx.xxx.xxx/临时文件 /mnt

### ssh
kapt install -y openssh-client
ssh-keygen -t ecdsa
cp home/.ssh/config ~/.ssh

### sshfs
kapt install -y sshfs

### docker

## for Debian / Red Hat
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

### bash
echo $sudo_passwd | sudo -S chsh -s /usr/bin/bash
cp home/.bash_aliases ~/
cp home/.bashrc ~/

### vim
kapt install -y vim
cp home/.vimrc ~/

### git
kapt install -y git
cp home/.gitconfig ~/

## subversion
kapt install -y subversion
sed -i  "/^# store-passwords/c\store-passwords = yes"  ~/.subversion/servers

### minicom
kapt install -y minicom
cp home/.minirc.dfl ~/


kusermod -aG dialout $USER
ksudo usermod -aG plugdev $USER

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

## repo
repo_path=~/tools/repo
mkdir -p $repo_path
wget  https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -O $repo_path/repo
chmod +x $repo_path/repo
echo "export PATH=\$PATH:$repo_path" >> ~/.bashrc
echo 'export REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/"' >> ~/.bashrc

## clash
sed -i "1,\$s@/home/dl@$HOME@g" service/clash@.service
