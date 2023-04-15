### PATH ###
fish_add_path ~/.local/bin/
fish_add_path ~/Applications/
fish_add_path ~/.local/share/JetBrains/Toolbox/scripts/
fish_add_path ~/.spicetify/

### FISH ###
set -g fish_greeting

### VARIABLES ###
set -gx BAT_THEME ansi
set -gx MANGOHUD 1

### INTERACTIVE ###
if status is-interactive
    # Commands to run in interactive sessions can go here
    nitch
end

### DISCORD RPC ###
ln -sf $XDG_RUNTIME_DIR/{app/com.discordapp.Discord,}/discord-ipc-0

### STARSHIP ###
starship init fish | source
