{
  imports = [
    ./transmission.nix
  ];

  users.groups.arr.members = [
    "transmission"
    "sonarr"
    "radarr"
  ];

  services = {
    jellyseerr.enable = true;

    prowlarr.enable = true;
    flaresolverr.enable = true;
    recyclarr = {
      enable = true;
      configuration = {
        sonarr.shows = {
          api_key = {
            _secret = "/run/credentials/recyclarr.service/sonarr-api-key";
          };
          base_url = "https://sonarr.sndh.dev";

          include = [
            { template = "sonarr-quality-definition-anime"; }

            { template = "sonarr-v4-quality-profile-anime"; }
            { template = "sonarr-v4-quality-profile-web-1080p"; }
            { template = "sonarr-v4-quality-profile-hd-bluray-web-german"; }

            { template = "sonarr-v4-custom-formats-anime"; }
            { template = "sonarr-v4-custom-formats-web-1080p"; }
            { template = "sonarr-v4-custom-formats-hd-bluray-web-german"; }
          ];

          custom_formats = [
            # uncensored
            {
              trash_ids = [
                "026d5aadd1a6b4e550b134cb6c72b3ca"
              ];
              assign_scores_to = [
                {
                  name = "Remux-1080p - Anime";
                  score = 101;
                }
              ];
            }
            # 10bit
            {
              trash_ids = [
                "b2550eb333d27b75833e25b8c2557b38"
              ];
              assign_scores_to = [
                {
                  name = "Remux-1080p - Anime";
                  score = 0;
                }
              ];
            }

            # anime dual audio
            {
              trash_ids = [
                "418f50b10f1907201b6cfdf881f467b7"
              ];
              assign_scores_to = [
                {
                  name = "Remux-1080p - Anime";
                  score = 0;
                }
              ];
            }
          ];
        };

        radarr.movies = {
          api_key = {
            _secret = "/run/credentials/recyclarr.service/radarr-api-key";
          };
          base_url = "https://radarr.sndh.dev";

          include = [
            { template = "radarr-quality-definition-movie"; }

            { template = "radarr-quality-profile-anime"; }
            { template = "radarr-quality-profile-hd-bluray-web"; }
            { template = "radarr-quality-profile-remux-web-1080p"; }
            { template = "radarr-quality-profile-hd-bluray-web-german"; }

            { template = "radarr-custom-formats-anime"; }
            { template = "radarr-custom-formats-hd-bluray-web"; }
            { template = "radarr-custom-formats-remux-web-1080p"; }
            { template = "radarr-custom-formats-hd-bluray-web-german"; }
          ];

          custom_formats = [
            # uncensored
            {
              trash_ids = [
                "064af5f084a0a24458cc8ecd3220f93f"
              ];
              assign_scores_to = [
                {
                  name = "Remux-1080p - Anime";
                  score = 101;
                }
              ];
            }
            # 10bit
            {
              trash_ids = [
                "a5d148168c4506b55cf53984107c396e"
              ];
              assign_scores_to = [
                {
                  name = "Remux-1080p - Anime";
                  score = 0;
                }
              ];
            }

            # anime dual audio
            {
              trash_ids = [
                "4a3b087eea2ce012fcc1ce319259a3be"
              ];
              assign_scores_to = [
                {
                  name = "Remux-1080p - Anime";
                  score = 0;
                }
              ];
            }
          ];
        };
      };
    };
    sonarr.enable = true;
    radarr.enable = true;
  };
}
