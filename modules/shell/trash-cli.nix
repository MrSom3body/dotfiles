{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.trash-cli ];

      programs = {
        fish.functions.rm = {
          body = "trash-put $argv";
          wraps = "trash-put";
        };

        bash.shellAliases.rm = "trash-put";
      };
    };
}
