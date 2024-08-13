#!/bin/sh

PID=$EARLYOOM_PID
UID=$EARLYOOM_UID
NAME=$EARLYOOM_NAME
RESULT_PATH=/tmp

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

if echo "$NAME" | grep -iq "java"; then
    echo "Executing jmap for Java process PID: $PID, UID: $UID, NAME: $NAME"
    FILENAME="jmap_histo_${TIMESTAMP}.txt"
    jmap -histo $PID > "$RESULT_PATH/$FILENAME"
    echo "jmap output saved to $RESULT_PATH/$FILENAME"
else
    echo "No Java process found for PID: $PID"
fi
