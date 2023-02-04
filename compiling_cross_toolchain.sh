MAKEFLAGS='-j2'
# LFS='/mnt/lfs'
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


install_binutils_pass1()
{
    extract_package binutils-2.39.tar.xz
    cd binutils-2.39

    mkdir -v build
    cd build
    ../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror
    make $MAKEFLAGS
    make install
    remove_package binutils-2.39
}

install_gcc_pass1()
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

    mkdir -v build
    cd build

    ../configure                  \
        --target=$LFS_TGT         \
        --prefix=$LFS/tools       \
        --with-glibc-version=2.36 \
        --with-sysroot=$LFS       \
        --with-newlib             \
        --without-headers         \
        --disable-nls             \
        --disable-shared          \
        --disable-multilib        \
        --disable-decimal-float   \
        --disable-threads         \
        --disable-libatomic       \
        --disable-libgomp         \
        --disable-libquadmath     \
        --disable-libssp          \
        --disable-libvtv          \
        --disable-libstdcxx       \
        --enable-languages=c,c++

    make $MAKEFLAGS
    make install

    cd ..
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
    remove_package gcc-12.2.0
}

install_api_header()
{
    extract_package linux-5.19.2.tar.xz
    cd linux-5.19.2

    make mrproper
    make headers
    find usr/include -type f ! -name '*.h' -delete
    cp -rv usr/include $LFS/usr

    remove_package linux-5.19.2
}

install_glibc()
{
    extract_package glibc-2.36.tar.xz
    cd glibc-2.36

    case $(uname -m) in
        i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
        ;;
        x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
                ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
        ;;
    esac

    patch -Np1 -i ../glibc-2.36-fhs-1.patch
    mkdir -v build
    cd build
    echo "rootsbindir=/usr/sbin" > configparms

    ../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/usr/lib

    make $MAKEFLAGS
    make DESTDIR=$LFS install
    sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
    $LFS/tools/libexec/gcc/$LFS_TGT/12.2.0/install-tools/mkheaders

    remove_package glibc-2.36
}

install_libstdc()
{
    extract_package gcc-12.2.0.tar.xz
    cd gcc-12.2.0

    mkdir -v build
    cd build
    ../libstdc++-v3/configure           \
        --host=$LFS_TGT                 \
        --build=$(../config.guess)      \
        --prefix=/usr                   \
        --disable-multilib              \
        --disable-nls                   \
        --disable-libstdcxx-pch         \
        --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/12.2.0
    
    make $MAKEFLAGS
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/lib{stdc++,stdc++fs,supc++}.la
    remove_package install_gcc_pass1
}

install_binutils_pass1
install_gcc_pass1
install_api_header
install_glibc
install_libstdc