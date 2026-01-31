{
  flake.modules.homeManager.atuin =
    { osConfig, ... }:
    {
      programs = {
        atuin = {
          enable = true;
          settings = {
            workspaces = true;

            # binds
            keymap_mode = "auto";

            # appearance
            style = "compact";
            inline_height = 20;

            # sync
            sync_address = "https://atuin.${osConfig.networking.domain}";
            sync_frequency = "0";
          };
        };
      };

      programs.fish.binds."k" = {
        mode = "default";
        command = "_atuin_bind_up";
      };
    };
}
