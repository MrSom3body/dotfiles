{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      defaults = import ./_firefoxSettings.nix { inherit pkgs; };
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;
        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          inherit (defaults) settings search;
          mods = [
            "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
            "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
            "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
            "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
            "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
            "fd24f832-a2e6-4ce9-8b19-7aa888eb7f8e" # Quietify
          ];
        };
      };
    };
}
