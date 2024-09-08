function ens -d "Sync hugo site to the easyname server"
    echo Starting sync
    set OLD_PWD (pwd)
    rm ~/Codes/Web/MrSom3body.github.io/public/ -rf
    cd ~/Codes/Web/MrSom3body.github.io/
    hugo
    rclone delete easyname:apps/hugo
    rclone sync ~/Codes/Web/MrSom3body.github.io/public/ easyname:apps/hugo
    cd $OLD_PWD
    echo Finished sync
end
