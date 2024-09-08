function up -d "Update the system"
    sudo echo Starting updates

    if test "$argv[1]" = auto
        set auto true
    end

    # Update system updates
    if test -n "$auto"
        sudo dnf --refresh upgrade -y
    else
        sudo dnf --refresh upgrade
    end

    # Update flatpaks
    if test -n "$auto"
        flatpak upgrade -y
    else
        flatpak upgrade
    end

    # sudo auto-cpufreq --update

    # Update Python packages
    # pipx upgrade-all

    # Update Rust packages
    CARGO_INSTALL_OPTS=--locked cargo install-update -a

    # Update fish plugins
    fisher update
end
