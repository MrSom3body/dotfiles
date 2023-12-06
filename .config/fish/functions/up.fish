function up -d "Update the system"
    # Update Python packages
    for pkg in (pip list --user --outdated | awk 'NR<3 {next} {print $1}')
        pip install -U $pkg
    end

    # Update Rust packages
    for file in ~/.cargo/bin/*
        cargo install (basename $file)
    end

    # Update flatpaks
    flatpak upgrade -y

    # Download system updates
    sudo dnf offline-upgrade download -y
end
