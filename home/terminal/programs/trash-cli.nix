{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      trash-cli
    ];

    shellAliases = {
      rm = "trash-put";
    };
  };
}
