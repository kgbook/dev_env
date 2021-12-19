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

- Build from Dockerfile
```
$ git clone https://github.com/kgbook/dev_env.git
$ cd dev_env/docker
$ ./docker_action.sh build dev v1.0
$ ./docker_action.sh run dev 1.0
```

Now, you have a docker container named *iot:v1.0*.
```bash
$ docker container ls
CONTAINER ID   IMAGE      COMMAND       CREATED             STATUS             PORTS     NAMES
9357774c3d6d   dev:v1.0   "/bin/bash"   About an hour ago   Up About an hour             dev
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

 alias docker-start='docker_dev_start dev'
 alias docker-stop='docker_dev_stop dev'
```

Then, you can use `docker-start` to enter *dev:v1.0* container, exit with `docker-stop`.
