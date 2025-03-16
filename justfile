alias b := boot
alias s := switch
alias t := test
alias fl := fix-lanzaboote

default:
    @just --list

up INPUT="":
    nix flake update {{INPUT}}

iso:
    nix run nixpkgs#nix-fast-build -- --skip-cached --flake .#packages.x86_64-linux.default

[group("local")]
test:
    nh os test

[group("local")]
boot:
    nh os boot

[group("local")]
build:
    nh os build

[group("local")]
switch:
    nh os switch

[group("local")]
fix-lanzaboote:
    nh clean all -k 3 -K 4d
    sudo rm /boot/EFI/nixos/ -r
    just s

[group("srv")]
srv NAME MODE="switch":
    nixos-rebuild switch --flake .#{{NAME}} --target-host {{NAME}} --use-remote-sudo

[group("srv")]
srv-verbose NAME MODE="switch":
    nixos-rebuild switch --flake .#{{NAME}} --target-host {{NAME}} --use-remote-sudo --show-trace
