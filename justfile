machine_hostname := shell("hostname -s")

alias b := boot
alias s := switch
alias t := test
alias fl := fix-lanzaboote
alias fh := fix-hyprlock
alias d := deploy

[private]
default:
    @just --list


# ---------- local ---------- #

[group("local")]
up *inputs:
    nix flake update {{inputs}}

[group("local")]
build:
    @just build-machine

[group("local")]
test:
    @just test-machine

[group("local")]
boot:
    @just boot-machine

[group("local")]
switch:
    @just switch-machine

[group("local")]
fix-lanzaboote: && boot
    nh clean all -k 3 -K 4d
    sudo rm /boot/EFI/nixos/ -rf

[group("local")]
fix-hyprlock:
    hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
    hyprctl --instance 0 'dispatch exec hyprlock'
    hyprctl --instance 0 'keyword misc:allow_session_lock_restore 0'


# ---------- deploy ---------- #

[group("deploy")]
install hostname ip=hostname:
    nix run github:nix-community/nixos-anywhere -- \
        --flake ".#{{hostname}}" --target-host "root@{{ip}}" \
        --generate-hardware-config nixos-generate-config "./hosts/{{hostname}}/hardware-configuration.nix"


[group("deploy")]
deploy hostname mode="switch" *extra_flags:
    nh os {{mode}} -H "{{hostname}}" --target-host "root@{{hostname}}" -- {{extra_flags}}


# ---------- others ---------- #

[group("others")]
build-machine hostname=machine_hostname:
    nh os build . --hostname "{{hostname}}"

[group("others")]
test-machine hostname=machine_hostname:
    nh os test . --hostname "{{hostname}}"

[group("others")]
boot-machine hostname=machine_hostname:
    nh os boot . --hostname "{{hostname}}"

[group("others")]
switch-machine hostname=machine_hostname:
    nh os switch . --hostname "{{hostname}}"
 
[group("iso")]
build-iso iso_name="sanctuary":
    nix run nixpkgs#nix-fast-build -- --skip-cached --flake ".#images.{{iso_name}}"

