#!/bin/bash

############################################################
#         Copyright (c) 2015 Jonathan Yantis               #
#          Released under the MIT license                  #
############################################################
#                                                          #
# Connect to remote SSH server and and launch our container
# then reconnect to that container and run Filezilla over
# X-forwarding. Then shut down the container when done.
#
# Usage:
# remote-filezilla.sh username hostname
#
# Example:
# remote-filezilla.sh user hermes
#                                                          #
############################################################

# Exit the script if any statements returns a non true (0) value.
set -e

# Exit the script on any uninitialized variables.
set -u

# Exit the script if the user didn't specify at least two arguments.
if [ "$#" -ne 2 ]; then
  echo "Error: You need to specifiy the host and user"
  exit 1
fi

USER_NAME=$2
HOST_NAME=$2

# Pick a random port as we might have multiple things running.
PORT=$[ 32767 + $[ RANDOM % 32767 ] ]

# Connect to the server and launch our container.
ssh -o StrictHostKeyChecking=no \
    $USER_NAME@$HOST_NAME -tt << EOF
  sudo docker run \
    -d \
    -v /home/$USER_NAME/.ssh/authorized_keys:/authorized_keys:ro \
    -v /:/root/external \
    -v /home/$USER_NAME/.config/filezilla:/root/.config/filezilla/ \
    -p $PORT:22 \
    yantis/filezilla
  exit
EOF

# Now that is is launched go ahead and connect to our new server
# and politely kill root to force a container shutdown.
ssh -Y \
    -o ConnectionAttempts=255 \
    -o StrictHostKeyChecking=no \
     root@$HOST_NAME -p $PORT \
     -tt << EOF
  filezilla
  sudo pkill -INT -u root
EOF
