function up -d "Update the system"
    sudo echo Starting updates

    if test "$argv[1]" = auto
        set auto true
    end

    sudo dnf makecache >/dev/null &

    # Update Python packages
    for pkg in (pip list --user --outdated | awk 'NR<3 {next} {print $1}')
        pip install -U $pkg
    end

    # Update Rust packages
    for file in ~/.cargo/bin/*
        cargo install (basename $file)
    end

    # Update fish plugins
    fisher update

    # Update flatpaks
    if test -n "$auto"
        flatpak upgrade -y
    else
        flatpak upgrade
    end

    # Update system updates
    if test -n "$auto"
        sudo dnf offline-upgrade download -y
    else
        sudo dnf offline-upgrade download
    end
end
