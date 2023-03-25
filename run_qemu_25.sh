# sudo ./qemu/build/x86_64-softmmu/qemu-system-x86_64 -name CXL_VM -machine type=pc,accel=kvm,mem-merge=off -enable-kvm -cpu host -smp cpus=8 -m 16384M -object memory-backend-ram,size=12288M,policy=bind,host-nodes=0,id=ram-node0,prealloc=on,prealloc-threads=8 -numa node,nodeid=0,cpus=0-7,memdev=ram-node0 -object memory-backend-ram,size=4096M,policy=bind,host-nodes=1,id=ram-node1,prealloc=on,prealloc-threads=8 -numa node,nodeid=1,memdev=ram-node1  -drive file=./images/rootfs.img,format=raw -net user,hostfwd=tcp::8080-:22 -net nic,model=virtio -device virtio-net,netdev=network0 -netdev tap,id=network0,ifname=tap0,script=no,downscript=no -kernel ./linux-5.12/arch/x86_64/boot/bzImage -append "root=/dev/sda1 console=ttyS0 rw" -nographic

IMG=./images/ubuntu18.raw
KERNEL=./kernels/linux5_12_ori

#check if the image has been mounted 
if [ `ls /mnt/tmp/ | wc -l` -eq 0 ]; then
  echo "/mnt/tmp/ checked."
else
  echo "Unmount /mnt/tmp first."
  sudo umount -R /mnt/tmp
  if [ $? -eq 0 ]; then
    # umount success, do the next step
    echo "umount success, launch vm"
    # write your next command here
  else
    # umount fail, exit the script
    echo "umount fail, exit the script"
    exit 1
fi
fi

sudo ./qemu/build/x86_64-softmmu/qemu-system-x86_64 -name CXL -machine type=pc,accel=kvm,mem-merge=off -enable-kvm -cpu host -smp cpus=8 -m 16384M -object memory-backend-ram,size=4096M,policy=bind,host-nodes=0,id=ram-node0,prealloc=on,prealloc-threads=8 -numa node,nodeid=0,cpus=0-7,memdev=ram-node0 -object memory-backend-ram,size=12288M,policy=bind,host-nodes=1,id=ram-node1,prealloc=on,prealloc-threads=8 -numa node,nodeid=1,memdev=ram-node1  -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22 -drive file=$IMG,format=raw,cache=directsync -kernel $KERNEL -append 'root=/dev/sda console=ttyS0 rw' -nographic