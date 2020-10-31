#!/bin/bash

# get workspace numbers
WS=10 
WS_free=''
count=0
ws_cnt=''
for ws in $(wmctrl -d | cut -d ' ' -f 1 )
do
	ws_cnt = $ws
	if [[ $count -ne $ws ]]; then  
		WS_free = $ws
		break
	fi
	(( count++ )) 
done
[[ -z $WS_free ]] && (( WS_free = $ws_cnt + 1 ))

exit
# check for move container flag
moveContainer=false
while getopts 'm' opt; do
    case $opt in
        m) moveContainer=true ;;
        *) echo 'Error in command line parsing' >&2
            exit 1
    esac
done

# loop through all workspaces and find first that isn't in use
for ws in ${ALL_WS[@]}
do 
    if  ! containsElement $ws "${WS_ARRAY[@]}"
    then
        if "$moveContainer"
        then
            # if -m flag is passed, move current container to new workspace
            ACTIVE_WIN=$(xprop -id $(xdotool getactivewindow) | grep 'WM_NAME(STRING)' | cut -d'"' -f2)
            i3-msg move container to workspace $ws
            wmctrl -r $ACTIVE_WIN -b add,demands_attention
        else
            # otherwise, switch to new empty workspace
            i3-msg workspace $ws
        fi
        break
    fi
done
