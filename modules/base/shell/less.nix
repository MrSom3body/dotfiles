{ lib, ... }:
# options copied from NotAShelf
let
  pagerArgs = [
    "--RAW-CONTROL-CHARS"
    "--LONG-PROMPT"
    "--no-vbell"
    "--wordwrap"
  ];
  PAGER = "less -FR";
  LESS = lib.concatStringsSep " " pagerArgs;
  SYSTEMD_LESS = lib.concatStringsSep " " (
    pagerArgs
    ++ [
      "--quit-if-one-screen"
      "--chop-long-lines"
      "--no-init"
    ]
  );
  SYSTEMD_PAGERSECURE = "true";
in
{
  flake.modules = {
    nixos.nixos = {
      environment.sessionVariables = {
        inherit
          PAGER
          LESS
          SYSTEMD_LESS
          SYSTEMD_PAGERSECURE
          ;
      };
    };
    homeManager.homeManager = {
      home.sessionVariables = {
        inherit
          PAGER
          LESS
          SYSTEMD_LESS
          SYSTEMD_PAGERSECURE
          ;
      };
    };
  };
}
