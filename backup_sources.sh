LFS='/mnt/lfs'

umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}

cd $LFS
tar --exlude="sources" -cJpvf $HOME/lfs-temp-tools-11.2.tar.xz .