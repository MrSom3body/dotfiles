{...}: {
  imports = [
    # bundles
    ./cli.nix
    ./networking.nix

    # programs
    ./bat.nix
    ./btop.nix
    ./comma.nix
    ./direnv.nix
    ./dust.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gitui.nix
    ./ripgrep.nix
    ./ssh.nix
    ./tealdeer.nix
    ./thefuck.nix
    ./trash-cli.nix
    ./xdg.nix
    ./yazi.nix
  ];
}
