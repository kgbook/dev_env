## Setup host development environments

```bash
$ git clone https://github.com/kgbook/dev_env.git
$ cd dev_env
$ bash setup.sh
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
$ docker pull alpha0x1/dev:v1.0
```

- Or build from Dockerfile
```
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

you will have a container named `dev:v1.0` after running `docker-run` command.

Then, you can use `docker-start` to enter *dev:v1.0* container, exit with `docker-stop`.
