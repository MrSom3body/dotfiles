{ ... }:
{
  imports = [
    # bundles
    ./bundles
    ./cli.nix

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
    ./less.nix
    ./ntfy.nix
    ./pay-respects.nix
    ./ssh.nix
    ./tealdeer.nix
    ./zoxide.nix

    # fetches
    ./gotcha.nix
  ];
}
