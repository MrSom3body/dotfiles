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
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/dotfiles\").nixosConfigurations.${dotfiles.hostname}.options";
            };

            home-manager = {
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/dotfiles\").homeManagerConfigurations.${dotfiles.username}.options";
            };
          };
        };
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-languageserver";
      };
    };

    language = [
      {
        name = "nix";
        language-servers = ["nixd"];
      }
    ];
  };
}
