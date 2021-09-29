# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export LC_ALL=C
PATH=$HOME/konka/P_RK1109/sourcecode/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin:$PATH
PATH=$HOME/konka/Hi3516/sourceCode/toolchain/arm-himix200-linux/bin:$PATH
#PATH=$HOME/konka/P_hi3518ev300/toolchain/hcc_riscv32/bin:$PATH
#PATH=$HOME/konka/P_hi3518ev300/toolchain/arm-himix100-linux/bin:$PATH
#PATH=$HOME/konka/P_ssc335/sourcecode/toolchain/arm-buildroot-linux-uclibcgnueabihf-4.9.4/bin:$PATH
#PATH=$HOME/konka/P_ssc335/sourcecode/toolchain/arm-linux-gnueabihf-4.8.3-201404/bin:$PATH
#PATH=$HOME/konka/P_ssc335/sourcecode/toolchain/gcc-arm-8.2-2018.08-x86_64-arm-linux-gnueabihf/bin:$PATH
PATH=$HOME/konka/P_RK1109/sourcecode/tools/linux/Linux_Upgrade_Tool/Linux_Upgrade_Tool:$PATH
PATH=$HOME/Tools/XMind/xmind-8-update9-linux/XMind_amd64:$PATH
PATH=$HOME/Tools/CLion/clion-2019.3.5/bin:$PATH
export PATH=$PATH
