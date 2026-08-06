#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="madel"
iso_label="MAD_Thai"
iso_version="1.0.0"

arch="x86_64"

# Hostname for the live environment
hostname="madel-thai"

# Boot modes - support both BIOS and UEFI
bootmodes=(
    "bios.syslinux"
    "uefi-ia32.systemd-boot"
    "uefi-x64.systemd-boot"
)

install_dir="arch"

publisher="MAD EL OS <https://madel.example>"
application="MAD EL OS - Custom Arch Linux with Thai Language Support"

# Kernel command line parameters
# Thai keyboard layout is loaded at boot
kernel_cmdline="archisobasedir=${install_dir} archisodevice=/dev/disk/by-label/${iso_label} keymap=th layout=th"

# Enable getty service
systemd_units=(
    "getty@tty1.service"
    "sshd.service"
)

# File permissions
file_permissions=(
    ["/etc/shadow"]="0:0:0400"
    ["/etc/gshadow"]="0:0:0400"
)
