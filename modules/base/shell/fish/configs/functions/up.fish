function up -d "Update the system"
    function print_help
        echo "Usage: $script_name [options]"
        echo "Options:"
        echo "-h, --help     Display this help message"
        echo "-y, --yes      Automatic yes to prompts"
        echo "-r, --reboot   Reboot after updates"
        echo "-s, --shutdown Shutdown after updates"
    end

    function _check_command
        if which $argv[1] &>/dev/null
            return 0
        else
            return 1
        end
    end

    set options h/help
    set options $options y/yes
    set options $options r/reboot
    set options $options s/shutdown
    argparse -x reboot,shutdown $options -- $argv
    or return

    if set -ql _flag_help
        print_help
        return
    end

    if _check_command apt
        sudo apt update
        if set -ql _flag_yes
            sudo apt upgrade -y
        else
            sudo apt upgrade
        end
    end

    if _check_command dnf
        if set -ql _flag_yes
            sudo dnf --refresh upgrade -y
        else
            sudo dnf --refresh upgrade
        end
    end

    if _check_command pacman
        if set -ql _flag_yes
            sudo pacman -Syu --noconfirm
        else
            sudo pacman -Syu
        end
    end

    if _check_command zypper
        if set -ql _flag_yes
            sudo zypper update -y
        else
            sudo zypper update
        end
    end

    if _check_command flatpak
        if set -ql _flag_yes
            flatpak update -y
        else
            flatpak update
        end
    end

    if _check_command pipx
        pipx upgrade-all
    end

    if _check_command cargo
        if _check_command cargo-install-update
            CARGO_INSTALL_OPTS=--locked cargo install-update -a
        else
            # Read user input if he wants to install cargo-install-update
            read -P "cargo-install-update is not installed. Do you want to install it? [Y/n] " install_cargo_install_update
            if test -z $install_cargo_install_update -o $install_cargo_install_update = Y -o $install_cargo_install_update = y
                cargo install cargo-update
            end
        end
    end

    if _check_command fisher
        fisher update
    end

    if set -ql _flag_reboot
        systemctl reboot
    end

    if set -ql _flag_shutdown
        systemctl poweroff
    end
end
