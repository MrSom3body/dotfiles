{pkgs, ...}: {
  home.packages = with pkgs; [
    trash-cli
  ];

  home.shellAliases = {
    rm = "trash-put";
  };
}
