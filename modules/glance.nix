{ config, lib, ... }:
let
  inherit (config) flake;
  inherit (flake) meta;
in
{
  flake.modules.nixos.glance = { config, ... }: {
    config = {
      services = {
        caddy.virtualHosts."${meta.services.glance.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.glance.port}
          '';
        };

        glance = {
          enable = true;
          settings = {
            server = {
              host = "127.0.0.1";
              inherit (meta.services.glance) port;
            };

            pages = [
              {
                name = "som3lab";
                hide-desktop-navigation = false;
                center-vertically = true;
                width = "slim";
                columns = [
                  {
                    size = "small";
                    widgets = [
                      {
                        type = "server-stats";
                        servers = lib.singleton {
                          type = "local";
                          name = config.networking.hostName;
                        };
                      }
                      {
                        type = "repository";
                        repository = "MrSom3body/dotfiles";
                        pull-requests-limit = 5;
                        issues-limit = 5;
                        commits-limit = 5;
                      }
                    ];
                  }
                  {
                    size = "full";
                    widgets =
                      let
                        allServices = flake.lib.getRunningServices flake |> lib.filterAttrs (_name: service: service.show);
                        privateServices = allServices |> lib.filterAttrs (_name: service: !service.public);
                        publicServices = allServices |> lib.filterAttrs (_name: service: service.public);
                        formatServices =
                          services:
                          services
                          |> lib.mapAttrsToList (
                            _name: service:
                            {
                              inherit (service) title url icon;
                            }
                            // lib.optionalAttrs (service.alt-status-codes != [ ]) {
                              "alt-status-codes" = service.alt-status-codes;
                            }
                          );
                      in
                      [
                        {
                          type = "monitor";
                          cache = "15s";
                          title = "Public Services";
                          sites = formatServices publicServices;
                        }
                        {
                          type = "monitor";
                          cache = "15s";
                          title = "Private Services";
                          sites = formatServices privateServices;
                        }
                      ];
                  }
                ];
              }
              {
                name = "Maintenance";
                width = "slim";
                columns = [
                  {
                    size = "small";
                    widgets = [
                      {
                        type = "search";
                        placeholder = "Search NixOS...";
                        bangs = [
                          {
                            title = "Packages";
                            shortcut = "!np";
                            url = "https://search.nixos.org/packages?channel=unstable&query={QUERY}";
                          }
                          {
                            title = "Options";
                            shortcut = "!no";
                            url = "https://search.nixos.org/options?channel=unstable&query={QUERY}";
                          }
                          {
                            title = "Nixpkgs PRs";
                            shortcut = "!pr";
                            url = "https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+{QUERY}";
                          }
                        ];
                      }
                      {
                        type = "rss";
                        title = "NixOS Blog";
                        style = "vertical-list";
                        limit = 5;
                        feeds = [
                          {
                            url = "https://nixos.org/blog/announcements-rss.xml";
                            title = "Announcements";
                          }
                        ];
                      }
                    ];
                  }
                  {
                    size = "full";
                    widgets = [
                      {
                        type = "custom-api";
                        title = "My Nix Activity";
                        cache = "15m";
                        url = "https://api.github.com/search/issues?q=org:NixOS+org:nix-community+is:open+involves:MrSom3body&sort=updated&order=desc";
                        template = /* html */ ''
                          <ul class="list list-gap-10 collapsible-container" data-collapse-after="5">
                          {{ range .JSON.Array "items" }}
                            <li>
                              <a href="{{ .String "html_url" }}" class="block" style="text-decoration: none; color: inherit;">
                                <div class="size-h4 color-highlight text-truncate">{{ .String "title" }}</div>
                                <ul class="list-horizontal-text">
                                  <li><span class="color-primary">{{ .String "repository_url" | trimPrefix "https://api.github.com/repos/" }}</span>#{{ .Int "number" }}</li>
                                  <li {{ .String "updated_at" | parseTime "RFC3339" | toRelativeTime }}></li>
                                  <li>by {{ .String "user.login" }}</li>
                                </ul>
                              </a>
                            </li>
                          {{ end }}
                          {{ if eq (.JSON.Array "items" | len) 0 }}
                            <li class="color-paragraph">No recent activity.</li>
                          {{ end }}
                          </ul>
                        '';
                      }
                      {
                        type = "releases";
                        title = "Upstream Releases";
                        show-source-icon = true;
                        collapse-after = 5;
                        limit = 10;
                        repositories = [
                          "lunatask/lunatask"
                          "marty-oehme/bemoji"
                        ];
                      }
                      {
                        type = "rss";
                        title = "Upstream Tags";
                        style = "vertical-list";
                        limit = 10;
                        feeds = [
                          {
                            url = "https://github.com/timvisee/send/tags.atom";
                            title = "timvisee/send";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };
}
