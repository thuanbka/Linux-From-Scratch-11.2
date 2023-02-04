LFS='/mnt/lfs'

create_limit_directory()
{
    mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
    for i in bin lib sbin; do
        ln -sv usr/$i $LFS/$i
    done

    case $(uname -m) in
        x86_64) mkdir -pv $LFS/lib64 ;;
    esac

    mkdir -pv $LFS/tools
}

add_lfs_user()
{
    groupadd lfs
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs
    passwd lfs
    chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
    case $(uname -m) in
        x86_64) chown -v lfs $LFS/lib64 ;;
    esac

    su - lfs
}

create_limit_directory
add_lfs_user