# docker-filezilla

On Docker hub [filezilla](https://registry.hub.docker.com/u/yantis/filezilla)
on Github [filezilla](https://github.com/yantis/docker-filezilla)

This is Filezilla on Docker. It has three modes: Local (no ssh server), remote with ssh server, as
well as an optional script for an instant launch AWS EC2 for quick file transfers with 
storage to EBS volume (Amazon Elastic Block Store). Check out the [aws-filezilla.sh](https://github.com/yantis/docker-filezilla/blob/master/aws-filezilla.sh) script for this.


## Usage (Local)

The recommended way to run this container looks like this. This example launches Filezilla seamlessly as
if it was another program on your computer.

```bash
xhost +si:localuser:$(whoami)
docker run \
        -d \
        -e DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
        -u docker \
        -v /:/host \
        -v $HOME/docker-data/filezilla:/home/docker/.config/filezilla/ \
        yantis/filezilla filezilla
```

## Breakdown (Local)

```bash
$ xhost +si:localuser:yourusername
```

Allows your local user to access the xsocket. Change yourusername or use $(whoami)
or $USER if your shell supports it.


```bash
docker run \
           -d \
           -e DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
           -u docker \
           -v /:/host \
           -v $HOME/docker-data/filezilla:/home/docker/.config/filezilla/ \
           yantis/filezilla filezilla
```
This follows these docker conventions:

* `-d` run in daemon mode. 
* `-e DISPLAY` sets the host display to the local machines display.
* `-v /tmp/.X11-unix:/tmp/.X11-unix:ro` bind mounts the X11 socks on your local machine
to the containers and makes it read only.
* `-u docker` sets the user to docker. (or you could do root as well)
* ` -v /:/host` Shares the entire host hard drive with the container (you might not want to be
that permissive so just change "/" to whatever path you want to allow.
(This is optional but since Filezilla doesn't support FXP you might want to save the files somewhere)
* `-v ~/docker-data/filezilla:/home/docker/.config/filezilla/` This is where to save your config files.
If you have no interest in saving them then it is optional.
* `yantis/filezilla filezilla` You need to call filezilla because if you do not it will a launch the ssh
server instead as a default.


## Usage (Remote SSH)

The recommended way to run this container over SSH looks like this. This example launches an high performance SSH
server with X-forwarding enabled. Which you can ssh -X (or -Y) into. Check out the [aws-filezilla.sh](https://github.com/yantis/docker-filezilla/blob/master/aws-filezilla.sh) script for an example of this. 


```bash
docker run \
    -ti \
    --rm \
    -v $HOME/.ssh/authorized_keys:/authorized_keys:ro \
    -p 49158:22 \
    -v ~/docker-data/filezilla:/home/docker/.config/filezilla/ \
    yantis/filezilla
```

## Breakdown (Remote SSH)

This follows these docker conventions:

* `-ti` will run an interactive session that can be terminated with CTRL+C.
* `--rm` will run a temporary session that will make sure to remove the container on exit.
* `-v $HOME/.ssh/authorized_keys:/authorized_keys:ro` Optionaly share your public keys with the host.
This is particularlly useful when you are running this on another server that already has SSH. Like an 
Amazon EC2 instance. WARNING: If you don't use this then it will just default to the user pass of docker/docker
(If you do specify authorized keys it will disable all password logins to keep it secure).
* `-v ~/docker-data/filezilla:/home/docker/.config/filezilla/` This is where to save your config files.
If you have no interest in saving them then it is optional.
* ` -v /:/host` Shares the entire host hard drive with the container (you might not want to be
that permissive so just change "/" to whatever path you want to allow)
* `yantis/filezilla` the default mode is SSH so no need to run any commands.

Here is a screenshot of Filezilla running on Docker.
![](http://yantis-scripts.s3.amazonaws.com/Screenshot_2015-04-10_02-01-50.png)
