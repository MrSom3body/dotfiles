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
            Nix.language_servers = [
              "!nil"
              "..."
            ];
            Django.language_servers = [
              "django-template-lsp"
              "!django-language-server"
              "..."
            ];
          };

          lsp = {
            nixd = {
              initialization_options.formatting.command = [ (lib.getExe pkgs.nixfmt) ];
              binary.path = lib.getExe pkgs.nixd;
              settings.nixd = {
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
            tinymist = {
              settings = {
                exportPdf = "onType";
                outputPath = "$root/$name";
                lint = {
                  enabled = true;
                  when = "onType";
                };
              };
            };
          };
        };
      };
    };
}
