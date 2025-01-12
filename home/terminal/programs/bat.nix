{pkgs, ...}: {
  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batman
        prettybat
      ];
    };

    fish.functions = {
      man = {
        body = "batman";
        wraps = "eza";
      };
      cat = {
        body = "batman";
        wraps = "eza";
      };
    };

    bash.shellAliases = {
      cat = "bat";
      man = "batman";
    };
  };
}
