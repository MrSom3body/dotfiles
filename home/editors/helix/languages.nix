{
  config,
  lib,
  pkgs,
  dotfiles,
  ...
}: {
  programs.helix.languages = {
    language-server = {
      # nil = {
      #   command = lib.getExe pkgs.nil;
      #   config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
      # };
      nixd = {
        command = lib.getExe pkgs.nixd;
        config.nixd = {
          formatting = lib.getExe pkgs.alejandra;

          options = {
            nixos = {
              expr = "(builtins.getFlake \"${dotfiles.path}\").nixosConfigurations.${dotfiles.hostname}.options";
            };

            home-manager = {
              expr = "(builtins.getFlake \"${dotfiles.path}\").homeManagerConfigurations.${dotfiles.username}.options";
            };
          };
        };
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-languageserver";
      };

      marksman = {
        command = lib.getExe pkgs.marksman;
      };
    };

    language = [
      {
        name = "nix";
        language-servers = ["nixd"];
        auto-format = true;
      }
      {
        name = "markdown";
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "markdown"];
        };
        auto-format = true;
      }
    ];
  };
}
