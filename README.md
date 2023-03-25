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

# make sure that 
CONFIG_PCI=y
CONFIG_E1000=y


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

# avoid ttyS0 not found error
cd /etc/systemd/system/getty.target.wants
cp -d getty\@tty1.service getty\@ttyS0.service 


```

### Build ubuntu-18.04 in a simple way (recommended)
```bash
# Create raw image
qemu-img create -f raw ubuntu18.raw 10G
# Format 
mkfs.ext4 ubuntu18.raw

# Load image as a loop device
sudo losetup -f -P ubuntu18.raw

# Check which loop device 
sudo losetup -a

sudo mount -o sync /dev/loopxx /mnt/tmp
# Mount the image
# Install ubuntu using debootstrap
sudo debootstrap --arch=amd64 bionic /mnt/point  http://archive.ubuntu.com/ubuntu/

sudo chroot.sh /mnt/tmp
```
TODO: Prepare workloads


### Run

```bash
# Why do I need to setup nic manually?
ip link set ens3 up
dhclient 
# Then can use ssh to connect
```