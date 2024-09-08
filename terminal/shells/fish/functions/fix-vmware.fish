function fix-vmware -d "Fix VMWare (again)..."
    echo "Stopping vmware..."
    sudo systemctl stop vmware
    set OLD_DIR (pwd)
    set VMWARE_VERSION (cat /etc/vmware/config | grep player.product.version | sed '/.*\"\(.*\)\".*/ s//\1/g')
    set TEMP_DIR (mktemp -d)

    cd $TEMP_DIR
    and echo "Cloning vmware-host-modules (branch workstation-$VMWARE_VERSION)"
    and git clone -b workstation-$VMWARE_VERSION https://github.com/mkubecek/vmware-host-modules.git
    and cd vmware-host-modules
    and echo "Patching vmmon"
    and make
    and sudo make install
    and echo "Starting vmware..."
    sudo systemctl start vmware
    cd $OLD_DIR
end
