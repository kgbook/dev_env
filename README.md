[TOC]

## Setup host development environments

```bash
$ git clone https://github.com/kgbook/dev_env.git
$ cd dev_env
$ source setup.sh
```

## Setup docker development environments

### Install Docker

- Debian / Red Hat

```bash
$ curl -sSL https://get.docker.com/ | sh
$ sudo usermod -aG docker $USER
```
- Arch Linux

```bash
$ sudo pacman -S docker
$ sudo usermod -aG docker $USER
```
Auto start after login:
```bash
$ systemctl enable docker
```

### Setup Docker Container

- Pull from Docker Hub

```bash
$ docker pull alpha0x1/dev
$ docker run -it --name dev --privileged -v $HOME/Downloads:/home/admin/Downloads -v $HOME/Workspace:/home/admin/Workspace  -u admin alpha0x1/dev   /bin/bash
```

- Or build from Dockerfile
```bash
$ git clone https://github.com/kgbook/dev_env.git
$ cd dev_env/docker
$ ./docker_action.sh build dev v1.0
$ ./docker_action.sh run dev 1.0
```

Now, you have a docker container named *dev:v1.0*.
```bash
$ docker container ls -a
CONTAINER ID   IMAGE      COMMAND       CREATED      STATUS                      PORTS     NAMES
33c188c7e843   dev:v1.0   "/bin/bash"   2 days ago   Exited (0) 30 minutes ago             dev

$ docker image ls 
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
dev          v1.0      6804f23e4803   2 days ago     2.1GB
```

And alias somethings:
```bash
$ vim ~/.bash_aliases
function docker_dev_start() {
    tag=$1
    docker start $tag
    docker exec -it $tag  /bin/bash
 }

 function docker_dev_stop() {
     tag=$1
     docker stop $tag
 }

 alias docker-run='docker run -it --name dev --privileged -v $HOME/Downloads:/home/admin/Downloads -v $HOME/Workspace:/home/admin/Workspace  -u admin dev:v1.0   /bin/bash'
 alias docker-start='docker_dev_start dev'
 alias docker-stop='docker_dev_stop dev'
```

you will have a container named `dev:v1.0` after running `docker-run` command if you pulled from the docker HUB.

Then, you can use `docker-start` to enter the container, exit with `docker-stop`.



## FAQ

1. **error while creating mount source path**

Make sure that the `$HOME/Workspace` and `$HOME/Downloads` exist. But if one of them is a symbolic file, you should notice that the source path  should exist.

For example:

```bash
$ ls -l  $HOME
total 32
drwxr-xr-x  2 kgbook kgbook 4096 Dec 23 11:23 Desktop
drwxr-xr-x  4 kgbook kgbook 4096 Dec 21 14:15 Documents
drwxr-xr-x  7 kgbook kgbook 4096 Dec 31 09:21 Downloads
drwxr-xr-x  2 kgbook kgbook 4096 Dec 17 20:19 Music
drwxr-xr-x  2 kgbook kgbook 4096 Dec 21 21:04 Pictures
drwxr-xr-x  2 kgbook kgbook 4096 Dec 17 20:19 Public
drwxrwxr-x 13 kgbook kgbook 4096 Dec 21 17:42 Tools
drwxr-xr-x  2 kgbook kgbook 4096 Dec 17 20:19 Videos
lrwxrwxrwx  1 kgbook kgbook   38 Dec 20 10:06 Workspace -> /run/media/kgbook/ssd

$ ls /run/media/kgbook/ssd/project/konka
ls: cannot access '/run/media/kgbook/ssd': No such file or directory
```

It's easy to fix the issue using the command below:

```bash
$ sudo mkdir -p /run/media/kgbook/ssd
$ sudo fdisk -l
Disk /dev/sdb: 465.76 GiB, 500107862016 bytes, 976773168 sectors
Disk model: PS300 USB3.1    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0xcdf05fa4

Device     Boot Start       End   Sectors   Size Id Type
/dev/sdb1        2048 976773119 976771072 465.8G 83 Linux
$ sudo mount -t ext4 /dev/sdb1 /run/media/kgbook/ssd
```

2. **failed to create endpoint dev on network bridge**

   Detailed information:

   ```bash
   $ docker-start
   Error response from daemon: failed to create endpoint dev on network bridge: failed to add the host (vethc992906) <=> sandbox (veth5595641) pair interfaces: operation not supported
   Error: failed to start containers: dev
   Error response from daemon: Container 4a85a4d54698cfcc3ff0f471b145b125964f8d7116e338bb80e720847319d11f is not running
   ```

   You synchronized the repository databases *and* updated the system's packages with the command `sudo pacman -Syu`. The version of the kernel must have been changed if you encountered the problem! So just `reboot` your machine, and your machine will be ok.

