{ self, lib, ... }:
{
  flake.modules.homeManager.dev =
    { osConfig, pkgs, ... }:
    {
      programs.zed-editor = {
        extensions = [
          "django"
          "html"
          "nix"
        ];

        userSettings = {
          languages = {
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
