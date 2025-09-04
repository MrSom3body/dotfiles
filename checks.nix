{
  inputs,
  pkgs,
  ...
}:
{
  pre-commit-check = inputs.git-hooks-nix.lib.${pkgs.system}.run {
    src = ./.;
    excludes = [ "hardware-configuration.nix" ];
    hooks = {
      # nix
      deadnix.enable = true;
      nil.enable = true;
      nixfmt-rfc-style.enable = true;
      statix = {
        enable = true;
        settings.ignore = [ "hardware-configuration.nix" ];
      };

      # markdown
      markdownlint = {
        enable = true;
        settings.configuration = {
          line-length.tables = false;
          no-inline-html = false;
        };
      };
    };
  };
}
