#!/bin/bash

FORMAT="mkv"
FN_FORMAT="matroska"
WAIT_SEC=4

USERNAME=""
PEERNAME=""
SERVER_IP=""
SRC_PATH="/tmp/$USERNAME.$FORMAT"
TGT_PATH="/tmp/$PEERNAME.$FORMAT"

ffmpeg -f v4l2 -i /dev/video0 -f pulse -i default -preset slow -tune zerolatency -vf scale=-2:360 -f $FN_FORMAT - | ssh $USERNAME@$SERVER_IP "
(
	rm $SRC_PATH;
	(
		while [[ ! -e $TGT_PATH ]]; do
			sleep $WAIT_SEC;
		done
		sleep $WAIT_SEC;
		ffmpeg -re -i $TGT_PATH -f $FN_FORMAT - 
	) &
	cat > $SRC_PATH
)
" | ffplay -
