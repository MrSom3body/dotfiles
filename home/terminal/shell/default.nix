{
  lib,
  dotfiles,
  ...
}: {
  imports = [
    ./bash.nix
    ./fish

    ./starship.nix
    ./zoxide.nix
  ];

  home.shellAliases = {
    ip = "ip -c";
    l = "ls";
    chat = lib.mkIf ((builtins.length dotfiles.ollamaModels) == 1) "ollama run llama3.2";
    mkdev = "nix flake new -t \"github:numtide/devshell\"";
  };

  home.sessionPath = ["$HOME/bin"];
}
