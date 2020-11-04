#!/bin/bash
# TODO:
# Fix move container 
# How about a computer "interpreter" that writes it in any
# psuedo fashion, and it will attempt to write it in a certain 
# language paradigm. Instead of sticking to these formal markdown 
# languages, how about a simple user language that the AI interpretor 
# takes a best "guess" at. If you need to amend the language itself 
# (or customise the interpreter, you should be able to "teach" it. 
# For already we have advanced far upon this road, from the email 
# anti-spam methodologies, to the sraping and data-warehousing ones, 
# and all inbetween.

i3config="$HOME/.config/i3/config"
#i3config="/tmp/y.sh"

# Array for i3config Workspace names
declare -a WSpaces=("")
getWorkspaceConfigNames () {
	local ws_num=$1
	local re1="^set[[:space:]]+.ws[0-9]+[[:space:]]+[\"\']([0-9]+)(:([[:alnum:][:space:]]+))?[\"\'][[:space:]]*$"
	while read -r line
	do
		[[ $line =~ $re1 ]] && WSpaces+=("${BASH_REMATCH[1]}${BASH_REMATCH[2]}")
	done < $i3config
	########
	# DEBUG
	# echo "WSpaces: $WSpaces"
	# echo "$ws_num: ${WSpaces[$ws_num]}"
	# echo "No 3: ${WSpaces[3]}"
	# for i in ${!WSpaces[@]}; do echo "$i :: ${WSpaces[$i]}"; done
	########
	# Have a choice here. Call each time, or write out WS_config file
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
