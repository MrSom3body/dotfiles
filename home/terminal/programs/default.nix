{...}: {
  imports = [
    # bundles
    ./cli.nix
    ./networking.nix

    # development
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./gitui.nix
    ./tokei.nix

    # search
    ./fd.nix
    ./fzf.nix
    ./ripgrep.nix

    # files
    ./dust.nix
    ./trash-cli.nix
    ./yazi.nix

    # utils
    ./bat.nix
    ./btop.nix
    ./comma.nix
    ./eza.nix
    ./gpg.nix
    ./ssh.nix
    ./tealdeer.nix
    ./thefuck.nix
    ./xdg.nix
  ];
}
