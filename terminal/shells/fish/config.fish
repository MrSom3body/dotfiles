### PATH ###
fish_add_path ~/.local/bin/
fish_add_path ~/.cargo/bin/
fish_add_path ~/Applications/
fish_add_path ~/.local/share/JetBrains/Toolbox/scripts/
fish_add_path ~/.spicetify/

### FISH ###
set -g fish_greeting

### VARIABLES ###
set -gx EDITOR nvim
set -gx BROWSER firefox
set -gx BAT_THEME ansi
set -gx MANGOHUD 1

### INTERACTIVE ###
if status is-interactive
    # Commands to run in interactive sessions can go here
    macchina
end

### VESKTOP RPC ###
ln -sf $XDG_RUNTIME_DIR/{.flatpak/dev.vencord.Vesktop/xdg-run,}/discord-ipc-0

### STARSHIP ###
starship init fish | source
