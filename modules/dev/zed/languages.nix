{ self, lib, ... }:
{
  flake.modules.homeManager.dev =
    { osConfig, pkgs, ... }:
    {
      programs.zed-editor = {
        extensions = [
          "django"
          "git-firefly"
          "html"
          "ltex"
          "nix"
          "typst"
        ];

        userSettings = {
          languages = {
            nix.languages-servers = [
              "!nil"
            ];
            Django.language_servers = [
              "django-template-lsp"
              "!django-language-server"
            ];
          };

          lsp = {
            nixd = {
              binary.path = lib.getExe pkgs.nixd;
              settings.nixd = {
                formatting.command = [ (lib.getExe pkgs.nixfmt) ];
                options =
                  let
                    flake = ''(builtins.getFlake "${self}")'';
                    nixos-expr = "${flake}.nixosConfigurations.${osConfig.networking.hostName}.options";
                  in
                  {
                    nixos.expr = nixos-expr;
                    home-manager.expr = "${nixos-expr}.home-manager.users.type.getSubOptions []";
                  };
              };
            };
          };
        };
      };
    };
}
