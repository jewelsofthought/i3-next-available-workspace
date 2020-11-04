## NOTES.md

Thank you to jytowbridge for the inspiration
in leading me in the correct direction. 

However, in delving deeper into the issue,
I found that there were many places I could 
improve on the way that the program behaved.

But let me start at the beginning. The method of 
extracting the name from the was what I needed. 

# $(i3-msg -t get_workspaces | jq '.[] | (.num)')

Perfect. 

However, there emerged, a new - although, perhaps personal - problem.
The new workspace was created with just a number - but what if I had
defined a name already for that workspace? Besides it looking bad, a
digit squeezed in amongst the workspace names. Sloppy. 

The easiest solution I came up with was to parse the i3config file,
and, if there were workspace names defined, 
# set $ws1 "1:Mail"
then use these. 

It took a some jiggling to get the regular expression correct, but 
once that was successful, I could then dynamically create the array
from i3config. So after fully packing the array with all the workspaces,
I then just checked if the index existed or not. If there was a missing
index, I had found my "next" workspace.

Otherwise, I just added another one to the end. Yes it was numerical 
(KISS) but it was tagged on the the end, and thus not "sloppy".

So that is what I did, and was satisfied with the result.

There was one other small issue. Unimportant but relevant, and that
the use of wmctrl. It did not function as expected, and I saw no reason
why I could not just use i3-msg. That was easy. 

So: 
    ACTIVE_WIN=$(xprop -id $(xdotool getactivewindow) | grep 'WM_NAME(STRING)' | cut -d'"' -f2)
    i3-msg move container to workspace $ws
    wmctrl -r $ACTIVE_WIN -b add,demands_attention

Became:
    i3-msg move container to workspace $ws
	i3-msg workspace $ws

Firstly, this was being called in the active window, thus all I had to do 
was move it to the new workspace, and then move the focus there, and 
voila! It was done.

I believe it is a slight improvement on jytowbridge's version. 
But, I thank you for helping me solve the issue.