{
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    let
      wakatimeHome = "${config.xdg.configHome}/wakatime";
    in
    {
      sops.secrets.wakatime-api-key.sopsFile = ../../secrets/wakatime.yaml;
      home = {
        packages = [ pkgs.wakatime-cli ];
        sessionVariables."WAKATIME_HOME" = wakatimeHome;
        file."${wakatimeHome}/.wakatime.cfg".text = /* ini */ ''
          [settings]
          api_key_vault_command = cat "${config.sops.secrets.wakatime-api-key.path}"
        '';
      };
    };
}
