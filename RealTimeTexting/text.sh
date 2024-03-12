#!/bin/bash

USERNAME=""
SERVER_IP=""
CHAT_PATH="/tmp/chat.txt"

while [[ 1 ]]; do
	read -p "$USERNAME says: " TEXT
	TEXT=`echo $TEXT | sed "s/'/ /"`
	ssh $USERNAME@$SERVER_IP " echo -e '
-------------------------------------------------------------------------
 \033[1m'"$USERNAME"'\033[0m                                             
                                                                         
    '"$TEXT"'                                                            
                                                                         
                                                                         
 '"$(date '+%A - %B %d, %Y - %H:%M:%S')"'                                
-------------------------------------------------------------------------' >> $CHAT_PATH "
done
