alias b := boot
alias u := upgrade
alias s := switch
alias t := test
alias update := upgrade

default:
    @just --list

test:
    nh os test -a

boot:
    nh os boot -a

upgrade: 
    nh os switch -ua

switch:
    nh os switch -a
