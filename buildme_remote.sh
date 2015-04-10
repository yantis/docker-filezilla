docker build -t yantis/filezilla .

docker run \
  -ti \
  --rm \
  -v $HOME/.ssh/authorized_keys:/authorized_keys:ro \
  -p 49158:22 \
  -v ~/docker-data/filezilla:/home/docker/.config/filezilla/ \
  -v /:/host \
  yantis/filezilla
