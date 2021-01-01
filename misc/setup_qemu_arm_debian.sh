#!/bin/bash
# Based on: https://translatedcode.wordpress.com/2016/11/03/installing-debian-on-qemus-32-bit-arm-virt-board/
# Will pull debian kernel/initrd installers and use qemu-arm to build/extract kernel/initrd
# If debian files already exist will simply run qemu
ADDITIONAL_ARGS=${1}

# Create Drive file
DRIVE_FILE=hda.qcow2
if ! [ -f ${DRIVE_FILE} ]
then
	qemu-img create -f qcow2 ${DRIVE_FILE} 5G
fi

# Download Kernel/Initrd and install them
if ! [[ $(ls vmlinuz-*-armmp-lpae | wc -w) -eq 1 && $(ls initrd.img-*-armmp-lpae | wc -w) -eq 1 ]]
then
	echo "[DOWNLOAD] Getting Kernel and Initrd from: us.debian.org"
	rm -f vmlinuz-*-armmp-lpae initrd.img-*-armmp-lpae
	wget -O installer-vmlinuz http://http.us.debian.org/debian/dists/jessie/main/installer-armhf/current/images/netboot/vmlinuz
	wget -O installer-initrd.gz http://http.us.debian.org/debian/dists/jessie/main/installer-armhf/current/images/netboot/initrd.gz
	KERNEL_INSTALLER=installer-vmlinuz
	INITRD_INSTALLER=installer-initrd.gz
	# Run installer
	qemu-system-arm -M virt -m 1024 \
	  -kernel ${KERNEL_INSTALLER}  \
	  -initrd ${INITRD_INSTALLER} \
	  -drive if=none,file=${DRIVE_FILE},format=qcow2,id=hd \
	  -device virtio-blk-device,drive=hd \
	  -netdev user,id=mynet \
	  -device virtio-net-device,netdev=mynet \
	  -nographic -no-reboot

	# Get Kernel/Initrd Version
	VERSION=$(sudo virt-ls -a hda.qcow2 /boot/ | grep -om1 '[0-9].*[0-9]')
	KERNEL=vmlinuz-${VERSION}-armmp-lpae
	INITRD=initrd.img-${VERSION}-armmp-lpae

	# Copy Installed Kernel/Initrd to host FileSystem
	sudo virt-copy-out -a hda.qcow2 /boot/${KERNEL} /boot/${INITRD} .
else
	KERNEL=$(ls vmlinuz-*-armmp-lpae)
	INITRD=$(ls initrd.img-*-armmp-lpae)
fi

# Run Qemu For real
qemu-system-arm -M virt -m 1024 \
  -kernel ${KERNEL} \
  -initrd ${INITRD} \
  -append 'root=/dev/vda2' \
  -drive if=none,file=${DRIVE_FILE},format=qcow2,id=hd \
  -device virtio-blk-device,drive=hd \
  -netdev user,id=mynet \
  -device virtio-net-device,netdev=mynet \
  ${ADDITIONAL_ARGS}
