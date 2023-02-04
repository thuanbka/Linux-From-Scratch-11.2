MAKEFLAGS='-j3'
# LFS='/mnt/lfs'
PACKAGES='/mnt/lfs/sources'
PATH_CONFIG='/mnt/lfs/scripts/config_kernel'

cd $PACKAGES
cd linux-5.19.2
make mrproper
cp PATH_CONFIG .config
make $MAKEFLAGS
make modules_install
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.19.2-lfs-11.2
cp -iv System.map /boot/System.map-5.19.2
cp -iv .config /boot/config-5.19.2
install -d /usr/share/doc/linux-5.19.2
cp -r Documentation/* /usr/share/doc/linux-5.19.2

#Configuring Linux Module Load Order
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

