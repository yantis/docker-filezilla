docker build -t yantis/filezilla .

xhost +si:localuser:$(whoami) >/dev/null
docker run \
  -d \
  -e DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -u docker \
  -v /:/host \
  -v ~/docker-data/filezilla:/home/docker/.config/filezilla/ \
  yantis/filezilla filezilla


