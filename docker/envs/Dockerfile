# VERSION v1.0
# Author:  kgbook <kgbook.sz@outlook.com>

FROM ubuntu:18.04
MAINTAINER kgbook, kgbook.sz@outlook.com

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Hong_Kong
COPY vimrc bash_aliases sources.list gdbinit gitconfig /tmp/

RUN cp -f /tmp/sources.list /etc/apt/sources.list && \
    apt-get update && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils aptitude && \
aptitude install -y \
    sudo \
    tzdata \
    gcc-arm-linux-gnueabihf \
    u-boot-tools \
    device-tree-compiler \
    gcc-aarch64-linux-gnu \
	mtools \
	parted \
	libudev-dev \
    libusb-1.0-0-dev \
	python-linaro-image-tools \
	linaro-image-tools \
	autoconf\
	autotools-dev \
	libsigsegv2 \ 
	m4 \
	intltool \
	libdrm-dev \
	curl \
	sed \
	make \
	binutils \
	build-essential \ 
	gcc \
	g++ \
	bash \
	patch \
	gzip \
	gawk \
	bzip2 \
	perl \
	tar \
	cpio \
	python \
	unzip \
	rsync \
	file \
	bc \
	flex \
    wget \
	libncurses5 \
	libqt4-dev \
	libglib2.0-dev \
	libgtk2.0-dev \
	libglade2-dev \
	cvs \
	git \
	mercurial \
	rsync \
	openssh-client \
	subversion \
	asciidoc \
	w3m \
	dblatex \
	graphviz \
	python-matplotlib \
	libc6:i386 \
	libssl-dev \
	expect \
	fakeroot \
	cmake \
    diffstat \
    unrar-free \
    texinfo \
    uuid-dev \
    xz-utils \
	zlib1g-dev\
    locales \
    bison \
    pkg-config \
	ncurses-dev\
	mtd-utils \
	gperf\
	lib32z1 \
	liblz4-tool \
	time \
    vim \
    gnupg \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    lib32ncurses5-dev \
    x11proto-core-dev \
    libx11-dev \
    lib32z1-dev \
    libgl1-mesa-dev \
    libxml2-utils \
    xsltproc \
    fontconfig && \ 
    aptitude clean && \
    useradd -m admin -d /home/admin -G sudo -U -s /bin/bash && \
    echo 'admin:admin' | chpasswd && \
    ln -sf /bin/bash /bin/sh && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    ln -sf /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4 && \
    cd /home/admin && \
    mv /tmp/vimrc .vimrc && \
    mv /tmp/bash_aliases .bash_aliases && \
    echo "PROMPT_DIRTRIM=1" >> .bashrc && \
    sed -i 's/#\ en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/g' /etc/locale.gen && \
    sed -i 's/#\ zh_CN.UTF-8\ UTF-8/zh_CN.UTF-8\ UTF-8/g' /etc/locale.gen && \
    locale-gen && \
    echo 'export LANG=zh_CN.UTF-8' >> .bashrc && \
    echo 'export LANGUAGE=zh_CN:en_US' >> .bashrc && \
    svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python /opt/python && \
    cp -f /tmp/gdbinit /home/admin/.gdbinit && \
    cp -f /tmp/gitconfig /home/admin/.gitconfig && \
    rm -rf /tmp/*  && \
    sync

USER admin
WORKDIR /home/admin
ENV USER admin
