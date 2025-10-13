{
  flake.modules.homeManager.firefox =
    { pkgs, ... }:
    let
      defaults = import ./_firefoxSettings.nix { inherit pkgs; };
    in
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-beta-bin;

        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = defaults.settings // {
            "browser.tabs.groups.enabled" = true;
            "browser.tabs.groups.smart.enabled" = true;
            "sidebar.verticalTabs" = true;
          };

          inherit (defaults) search;
        };
      };
    };
}
