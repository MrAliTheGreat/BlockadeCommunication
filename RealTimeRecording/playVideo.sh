#!/bin/bash

SERVER_IP='192.168.1.6'
USERNAME='razer'
PEERNAME='asus'

FORMAT='mkv'

ROOT_PATH='/tmp'
PLAY_PATH=$ROOT_PATH/play-$USERNAME.txt
VIDEO_PATH=$ROOT_PATH/$PEERNAME.$FORMAT
READ_PATH=$ROOT_PATH/$PEERNAME.read

while [[ ! $( ssh $USERNAME@$SERVER_IP "ls $ROOT_PATH | grep $PEERNAME.read" ) ]]; do
	echo "! Waiting for $PEERNAME to join the call..."
	sleep 1;
done

while [[ 1 ]]; do
	echo "! Waiting for video message from $PEERNAME..."
	while [[ $( ssh $USERNAME@$SERVER_IP "
		( ls $ROOT_PATH | grep -e record-$USERNAME.txt -e record-$PEERNAME.txt ) || ( cat $READ_PATH | grep 1 )
		" ) ]]; do
		sleep 1;
	done
	echo $'! Playing...\n'
	ssh $USERNAME@$SERVER_IP "echo 'Playing...' > $PLAY_PATH; echo 1 > $READ_PATH";
	ssh $USERNAME@$SERVER_IP "cat $VIDEO_PATH" | ffplay -stats -loglevel 0 -autoexit -
	ssh $USERNAME@$SERVER_IP "rm $PLAY_PATH"
	echo $'\n! Finished Playing!'
	echo '============================================================'
	sleep 2;
done
