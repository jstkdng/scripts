#!/bin/bash

KERNEL=linux-zen
CPU=intel

INIT=/boot/initramfs-${KERNEL}-${CPU}.img
ESP=/efi/EFI/Linux

#mkinitcpio -p ${KERNEL}
cat /boot/${CPU}-ucode.img /boot/initramfs-${KERNEL}.img > ${INIT}

objcopy \
	--add-section .osrel="/usr/lib/os-release" --change-section-vma .osrel=0x20000 \
	--add-section .cmdline="/boot/kernel-cmdline.txt" --change-section-vma .cmdline=0x30000 \
	--add-section .linux="/boot/vmlinuz-${KERNEL}" --change-section-vma .linux=0x40000 \
	--add-section .initrd="${INIT}" --change-section-vma .initrd=0x3000000 \
	"/usr/lib/systemd/boot/efi/linuxx64.efi.stub" "${ESP}/linux.efi"

#pesign -i "${ESP}/linux.efi" -o "${ESP}/arch.efi" -c MOK -s -f

#rm "${ESP}/linux.efi" ${INIT}
