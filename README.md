# 🖥️ MrSom3body/dotfiles

Welcome to my dotfiles repository! These configurations are tailored to my system but can be adapted for other setups. Note that you will need to customize the `hosts/` directory with your own system-specific profiles.

## 📦 Installation

To get started, first enable Flakes and the Nix command. You can find instructions here.

```bash
# Clone the repository
git clone https://github.com/MrSom3body/dotfiles

# Navigate into the directory
cd dotfiles

# Edit settings to fit your configuration
$EDITOR settings.nix

# Apply the dotfiles using NixOS
sudo nixos-rebuild switch --flake .

# Reboot your system to ensure all changes take effect
reboot
```

## 💾 Credits & Resources

I’ve drawn inspiration from these fantastic projects:

- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [librephoenix/nixos-config](https://github.com/librephoenix/nixos-config)
- and many more

Feel free to explore, adapt, and contribute!
