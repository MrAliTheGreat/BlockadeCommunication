#!/bin/bash
set -m

# SERVER_IP=''
# USERNAME=''

# FORMAT='mkv'

# ROOT_PATH='/tmp'
# RECORD_PATH=$ROOT_PATH/record-$USERNAME.txt
# PLAY_PATH=$ROOT_PATH/play-$USERNAME.txt
# VIDEO_PATH=$ROOT_PATH/$USERNAME.$FORMAT
# READ_PATH=$ROOT_PATH/$USERNAME.read

# ssh $USERNAME@$SERVER_IP "rm $RECORD_PATH $PLAY_PATH $VIDEO_PATH $READ_PATH";


trap "exit" INT TERM
trap 'kill $(jobs -p); ssh USERNAME@SERVER_IP "rm /tmp/record-USERNAME.txt /tmp/play-USERNAME.txt /tmp/USERNAME.FORMAT /tmp/USERNAME.read";' EXIT

./recordVideo.sh & ./playVideo.sh & fg %1 bg %2

