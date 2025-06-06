{pkgs, ...}: {
  programs = {
    bat = {
      enable = true;
      extraPackages = builtins.attrValues {
        inherit
          (pkgs.bat-extras)
          batman
          prettybat
          ;
      };
    };

    fish.functions = {
      man = {
        body = "batman $argv";
        wraps = "batman";
      };
      cat = {
        body = "bat $argv";
        wraps = "bat";
      };
    };

    bash.shellAliases = {
      cat = "bat";
      man = "batman";
    };
  };
}
