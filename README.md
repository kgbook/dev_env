## Set up host development environments

```bash
$ git clone https://github.com/kgbook/dev_env.git
$ cd dev_env
$ bash setup.sh
```

## set up docker development environments
```
$ git clone https://github.com/kgbook/dev_env.git
$ cd dev_env/docker
$ ./docker_action.sh build iot v1.0
$ ./docker_action.sh run iot 1.0
```

Now, you have a docker container named iot:v1.0.
```bash
$ docker container ls
CONTAINER ID   IMAGE      COMMAND       CREATED             STATUS             PORTS     NAMES
9357774c3d6d   iot:v1.0   "/bin/bash"   About an hour ago   Up About an hour             iot
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

 alias docker-run='docker run -it --name iot --privileged -v $HOME/Downloads:/home/admin/Downloads -v $HOME/Documents:/home/admin/Documents  -u admin iot:v1.0   /bin/bash'
 alias docker-start='docker_dev_start iot'
 alias docker-stop='docker_dev_stop iot'
```

Then, you can use `docker-start` to enter *iot:v1.0* container, exit with `docker-stop`.
