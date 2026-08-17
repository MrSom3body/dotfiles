{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.server = { config, pkgs, ... }: {
    sops.secrets.caddy = {
      sopsFile = ../../secrets/caddy.env;
      format = "dotenv";
    };

    services = {
      caddy = {
        enable = true;
        environmentFile = config.sops.secrets.caddy.path;
        globalConfig = ''
          acme_dns cloudflare {$CF_TOKEN}
          servers {
            trusted_proxies static 127.0.0.0/8 ::1/128
            trusted_proxies_strict
            client_ip_headers Cf-Connecting-Ip X-Forwarded-For
          }
        '';
        extraConfig = ''
          (anubis) {
            reverse_proxy {args[0]} {
              header_up X-Real-Ip {client_ip}
            }
          }

          (oauth2) {
            @not_oauth2 not path /oauth2/*
            forward_auth @not_oauth2 ${meta.services.oauth2-proxy.url} {
              uri /oauth2/auth?allowed_groups={args[0]}
              copy_headers X-Auth-Request-User X-Auth-Request-Email

              # 401 = no (or expired) session, 403 = valid session but missing group
              @unauthenticated status 401
              handle_response @unauthenticated {
                redir ${meta.services.oauth2-proxy.url}/oauth2/start?rd={scheme}://{host}{uri}
              }

              @forbidden status 403
              handle_response @forbidden {
                respond "Access Denied - You do not have the required role ({args[0]}) to access this service." 403
              }
            }
          }

          (oauth2_routes) {
            handle /oauth2/sign_out {
              redir ${meta.services.oauth2-proxy.url}/oauth2/sign_out?rd=https%3A%2F%2F${meta.services.kanidm.domain}%2Fui%2Flogout
            }

            handle /oauth2/* {
              redir ${meta.services.oauth2-proxy.url}{path}?rd={scheme}://{host}/
            }
          }
        '';
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/cloudflare@v0.2.3" ];
          hash = "sha256-to0fhW7LWBocw1ccpPQ7e2nod7iJO9gkWZpjHsZDeu4=";
        };
      };
    };
  };
}
