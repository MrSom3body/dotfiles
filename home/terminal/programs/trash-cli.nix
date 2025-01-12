{pkgs, ...}: {
  home.packages = with pkgs; [
    trash-cli
  ];

  programs = {
    fish.functions.rm = {
      body = "trash-put";
      wraps = "trash-put";
    };

    bash.shellAliases.rm = "trash-put";
  };
}
