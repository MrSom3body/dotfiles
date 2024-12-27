alias b := boot
alias u := upgrade
alias s := switch
alias t := test
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
