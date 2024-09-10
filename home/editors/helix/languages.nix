{
  lib,
  pkgs,
  dotfiles,
  ...
}: {
  programs.helix.languages = {
    language-server = {
      marksman = {
        command = lib.getExe pkgs.marksman;
      };

      nixd = {
        command = lib.getExe pkgs.nixd;
        config.nixd = {
          formatting = lib.getExe pkgs.alejandra;
          options = {
            nixos = {expr = "(builtins.getFlake \"${dotfiles.path}\").nixosConfigurations.${dotfiles.hostname}.options";};
            home-manager = {expr = "(builtins.getFlake \"${dotfiles.path}\").homeManagerConfigurations.\"${dotfiles.username}\".options";};
          };
        };
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-languageserver";
      };

      vscode-html-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-languageserver";
      };

      vscode-json-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-languageserver";
      };
    };

    language = [
      {
        name = "markdown";
        formatter = {
          command = lib.getExe pkgs.nodePackages.prettier;
          args = ["--parser" "markdown"];
        };
        auto-format = true;
      }
      {
        name = "nix";
        language-servers = ["nixd"];
        auto-format = true;
      }
    ];
  };
}
