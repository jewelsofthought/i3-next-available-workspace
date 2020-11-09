# I3 Next Available Workspace
Simple bash script to open new workspace in i3 tiling window manager without having to specify a number. Can also move containers to new workspace.


## Dependencies
- jq

## Usage
Make sure the script is executable.

Add the following lines to your i3 `.config` file:
```
bindsym $mod+Shift+n exec --no-startup-id /path/to/script -m  # move container to new window
bindsym $mod+n exec --no-startup-id /path/to/script
```
Change the bindings as you wish.