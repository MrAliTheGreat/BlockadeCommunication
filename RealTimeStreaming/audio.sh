#!/bin/bash

FORMAT="mp3"
WAIT_SEC=2

USERNAME=""
PEERNAME=""
SERVER_IP=""

SRC_PATH="/tmp/$USERNAME.$FORMAT"
TGT_PATH="/tmp/$PEERNAME.$FORMAT"

ffmpeg -f pulse -i default -f $FORMAT - | ssh $USERNAME@$SERVER_IP "
(
	rm $SRC_PATH;
	(
		while [[ ! -e $TGT_PATH ]]; do
			sleep $WAIT_SEC;
		done
		sleep $WAIT_SEC;
		ffmpeg -re -i $TGT_PATH -f $FORMAT - 
	) &
	cat > $SRC_PATH
)
" | ffplay -
