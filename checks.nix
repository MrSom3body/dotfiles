{
  inputs,
  pkgs,
  ...
}: {
  pre-commit-check = inputs.git-hooks-nix.lib.${pkgs.system}.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      markdownlint = {
        enable = true;
        settings.configuration = {
          line-length.tables = false;
          no-inline-html = false;
        };
      };
      nil.enable = true;
      statix.enable = true;
    };
  };
}
