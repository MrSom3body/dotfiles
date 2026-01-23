{
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    let
      wakatimeHome = "${config.xdg.configHome}/wakatime";
    in
    {
      sops = {
        secrets.wakatime-api-key.sopsFile = ../../secrets/wakatime.yaml;
        templates."wakatime.cfg".content = ''
          [settings]
          api_key = ${config.sops.placeholder.wakatime-api-key}
        '';
      };
      home = {
        packages = [ pkgs.wakatime-cli ];
        sessionVariables."WAKATIME_HOME" = wakatimeHome;
        file."${wakatimeHome}/.wakatime.cfg".source =
          config.lib.file.mkOutOfStoreSymlink
            config.sops.templates."wakatime.cfg".path;
      };
    };
}
