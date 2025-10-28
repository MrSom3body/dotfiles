{
  flake.modules.homeManager.atuin =
    { osConfig, ... }:
    {
      programs = {
        atuin = {
          enable = true;
          flags = [ "--disable-up-arrow" ];
          settings = {
            # binds
            keymap_mode = "auto";

            # appearance
            style = "compact";
            inline_height = 20;

            # sync
            sync_address = "https://atuin.${osConfig.networking.domain}";
            sync_frequency = "5m";
          };
        };
      };
    };
}
