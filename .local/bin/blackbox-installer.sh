#!/bin/bash
# By Dr Amr Osman @dr3mro {gmail|twitter|github|gitlab}

# Installing blackbox terminal from flathub
flatpak install com.raggesilver.BlackBox

# creating a launcher for blackbox

sudo tee /usr/local/bin/blackbox <<EOF
#!/bin/bash
flatpak run com.raggesilver.BlackBox \$@
EOF

#making it executable
sudo chmod +x /usr/local/bin/blackbox

#modify applications launchers to use the new terminal app, you need to re-excute the script in case you installed a new app that launches by terminal for example [ neovim, htop ]

for app in $(grep -rl Terminal=true /usr/share/applications); do
	dot_desktop=~/.local/share/applications/$(basename $app)
	sed 's\Exec=\Exec=/usr/local/bin/blackbox -c \' $app >"$dot_desktop"
	sed -i 's\Terminal=true\Terminal=false\g' "$dot_desktop"
	sed -i '/TryExec/d' "$dot_desktop"
	chmod +x "$dot_desktop"
done

#Now we need to set x-teminal-emulator symlink so apps can use it when needed but first we need to add blackbox to supported terminals
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/blackbox 50

#Now we set it the default
sudo update-alternatives --set x-terminal-emulator /usr/local/bin/blackbox

# make gnome use it
gsettings set org.gnome.desktop.default-applications.terminal exec x-terminal-emulator

# install open with any terminal nautilus addon, so you can right click and open a terminal in any directory
sudo dnf install nautilus-python
pip3 install --user nautilus-open-any-terminal
glib-compile-schemas ~/.local/share/glib-2.0/schemas/

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal blackbox
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab false

# restart nautilus
nautilus -q

# done
