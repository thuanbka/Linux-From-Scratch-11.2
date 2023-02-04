MAKEFLAGS='-j3'
PACKAGES='/mnt/lfs/sources'

extract_package()
{
    cd $PACKAGES
    tar -xvf $1
}

remove_package()
{
    cd $PACKAGES
    rm -rf $1
}

install_m4()
{
    extract_package m4-1.4.19.tar.xz
    cd m4-1.4.19

    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)
    
    make $MAKEFLAGS
    make DESTDIR=$LFS install
    remove_package m4-1.4.19
}

install_ncurses()
{
    extract_package ncurses-6.3.tar.gz
    cd ncurses-6.3

    sed -i s/mawk// configure
    mkdir build
    pushd build
        ../configure
        make -C include
        make -C progs tic
    popd

    ./configure --prefix=/usr                \
                --host=$LFS_TGT              \
                --build=$(./config.guess)    \
                --mandir=/usr/share/man      \
                --with-manpage-format=normal \
                --with-shared                \
                --without-normal             \
                --with-cxx-shared            \
                --without-debug              \
                --without-ada                \
                --disable-stripping          \
                --enable-widec
    make $MAKEFLAGS
    make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
    echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

    remove_package ncurses-6.3
}

install_bash()
{
    extract_package bash-5.1.16.tar.gz
    cd bash-5.1.16

    ./configure --prefix=/usr                   \
                --build=$(support/config.guess) \
                --host=$LFS_TGT                 \
                --without-bash-malloc

    make $MAKEFLAGS
    make DESTDIR=$LFS install
    ln -sv bash $LFS/bin/sh

    remove_package bash-5.1.16
}

install_coreutils()
{
    extract_package coreutils-9.1.tar.xz
    cd coreutils-9.1

    ./configure --prefix=/usr                     \
                --host=$LFS_TGT                   \
                --build=$(build-aux/config.guess) \
                --enable-install-program=hostname \
                --enable-no-install-program=kill,uptime
    
    make $MAKEFLAGS
    make DESTDIR=$LFS install
    mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
    mkdir -pv $LFS/usr/share/man/man8
    mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

    remove_package coreutils-9.1
}

install_diffutils()
{
    extract_package diffutils-3.8.tar.xz
    cd diffutils-3.8

    ./configure --prefix=/usr --host=$LFS_TGT
    make $MAKEFLAGS
    make DESTDIR=$LFS install
    remove_package diffutils-3.8
}

install_file()
{
    extract_package file-5.42.tar.gz
    cd file-5.42

    mkdir build
    pushd build
        ../configure --disable-bzlib      \
                    --disable-libseccomp \
                    --disable-xzlib      \
                    --disable-zlib
        make
    popd
    
    ./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
    make FILE_COMPILE=$(pwd)/build/src/file
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/libmagic.la
    
    remove_package file-5.42
}

install_findutils()
{
    extract_package findutils-4.9.0.tar.xz
    cd findutils-4.9.0
    ./configure --prefix=/usr                   \
                --localstatedir=/var/lib/locate \
                --host=$LFS_TGT                 \
                --build=$(build-aux/config.guess)
    make $MAKEFLAGS
    make DESTDIR=$LFS install
    remove_package findutils-4.9.0
}

install_gawk()
{
    extract_package gawk-5.1.1.tar.xz
    cd gawk-5.1.1
    sed -i 's/extras//' Makefile.in
    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)
    make $MAKEFLAGS
    make DESTDIR=$LFS install
    remove_package gawk-5.1.1
}


install_grep()
{
    extract_package grep-3.7.tar.xz
    cd grep-3.7

    ./configure --prefix=/usr   \
                --host=$LFS_TGT
    make $MAKEFLAGS
    make DESTDIR=$LFS install

    remove_package grep-3.7
}

install_gzip()
{
    tar -xvf gzip-1.12.tar.xz
    cd gzip-1.12

    ./configure --prefix=/usr --host=$LFS_TGT
    make $MAKEFLAGS
    make DESTDIR=$LFS install

    remove_package gzip-1.12
}

install_make()
{
    extract_package make-4.3.tar.gz
    cd make-4.3

    ./configure --prefix=/usr   \
                --without-guile \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)
    make $MAKEFLAGS
    make DESTDIR=$LFS install

    remove_package make-4.3
}

isntall_patch()
{
    extract_package patch-2.7.6.tar.xz
    cd patch-2.7.6

    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)
    make $MAKEFLAGS
    make DESTDIR=$LFS install
       
    remove_package patch-2.7.6
}

install_sed()
{
    extract_package sed-4.8.tar.xz
    cd sed-4.8

    ./configure --prefix=/usr   \
                --host=$LFS_TGT
    make $MAKEFLAGS
    make DESTDIR=$LFS install

    remove_package sed-4.8
}

install_tar()
{
    extract_package tar-1.34.tar.xz
    cd tar-1.34

    ./configure --prefix=/usr                     \
                --host=$LFS_TGT                   \
                --build=$(build-aux/config.guess)
    make $MAKEFLAGS
    make DESTDIR=$LFS install

    remove_package tar-1.34
}

install_xz()
{
    extract_package xz-5.2.6.tar.xz
    cd xz-5.2.6

    ./configure --prefix=/usr                     \
                --host=$LFS_TGT                   \
                --build=$(build-aux/config.guess) \
                --disable-static                  \
                --docdir=/usr/share/doc/xz-5.2.6
    make $MAKEFLAGS
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/liblzma.la

    remove_package xz-5.2.6
}

install_binutil_pass2()
{
    extract_package binutils-2.39.tar.xz
    cd binutils-2.39
    
    sed '6009s/$add_dir//' -i ltmain.sh
    mkdir -v build
    cd build
    ../configure                   \
        --prefix=/usr              \
        --build=$(../config.guess) \
        --host=$LFS_TGT            \
        --disable-nls              \
        --enable-shared            \
        --enable-gprofng=no        \
        --disable-werror           \
        --enable-64-bit-bfd

    make $MAKEFLAGS
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la}

    remove_package binutils-2.39
}

install_gcc_pass2()
{
    extract_package gcc-12.2.0.tar.xz
    cd gcc-12.2.0

    tar -xf ../mpfr-4.1.0.tar.xz
    mv -v mpfr-4.1.0 mpfr
    tar -xf ../gmp-6.2.1.tar.xz
    mv -v gmp-6.2.1 gmp
    tar -xf ../mpc-1.2.1.tar.gz
    mv -v mpc-1.2.1 mpc

    case $(uname -m) in
        x86_64)
            sed -e '/m64=/s/lib64/lib/' \
                -i.orig gcc/config/i386/t-linux64
        ;;
    esac

    sed '/thread_header =/s/@.*@/gthr-posix.h/' \
        -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

    mkdir -v build
    cd build

    ../configure                                       \
        --build=$(../config.guess)                     \
        --host=$LFS_TGT                                \
        --target=$LFS_TGT                              \
        LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
        --prefix=/usr                                  \
        --with-build-sysroot=$LFS                      \
        --enable-initfini-array                        \
        --disable-nls                                  \
        --disable-multilib                             \
        --disable-decimal-float                        \
        --disable-libatomic                            \
        --disable-libgomp                              \
        --disable-libquadmath                          \
        --disable-libssp                               \
        --disable-libvtv                               \
        --enable-languages=c,c++

    make $MAKEFLAGS
    make DESTDIR=$LFS install
    ln -sv gcc $LFS/usr/bin/cc

    remove_package gcc-12.2.0

}

install_m4
install_ncurses
install_bash
install_coreutils
install_diffutils
install_file
install_findutils
install_gawk
install_grep
install_gzip
install_make
isntall_patch
install_sed
install_tar
install_xz
install_binutil_pass2
install_gcc_pass2
