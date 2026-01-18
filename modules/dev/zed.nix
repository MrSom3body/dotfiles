{

  self,
  lib,
  ...
}:
{
  flake.modules.homeManager.dev =
    { osConfig, pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "django"
          "nix"
        ];
        userSettings = {
          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "claude-opus-4.5";
            };
          };
          vim_mode = true;
          telemetry = {
            diagnostics = false;
            metrics = false;
          };
          base_keymap = "Atom";
          load_direnv = "shell_hook";

          lsp = {
            nixd = {
              binary.path = lib.getExe pkgs.nixd;
              settings = {
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
