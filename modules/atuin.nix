{
  flake.modules.homeManager.atuin =
    { osConfig, ... }:
    {
      programs = {
        atuin = {
          enable = true;
          settings = {
            keymap_mode = "auto";
            style = "auto";
            inline_height = 20;
            # sync
            sync_address = "https://atuin.${osConfig.networking.domain}";
            sync_frequency = "5m";
          };
        };

        fish.binds = {
          "k" = {
            command = "_atuin_bind_up";
            mode = "default";
          };
        };
      };
    };
}
