# Reproduce TPP paper, ASPLOS 2023


### Clone 

    git clone --recursive git@github.com:PKUZHOU/tpp_reproduce.git

### Build QEMU

```bash
cd qemu
git submodule init
git submodule update --recursive
./configure  --target-list=x86_64-softmmu
make -j
```
QEMU binary is: 
`./qemu/x86_64-softmmu/qemu-system-x86_64` 

### Build Linux Kernel 

```bash
cd linux-5.12
cp /boot/config-$(uname -r) .config

#You may also need to make sure that CONFIG_SYSTEM_TRUSTED_KEYS="" in .config

make menuconfig
Processor type and features ---->   
    [] Randomize the address of the kernel image (KASLR)
```

### Build ubuntu-18.04 rootfs

```bash
mkdir images
cd images
# then refer to qemu-ubuntu-from-base/README.md
dd if=/dev/zero of=rootfs.img bs=8192 count=1024000 status=progress
# several steps..
# ...
# after mounting to /mnt/tmp
sudo cp -r ubuntu-base-18.04/* /mnt/tmp/
# resolv.conf shell be replaced in order to use network
sudo cp /etc/resolv.conf /mnt/tmp/etc/resolv.conf
# files under /dev, /sys and /proc shell be mounted on the rootfs, and this can be done via chroot.sh
sudo ./qemu-ubuntu-from-base/chroot.sh /mnt/tmp
mkdir /tmp
chmod 1777 /tmp # change the permissions to 1777
# do apt things
# Install necessary packages like git
```

TODO: Prepare workloads


### 