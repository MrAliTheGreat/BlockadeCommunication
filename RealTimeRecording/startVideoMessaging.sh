#!/bin/bash
set -m

# SERVER_IP='192.168.1.6'
# USERNAME='razer'

# FORMAT='mkv'

# ROOT_PATH='/tmp'
# RECORD_PATH=$ROOT_PATH/record-$USERNAME.txt
# PLAY_PATH=$ROOT_PATH/play-$USERNAME.txt
# VIDEO_PATH=$ROOT_PATH/$USERNAME.$FORMAT
# READ_PATH=$ROOT_PATH/$USERNAME.read

# ssh $USERNAME@$SERVER_IP "rm $RECORD_PATH $PLAY_PATH $VIDEO_PATH $READ_PATH";


trap "exit" INT TERM
trap 'kill $(jobs -p); ssh razer@192.168.1.6 "rm /tmp/record-razer.txt /tmp/play-razer.txt /tmp/razer.mkv /tmp/razer.read";' EXIT

./recordVideo.sh & ./playVideo.sh & fg %1 bg %2

