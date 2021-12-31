function cu_serial() {
    usb_dev=$1
    cu -s 115200 --parity=none -l /dev/ttyUSB$usb_dev 2>&1 | tee $HOME/Downloads/cu-usb$usb_dev.log 
}

function screen_serial() {
    usb_dev=$1
    screen /dev/ttyUSB$usb_dev 115200 2>&1 | tee $HOME/Downloads/serail-usb$usb_dev.log
}

function screen_serial_no_log() {
    usb_dev=$1
    screen /dev/ttyUSB$usb_dev 115200 
}

function docker_dev_start() {
   tag=$1
   docker start $tag
   docker exec -it $tag  /bin/bash
}

function docker_dev_stop() {
    tag=$1
    docker stop $tag
}

alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias cu-usb0='cu_serial 0'
alias cu-usb1='cu_serial 1'
alias cu-usb2='cu_serial 2'
alias cu-usb3='cu_serial 3'

alias screen-usb0='screen_serial_no_log 0'
alias screen-usb1='screen_serial_no_log 1'
alias screen-usb2='screen_serial_no_log 2'
alias screen-usb3='screen_serial_no_log 3'

alias uvc='guvcview'
alias uvc0-1080='guvcview -w 5 -d /dev/video0 -F 25 -u h264 -x 1920x1080'
alias uvc0-1440='guvcview -w 5 -d /dev/video0 -F 25 -u h264 -x 2560x1440'
alias uvc1-1080='guvcview -w 5 -d /dev/video1 -F 25 -u h264 -x 1920x1080'
alias uvc1-1440='guvcview -w 5 -d /dev/video1 -F 25 -u h264 -x 2560x1440'
alias uvc2-1080='guvcview -w 5 -d /dev/video2 -F 25 -u h264 -x 1920x1080'
alias uvc2-1440='guvcview -w 5 -d /dev/video2 -F 25 -u h264 -x 2560x1440'
alias uvc3-1080='guvcview -w 5 -d /dev/video3 -F 25 -u h264 -x 1920x1080'
alias uvc3-1440='guvcview -w 5 -d /dev/video3 -F 25 -u h264 -x 2560x1440'

alias tgz='tar -xzvf'
alias txz='tar -xJvf'
alias rar='unrar x'
alias unzip='unzip -O gbk'
alias du='du -d 1 -h'
alias mount4.5='sudo mount -t cifs  //172.20.4.5/临时文件 ~/mnt -o username=cad,rw'
#alias brook-client='brook client -s xxx.xxx.xxx.xxx:xxxx -p xxxxxxx --socks5 127.0.0.1:1080 &'
#alias lightsocks-client='lightsocks &'
alias ..='cd ..'
alias ...='cd ../..'

alias docker-start='docker_dev_start dev'
alias docker-stop='docker_dev_stop dev'

alias rv1126_ut='which upgrade_tool'
alias rv1126_ld='$(rv1126_ut) ld'
alias rv1126_uf='$(rv1126_ut) uf'
