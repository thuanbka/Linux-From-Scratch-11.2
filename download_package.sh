#!/bin/bash

LFS='/mnt/lfs'
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

check_package()
{
    pushd $LFS/sources
        md5sum -c md5sums
    popd
}

wget --input-file=wget-list-sysv --continue --directory-prefix=$LFS/sources
wget https://www.linuxfromscratch.org/lfs/view/11.2/md5sums --directory-prefix=$LFS/sources
check_package