# run `ln -s $(pwd) ~/.config/quickshell`
{ flake.modules.homeManager.desktop = { pkgs, ... }: { home.packages = [ pkgs.quickshell ]; }; }
