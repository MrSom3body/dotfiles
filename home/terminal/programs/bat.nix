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
        wraps = "batman";
      };
      cat = {
        body = "bat";
        wraps = "bat";
      };
    };

    bash.shellAliases = {
      cat = "bat";
      man = "batman";
    };
  };
}
