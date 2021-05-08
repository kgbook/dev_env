cmd=$1
tag=$2
version=$3
CtxDir=$PWD/envs

if [ x$tag = x ] ;then
    tag=iot-rk
fi

if [ x$version = x ] ;then
    version=v1.0
fi

if [ x$cmd = x"build" ] ;then
    docker build --no-cache -f $CtxDir/Dockerfile --tag $tag:$version $CtxDir
elif [ x$cmd = x"run" ] ;then
    docker run -it --name $tag --privileged -v $HOME/Downloads:/home/admin/Downloads -v $HOME/Documents:/home/admin/Documents  -u admin $tag:$version   /bin/bash
elif [ x$cmd = x'start'  ] ;then
    docker start $tag
    docker exec -it $tag /bin/bash
elif [ x$cmd = x'stop' ] ; then
    docker stop $tag
else
    echo "error"
fi
