alias b := boot
alias s := switch
alias t := test
alias fl := fix-lanzaboote

default:
    @just --list

up INPUT="":
    nix flake update {{INPUT}}

[group("local")]
test:
    sudo nixos-rebuild test --flake .

[group("local")]
boot:
    sudo nixos-rebuild boot --flake .

[group("local")]
build:
    sudo nixos-rebuild build --flake .

[group("local")]
switch:
    sudo nixos-rebuild switch --flake .

[group("local")]
fix-lanzaboote:
    nh clean all -k 3 -K 4d
    sudo rm /boot/EFI/nixos/ -r
    just s

[group("srv")]
srv NAME MODE="switch":
    nixos-rebuild switch --flake .#{{NAME}} --target-host {{NAME}} --use-remote-sudo

srv-verbose NAME MODE="switch":
    nixos-rebuild switch --flake .#{{NAME}} --target-host {{NAME}} --use-remote-sudo --show-trace
