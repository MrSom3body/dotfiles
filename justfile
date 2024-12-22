alias u := upgrade
alias update := upgrade

default:
    @just --list

switch:
    nh os switch -a

test:
    nh os test -a

boot:
    nh os boot -a

upgrade: 
    nh os switch -ua
