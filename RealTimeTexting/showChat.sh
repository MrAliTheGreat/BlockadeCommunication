#!/bin/bash

USERNAME=""
SERVER_IP=""
CHAT_PATH="/tmp/chat.txt"

ssh $USERNAME@$SERVER_IP "tail -f $CHAT_PATH" | cat
