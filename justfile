alias u := upgrade
alias update := upgrade

upgrade:
    nh os switch -u
    git add flake.lock
    git commit flake.lock -m "flake.lock: update"
