{ lib, inputs, ... }:
{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    {
      programs.helix.languages = {
        language = lib.singleton {
          name = "ios";
          scope = "source.ios";
          file-types = [ "ios" ];
          language-servers = [ "crillios-ls" ];
        };

        language-server.crillios-ls.command = lib.getExe inputs.crillios-ls.packages.${pkgs.system}.default;
      };
    };
}
