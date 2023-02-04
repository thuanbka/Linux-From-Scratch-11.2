MAKEFLAGS='-j4'
PACKAGES='/sources'

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


install_gettext()
{
    extract_package gettext-0.21.tar.xz
    cd gettext-0.21
    ./configure --disable-shared
    make $MAKEFLAGS
    cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
    remove_package gettext-0.21
}

install_bison()
{
    extract_package bison-3.8.2.tar.xz
    cd bison-3.8.2

    ./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
    make $MAKEFLAGS
    make install
    remove_package bison-3.8.2
}

install_perl()
{
    extract_package perl-5.36.0.tar.xz
    cd perl-5.36.0

    sh Configure -des                                       \
                -Dprefix=/usr                               \
                -Dvendorprefix=/usr                         \
                -Dprivlib=/usr/lib/perl5/5.36/core_perl     \
                -Darchlib=/usr/lib/perl5/5.36/core_perl     \
                -Dsitelib=/usr/lib/perl5/5.36/site_perl     \
                -Dsitearch=/usr/lib/perl5/5.36/site_perl    \
                -Dvendorlib=/usr/lib/perl5/5.36/vendor_perl \
                -Dvendorarch=/usr/lib/perl5/5.36/vendor_perl

    make $MAKEFLAGS
    make install
    remove_package perl-5.36.0
}

install_python()
{
    extract_package Python-3.10.6.tar.xz
    cd Python-3.10.6
    ./configure --prefix=/usr   \
                --enable-shared \
                --without-ensurepip
     
    make $MAKEFLAGS
    make install
    remove_package Python-3.10.6
}

install_texinfo()
{
    extract_package texinfo-6.8.tar.xz
    cd texinfo-6.8

    ./configure --prefix=/usr
    make $MAKEFLAGS
    make install
    remove_package texinfo-6.8
}

install_util_linux()
{
    extract_package util-linux-2.38.1.tar.xz
    cd util-linux-2.38.1
    mkdir -pv /var/lib/hwclock
    ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
                --libdir=/usr/lib    \
                --docdir=/usr/share/doc/util-linux-2.38.1 \
                --disable-chfn-chsh  \
                --disable-login      \
                --disable-nologin    \
                --disable-su         \
                --disable-setpriv    \
                --disable-runuser    \
                --disable-pylibmount \
                --disable-static     \
                --without-python     \
                runstatedir=/run
    make $MAKEFLAGS
    make install

    remove_package util-linux-2.38.1
}

install_gettext
install_bison
install_perl
install_python
install_texinfo
install_util_linux