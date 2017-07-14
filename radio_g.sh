#!/bin/bash
if [ "$2" == "" ]; then
   grep -i "$1" -A 1 /home/ncho/bin/note.radio.flow
else
   grep -i "$1" -A $2 /home/ncho/bin/note.radio.flow
fi
