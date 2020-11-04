#!/bin/bash

i3config="$HOME/.config/i3/config"

# Array for i3config Workspace names
declare -a WSpaces=("")
getWorkspaceConfigNames () {
	local ws_num=$1
	local re1="^set[[:space:]]+.ws[0-9]+[[:space:]]+[\"\']([0-9]+)(:([[:alnum:][:space:]]+))?[\"\'][[:space:]]*$"
	while read -r line
	do
		[[ $line =~ $re1 ]] && WSpaces+=("${BASH_REMATCH[1]}${BASH_REMATCH[2]}")
	done < $i3config
	
	[[ -v WSpaces[$ws_num] ]] && echo ${WSpaces[$ws_num]} || echo $ws_num
}

# find free workspace 
getWorkspaceFree() {
	local pcount=0

	for ws_num in $(i3-msg -t get_workspaces | jq '.[] | (.num)') 
	do	
		[[ $ws_num -gt 0 ]] && (( pcount++ ))
		# if first call, $ws_num should = 0, if not, then $pcount == 0,
		# and then this is true, and we return 0
		if [[ $pcount -ne $ws_num ]] ; then
			getWorkspaceConfigNames $pcount
			return
		fi
	done
	# Deals with case of full pack. Add another workspace at end.
	getWorkspaceConfigNames $(( pcount + 1 ))
}

# if -m flag is passed, move current container to new workspace
moveContainer () {
	local ws=$1
	i3-msg move container to workspace $ws
	i3-msg workspace $ws
}

WS_free=$(getWorkspaceFree)

# check for move container flag
_move=''
getopts 'm' opt
case $opt in
	m) moveContainer $WS_free ;;
	?) i3-msg workspace $WS_free ;;
	*) echo 'Error in command line parsing' >&2; exit 1 ;;
esac
