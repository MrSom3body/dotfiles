{...}: {
  imports = [
    # bundles
    ./cli.nix
    ./networking.nix

    # programs
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./ripgrep.nix
    ./ssh.nix
    ./tealdeer.nix
    ./thefuck.nix
    ./trash-cli.nix
    ./xdg.nix
    ./yazi.nix
  ];
}
