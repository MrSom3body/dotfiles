function fix-vmware -d "Fix VMWare (again)..."
    set VMWARE_VERSION (cat /etc/vmware/config | grep player.product.version | sed '/.*\"\(.*\)\".*/ s//\1/g')

    cd /tmp/
    git clone -b workstation-$VMWARE_VERSION https://github.com/mkubecek/vmware-host-modules.git
    cd vmware-host-modules
    make
    sudo make install
end
