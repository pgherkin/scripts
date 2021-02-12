#!/bin/bash
# https://sabnzbd.org/wiki/scripts/notification-scripts
# params
TYPE    =$1
TITLE   =$2
MESSAGE =$3
WEBHOOK =$4

#remove prefix "SABnzbd:" from each title
TITLE=$(echo $TITLE | sed 's/SABnzbd://g')
NOTIFICATION="$TITLE: $MESSAGE"

curl -X POST --data-urlencode "payload={\"text\": \"$NOTIFICATION\"}" $WEBHOOK
