{ self, lib, ... }:
{
  flake.modules.homeManager.dev =
    { osConfig, pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "django"
          "html"
          "nix"
        ];
        userSettings = {
          # appearance
          relative_line_numbers = "enabled";
          buffer_line_height = "standard";
          inlay_hints.enabled = true;
          diagnostics.inline.enabled = true;

          # behaviour
          use_smartcase_search = true;
          load_direnv = "shell_hook";

          # bindings
          base_keymap = "Atom";
          vim_mode = true;

          # ai
          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "claude-opus-4.5";
            };
          };

          # languages
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

          telemetry = {
            diagnostics = false;
            metrics = false;
          };
        };
      };
    };
}
