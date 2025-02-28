alias b := boot
alias u := upgrade
alias s := switch
alias t := test
alias fl := fix-lanzaboote
alias update := upgrade

default:
    @just --list

test:
    nh os test

boot:
    nh os boot

upgrade: 
    nh os switch -u

switch:
    nh os switch

fix-lanzaboote:
    nh clean all -k 3 -K 4d
    sudo rm /boot/EFI/nixos/ -r
    just s
