# MAD EL OS

A custom Arch Linux ISO with Thai language support and reduced cybersecurity tools.

## Overview

MAD EL OS is a customized Arch Linux live ISO built with archiso. It provides:

- **Arch Linux base** - Rolling release, full control over system configuration
- **Thai language support** - Correct vowel positioning (no floating or sinking vowels)
- **Reduced security tools** - Only 8 essential cybersecurity utilities

## Features

### Thai Language Support

- **Thai locale**: `th_TH.UTF-8` enabled and set as default
- **Thai fonts**: Noto Sans Thai (with proper OpenType GPOS/GDEF shaping tables)
- **Text rendering**: HarfBuzz + fontconfig ensure correct vowel/tone-mark positioning
- **Input method**: Fcitx5 with fcitx5-libthai for predictive Thai text input
- **Keyboard**: Thai XKB layout loaded at boot, Alt+Shift to toggle
- **Console**: Terminus font with Thai glyph support

**How Thai vowel positioning is guaranteed:**
Noto Sans Thai contains proper OpenType features (`ccmp`, `mark`, `mkmk`) that HarfBuzz applies during text shaping. This ensures:
- Tone marks (U+0E48-U+0E4B) are stacked correctly above/below consonants
- Vowel signs (U+0E34-U+0E37) are positioned precisely above or below the consonant
- SARA AM (U+0E33) is decomposed into NIKHAHIT + SARA AA with proper reordering
- No floating (misplaced above baseline) or sinking (misplaced below baseline) vowels

### Security Tools (Reduced Set)

| Tool | Purpose |
|------|---------|
| nmap | Network discovery and security auditing |
| rkhunter | Rootkit detection |
| lynis | Security auditing and system hardening |
| gnupg | Encryption and signing |
| openssh | Secure remote access |
| nftables | Modern firewall framework |
| fail2ban | Intrusion prevention via log monitoring |
| ca-certificates-utils | TLS certificate management |

Heavy tools like Nessus, Metasploit, Nikto, and chkrootkit are excluded to keep the ISO lightweight.

## Build

### Prerequisites (on Arch Linux host)

```bash
sudo pacman -S archiso edk2-ovmf qemu-desktop
```

### Build Local ISO

```bash
sudo ./build.sh
```

Or manually:

```bash
sudo mkarchiso -v -w /tmp/madel-work -o ./out .
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `OUTPUT_DIR` | `./out` | Output directory for ISO |
| `WORK_DIR` | `/tmp/madel-work` | Working directory for mkarchiso |

## Testing

### Automated Testing

GitHub Actions runs automated tests on every push and pull request. Tests verify:
- Package list contains correct security and Thai packages
- Thai locales and font rendering configuration
- ISO structure and bootability

### Manual Testing

```bash
# Test ISO in QEMU
run_archiso -i out/madel-*.iso

# Or manually with QEMU
qemu-system-x86_64 -m 4G -cdrom out/madel-*.iso -boot d

# Verify ISO contents
unsquashfs -l out/madel-*.iso
```

## Project Structure

```
madel/
├── profiledef.sh              # archiso profile definition
├── packages.x86_64            # Package list (reduced security + Thai tools)
├── pacman.conf                # Build-time pacman config
├── build.sh                   # Build script
├── AGENTS.md                  # Development guide
├── README.md                  # This file
├── .gitignore
├── release-notes.md
├── .github/workflows/
│   ├── build.yml              # CI: Build ISO
│   ├── test.yml               # CI: Test ISO and config
│   └── release.yml            # CI: Create GitHub Release
├── airootfs/                  # Root filesystem overlay
│   ├── etc/
│   │   ├── locale.gen         # Thai + English locales
│   │   ├── locale.conf        # Default: th_TH.UTF-8
│   │   ├── vconsole.conf      # Thai keyboard map
│   │   ├── environment        # Fcitx5 IM env vars
│   │   ├── os-release         # Custom OS branding
│   │   ├── pacman.d/
│   │   │   ├── hooks/locale-gen.hook
│   │   │   └── mirrorlist
│   │   ├── mkinitcpio.conf.d/archiso.conf
│   │   ├── fonts/conf.d/99-thai-render.conf  # Critical Thai rendering config
│   │   └── systemd/system/getty@tty1.service.d/autologin.conf
│   └── root/
│       ├── .bashrc            # Thai-enabled terminal
│       └── .config/fcitx5/    # Thai input method config
├── syslinux/syslinux.cfg      # BIOS boot config
├── grub/grub.cfg              # GRUB config (UEFI fallback)
└── efiboot/                   # systemd-boot config (UEFI)
    ├── loader.conf
    └── entries/archiso.conf
```

## License

MIT
