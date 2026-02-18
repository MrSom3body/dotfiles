flake := env("NH_FLAKE", justfile_directory())
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

todo:
    @echo TO-DOs in:
    @rg --files-with-matches TODO || echo "Everything's done!"


# ---------- dev ---------- #

[group("dev")]
up *inputs:
    nix flake update {{inputs}} \
        --flake {{flake}} \
        --refresh \
        --commit-lock-file \
        --commit-lockfile-summary "flake.lock: update {{ if inputs != "" { inputs } else { "" } }}"

[group("dev")]
check *args:
    nix flake check {{args}}

# ---------- local ---------- #

[group("local")]
build *args: (builder "build" args)

[group("local")]
test *args: (builder "test" args)

[group("local")]
boot *args: (builder "boot" args)

[group("local")]
switch *args: (builder "switch" args)

[group("local")]
fix-lanzaboote: && boot
    nh clean all -k 3 -K 4d
    sudo rm /boot/EFI/nixos/ -rf

[group("local")]
fix-hyprlock:
    pkill hyprlock || true
    hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'
    hyprctl --instance 0 'dispatch exec hyprlock'
    pidwait -n hyprlock
    hyprctl --instance 0 'keyword misc:allow_session_lock_restore 0'


# ---------- deploy ---------- #

[group("deploy")]
install hostname ip=hostname:
    nix run github:nix-community/nixos-anywhere -- \
        --flake "{{flake}}#{{hostname}}" --target-host "root@{{ip}}" \
        --generate-hardware-config nixos-generate-config "{{flake}}/hosts/{{hostname}}/hardware-configuration.nix"


[group("deploy")]
deploy hostname *args:
    just builder switch \
        --hostname "{{hostname}}" \
        --target-host "{{hostname}}" \
        {{args}}

[group("deploy")]
deploy-all *args:
    just deploy pandora {{args}}


# ---------- iso ---------- #

[group("iso")]
build-iso iso_name="sanctuary":
    nix-fast-build --skip-cached --flake "{{flake}}#images.{{iso_name}}"


# ---------- others ---------- #

[group("others")]
builder mode *args:
    nh os {{mode}} {{args}}
