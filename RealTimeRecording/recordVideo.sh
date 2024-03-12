#!/bin/bash

SERVER_IP='192.168.1.6'
USERNAME='razer'
PEERNAME='asus'

FORMAT='mkv'
FN_FORMAT='matroska'

ROOT_PATH='/tmp'
RECORD_PATH=$ROOT_PATH/record-$USERNAME.txt
VIDEO_PATH=$ROOT_PATH/$USERNAME.$FORMAT
READ_PATH=$ROOT_PATH/$USERNAME.read

ssh $USERNAME@$SERVER_IP "echo 0 > $READ_PATH; chmod 777 $READ_PATH; rm $RECORD_PATH $VIDEO_PATH $ROOT_PATH/play-$USERNAME.txt"

while [[ 1 ]]; do
	echo $'! Recording... (Ctrl+C to stop recording, Ctrl+Z to stop the call)\n'
	ssh $USERNAME@$SERVER_IP "echo 'Recording...' > $RECORD_PATH; rm $VIDEO_PATH; echo 0 > $READ_PATH";
	(
		ffmpeg -loglevel 0 -f v4l2 -i /dev/video0 -f pulse -i default -preset slow -tune zerolatency -vf scale=-2:360 -f $FN_FORMAT - | \
		tee >( ssh $USERNAME@$SERVER_IP "cat > $VIDEO_PATH" ) | \
		ffplay -stats -loglevel 0 -an -
	)
	ssh $USERNAME@$SERVER_IP "rm $RECORD_PATH"
	echo $'\n\n! Finished Recording!'
	echo '============================================================'
	sleep 2;

	echo '! Waiting for video message...'
	while [[ $( ssh $USERNAME@$SERVER_IP "
			( ls $ROOT_PATH | grep -e play-$USERNAME.txt -e play-$PEERNAME.txt ) || ( cat $READ_PATH | grep 0 ) 
		" ) ]]; do
		sleep 1;
	done
done
