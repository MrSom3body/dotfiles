alias b := boot
alias s := switch
alias t := test
alias fl := fix-lanzaboote
alias d := deploy

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
    sudo rm /boot/EFI/nixos/ -rf
    just boot

[group("deploy")]
install NAME HOST=NAME:
    nix run github:nix-community/nixos-anywhere -- \
        --flake .#{{NAME}} --target-host root@{{HOST}} \
        --generate-hardware-config nixos-generate-config ./hosts/{{NAME}}/hardware-configuration.nix

[group("deploy")]
deploy NAME MODE="switch":
    nh os {{MODE}} -H {{NAME}} --target-host root@{{NAME}}

[group("deploy")]
deploy-verbose NAME MODE="switch":
    nh os {{MODE}} -H {{NAME}} --target-host root@{{NAME}} -- --show-trace
