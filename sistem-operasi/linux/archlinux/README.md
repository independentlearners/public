## 📘 [Ringkasan Tujuan Roadmap Post-Instalasi][0]

Dokumen ini menuntun pelajar dan praktisi TI memahami struktur Arch Linux **setelah** instalasi: mulai arsitektur OS, manajemen paket, layanan, konfigurasi kernel/module, sistem file, troubleshooting, hingga kustomisasi akhir (dotfiles & workflow). Dengan road map ini, Anda dapat bergerak dari **dasar → mahir → pembuat dotfiles kustom**.

---

> Struktur file ini berfokus pada *konsep* dan *kebutuhan pengembangan/modifikasi* tiap subsistem — bukan panduan instalasi. Jika anda adalah pelajar baru, klik [disini][install] untuk instalasi

## 📌 Ringkasan Tujuan
- Memahami arsitektur inti: kernel, systemd, pacman, initramfs, udev.
- Mengelola paket & AUR, membangun PKGBUILD, dan menyiapkan repo pribadi.
- Menulis modul kernel sederhana dan menyesuaikan initramfs (mkinitcpio).
- Mengelola systemd units, logging (journald), dan troubleshooting boot.
- Menyusun dotfiles reproducible: metode bare git, GNU Stow, chezmoi.
- Menyusun pipeline bootstrap (install.sh) untuk provisioning cepat.

## 🧭 [1. Gambaran Arsitektur Sistem / Komponen Inti][1]

**Inti yang harus dipahami:** kernel Linux (ringkasan subsistem), init (systemd), manajer paket (pacman), initramfs (mkinitcpio), modul kernel, udev, systemd-units, dan userland (coreutils, glibc/musl).

* **Kernel Linux** — bahasa: *C* (dengan bagian kecil Rust); memahami subsistem: process scheduler, memory, VFS, drivers. ([Wikipedia][1])
* **systemd** — bahasa: *C* — memahami unit types (.service, .socket, .mount), targets, journald.
* **pacman** — bahasa implementasi inti: *C*; memahami repos, DB paket, dan makepkg/PKGBUILD. ([pacman.archlinux.page][2])
* **mkinitcpio** — *Bash* script yang membuat initramfs; pahami hooks dan hooks custom. ([ArchWiki][3])

**Persyaratan dev/modifikasi:** C (native), Bash, sistem build (meson/ninja, autotools), git, knowledge of system calls & kernel APIs, dan pengalaman chroot/container untuk pengujian.

---

## 🧰 [2. Manajemen Paket & Ekosistem AUR](/wiki/Arch_User_Repository)

* **Pacman (C)** — paket biner .pkg.tar.zst; `pacman -Syu`, repo sync, signing. Untuk memodifikasi: pelajari meson/ninja build, PKGBUILD (Bash), dan repos mirror. ([pacman.archlinux.page][2])
* **AUR + helper** — konsep: build from PKGBUILD; contoh helper populer: `yay` (ditulis Go) dan `paru` (ditulis Rust). Gunakan helper hanya setelah memahami risiko upgrade parsial. ([GitHub][4])
* **Membuat paket & PKGBUILD:** struktur, `pkgbuild` fields, `makepkg`, sign package, menyiapkan repo pribadi.

**Persyaratan dev/modifikasi:** Bash (PKGBUILD), C/C++/lang proyek target, Git, GPG (signing), pemahaman dependency tree dan versi ABI/SONAME.

---

## ⚙️ [3. Kernel, Modul, dan Initramfs](/wiki/Kernel)

* **Kernel:** membangun kernel custom (config, make, tools), menambahkan patch, menulis modul kernel (C). ([Wikipedia][1])
* **Modul:** `modprobe`, `lsmod`, `depmod`; menulis modul kernel memerlukan toolchain (gcc, make), headers, dan peralatan debugging (dmesg, kgdb).
* **Initramfs (mkinitcpio — Bash):** menulis hook custom, menyesuaikan preset, men-debug boot-time issues lewat `mkinitcpio -p`. ([ArchWiki][3])

**Persyaratan:** toolchain kernel (gcc/clang), make, git, pengalaman C sistem, dan lingkungan pengujian (VM).

---

## 🛎️ [4. systemd & Manajemen Layanan](/wiki/Systemd)

* Pelajari `systemctl`, unit files (service, timer, socket), dependency graph, masking/enabling.
* Logging: `journalctl` (journald), konfigurasi retention/ratelimit.
* Unit testing: `systemd-analyze blame`, `systemd-run --user`.

**Identitas teknis:** systemd ditulis C, berinteraksi via D-Bus; untuk berkontribusi butuh C & pemahaman D-Bus.

---

## 🗄️ [5. Filesystems, Mounting & Btrfs/LVM/LUKS][5]

* Pahami `/etc/fstab`, systemd .mount units, fstab options.
* Filesystem modern: ext4, btrfs (subvolumes, snapshots), XFS, F2FS.
* Enkripsi: LUKS, luks2, header backup; integration with initramfs.

**Persyaratan:** pemahaman filesystem semantics, tooling: `cryptsetup`, `lvm2`, `btrfs-progs`.

---

## 🔐 [6. Keamanan & Hardening](/wiki/Security)

* Pengguna & hak akses: `sudo`, polkit rule.
* Kernel hardening: grsecurity (historis), sysctl tuning, seccomp, AppArmor/SELinux (opsional).
* Package & repo security: verify signatures, `pacman-key`, reproducible builds.
* Network hardening: `iptables`/`nftables`, firewalls, `fail2ban`.

**Persyaratan:** penguasaan jaringan, konsep ACL, kerangka kebijakan (AppArmor/SELinux), kriptografi dasar.

---

## 🌐 [7. Jaringan & Layanan Jaringan](/wiki/Network_configuration)

* Tools: NetworkManager, systemd-networkd, `iwctl` (iwd), `nmcli`.
* Server services: SSH, web server, reverse proxy, DNS (systemd-resolved vs resolvconf).
* Container networking & bridging (bridge, macvlan).

**Persyaratan:** TCP/IP, routing, VLAN, netfilter, systemd-networkd YAML-like config, knowledge of DNS/TLS.

---

## 🐳 [8. Virtualisasi & Containerization](/wiki/Virtualization)

* Pilihan: KVM/QEMU, libvirt, Docker, Podman.
* Building reproducible dev env: containers, system images, chroots with `arch-chroot` & build chroots for packages.

**Persyaratan:** kernel modules (kvm), qemu tools, OCI knowledge, container registries, image building pipelines.

---

## 🧾 [9. Logging, Monitoring & Observability](/wiki/System_monitoring)

* Tools: `journalctl`, `top/htop`, `iotop`, `perf`, `sar`, `prometheus` + `node_exporter`.
* Collection: logging forwarding, persistent journal, logrotate.

**Persyaratan:** familiarity with metrics, time series DB, alerting rules (Prometheus Alertmanager).

---

## 🧩 [10. Troubleshooting & Recovery](/wiki/System_maintenance)

* Emergency: `journalctl -b -1`, `systemctl --failed`, `mkinitcpio` rebuild, chroot recovery via live ISO.
* Kernel oops / panics: read dmesg, `kdump` optional.
* Pacman troubleshooting: DB lock, partial upgrades, `pacman -Qk`, `pacman -Syyu` when mirror changed. ([pacman.archlinux.page][2])

**Persyaratan:** debugging skills, ability to read logs, create minimal reproducer (VM).

---

## 🎨 [11. Kustomisasi Desktop, WM & Dotfiles](/wiki/Dotfiles)

**Tujuan:** membuat lingkungan personal yang konsisten, reproducible, portable (dotfiles repo).

* Struktur rekomendasi dotfiles:

  ```
  dotfiles/
  ├─ README.md
  ├─ .gitignore
  ├─ home/
  │  ├─ .zshrc
  │  ├─ .config/
  │  │  ├─ sway/
  │  │  ├─ alacritty/
  │  │  └─ nvim/
  ├─ stow/ (optional)
  ├─ scripts/
  └─ install.sh (bootstrap)
  ```
* Teknik manajemen dotfiles:

  * **Bare Git repo** (git --git-dir \~/dotfiles/ --work-tree=\$HOME) — populer, simple.
  * **GNU Stow** — untuk symlink management per package.
  * **chezmoi** — templating, secret management, OS-aware.
  * **Ansible/Makefile** untuk provisioning host baru.
* **Best practices:** jangan versi file berisi secrets (use .gitignore, pass, gpg encryption), buat installer idempotent, pisahkan host-specific config (hosts/hostname/\*).
* **Testing:** gunakan container/VM untuk menguji installer dan symlink tanpa merusak environment utama.

**Persyaratan:** Git, shell scripting (Bash/Zsh), knowledge symlink, basic Makefile, optional: Go/Rust/Python untuk custom tools.

---

## 🧪 \[12. Workflow Dotfiles — Contoh Bootstrapping Minimal]

**Contoh pendek (bare repo):**

```bash
# in $HOME
git init --bare $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config remote add origin git@github.com:username/dotfiles.git
config pull origin main
```

**Jika ingin pake GNU Stow:**

```bash
# struktur: dotfiles/stow/alacritty -> ~/.config/alacritty
cd ~/dotfiles
stow alacritty sway nvim
```

---

## 🚦 \[13. Roadmap Pembelajaran — Level & Capabilities]

Berikut milestone yang membuat progres terukur dari *pasca-instalasi* → *mahir* → *pembuat dotfiles/kustom*.

**Level: Fundamental (Dasar pasca-instalasi)**

* Tujuan: sistem stabil, update aman, user management, backup.
* Kuasai: pacman dasar, systemd units, journald, simple dotfiles.

**Level: Menengah**

* Tujuan: kustom kernel/modules dasar, packaging sederhana (PKGBUILD), automasi dotfiles (stow/chezmoi).
* Kuasai: PKGBUILD structure, makepkg, building from ABS, unit files custom, LUKS basics.

**Level: Lanjutan (Mahir)**

* Tujuan: membuat paket repo sendiri, build kernel, mempatch module, advanced systemd units, reproducible dev env (Nix/containers optional).
* Kuasai: C for kernel/modules, meson/ninja/autotools, chroot build envs, CI for package building.

**Level: Pengembang/Contributor (Expert)**

* Tujuan: kontribusi ke pacman/mkinitcpio/systemd, maintain AUR populer, membangun distro spin.
* Kuasai: proyek source code besar (C), code review, maintainers workflow, secure package signing pipeline.

---

## 📚 \[14. Referensi Inti & Sumber Cepat]

* Pacman (detail & tips). ([pacman.archlinux.page][2])
* Mkinitcpio (initramfs). ([ArchWiki][3])
* Kernel Linux overview. ([Wikipedia][1])
* Yay (AUR helper — Go). ([GitHub][4])
* Paru (AUR helper — Rust). ([OSTechNix][5])

> Catatan: tautan yang saya cantumkan di setiap judul mereferensikan halaman rujukan (Arch Wiki atau proyek resmi) — buka judul jika Anda ingin baca langsung dokumentasi mendetail.

---

## ✅ Checklist Praktis Pasca-Instalasi (Ringkas)

* [ ] Setup `pacman.conf` mirrors & enable multilib (jika perlu).
* [ ] Atur keyring & `pacman-key --init && pacman-key --populate archlinux`.
* [ ] Pasang AUR helper (opsional) setelah paham risikonya (yay/paru). ([GitHub][4])
* [ ] Konfigurasikan `mkinitcpio.conf` bila memakai LUKS/RAID; rebuild initramfs. ([ArchWiki][3])
* [ ] Buat dotfiles repo (bare/stow/chezmoi) dan skrip bootstrap.
* [ ] Tambah monitoring sederhana (htop, glances, journal retention).

---

## 🔎 Tips akhir & filosofi belajar

* Pelajari **satu subsistem** sampai Anda dapat mereparasinya (mis. systemd units + journald).
* Selalu simpan konfigurasi penting (fstab, crypttab, mkinitcpio presets) di dotfiles/private atau dokumentasi offline.
* Praktikkan membuat reproducible environment (container/VM) sebelum menerapkan perubahan besar di host produksi.

---

[kernel]: https://en.wikipedia.org/wiki/Linux_kernel?utm_source=chatgpt.com "Linux kernel"
[archlinux]: https://pacman.archlinux.page/?utm_source=chatgpt.com "Pacman Home Page"
[wiki]: https://wiki.archlinux.org/title/Mkinitcpio?utm_source=chatgpt.com "mkinitcpio - ArchWiki - Arch Linux"
[github]: https://github.com/Jguer/yay?utm_source=chatgpt.com "Jguer/yay: Yet another Yogurt - An AUR Helper written in Go"
[ostechnix]: https://ostechnix.com/how-to-install-paru-aur-helper-in-arch-linux/?utm_source=chatgpt.com "How To Install Paru AUR Helper In Arch Linux"

<!--
## 📂 [Pendahuluan](https://wiki.archlinux.org/title/Arch_Linux)

Arch Linux adalah distribusi GNU/Linux dengan filosofi **KISS (Keep It Simple, Stupid)**, bersifat **rolling release**, dan mengutamakan dokumentasi melalui [Arch Wiki](https://wiki.archlinux.org/).

---

## 💿 [Persiapan Instalasi](https://wiki.archlinux.org/title/Installation_guide)

* Persyaratan perangkat keras minimum
* Media instalasi (ISO, USB Bootable)
* Mode BIOS vs UEFI
* Skema partisi dasar: `/boot`, `/boot/efi`, `swap`, `/`, `/home`
* Tools partisi: `fdisk`, `cfdisk`, `parted`, `gparted`

---

## ⚡ [Instalasi Dasar](https://wiki.archlinux.org/title/Installation_guide)

Perintah utama:

```bash
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

* Konfigurasi waktu, locale, hostname
* Atur password root

---

## 🌀 [Bootloader](https://wiki.archlinux.org/title/Boot_loader)

* Pilihan: GRUB, systemd-boot, rEFInd
* Konfigurasi GRUB (tema, ASCII art, deteksi Windows)
* Urutan instalasi dual boot → **Windows → Linux**
* Troubleshooting jika boot gagal

---

## 🧩 [Kernel & Initramfs](https://wiki.archlinux.org/title/Kernel)

* Jenis kernel: `linux`, `linux-lts`, `linux-hardened`, `zen`
* File penting di `/boot`: `vmlinuz`, `initramfs`, `microcode`
* Manajemen dengan `mkinitcpio`

---

## 🖥️ [Lingkungan Sistem](https://wiki.archlinux.org/title/Systemd)

* Init system: systemd
* Manajemen service: `systemctl`
* Journald (log sistem)
* User & grup (`useradd`, `usermod`, `sudo`)
* Pilihan shell: bash, zsh, fish

---

## 📦 [Manajemen Paket](https://wiki.archlinux.org/title/Pacman)

* Pacman: instal, upgrade, hapus paket
* Konfigurasi `/etc/pacman.conf`
* Mirrors & `reflector`
* AUR (Arch User Repository): yay, paru, trizen
* Membuat PKGBUILD

---

## 🎨 [Desktop & Window Manager](https://wiki.archlinux.org/title/Desktop_environment)

* DE: GNOME, KDE, XFCE, Cinnamon
* WM: i3, Sway, bspwm, dwm
* Display Manager: GDM, LightDM, Ly
* Konfigurasi multi-monitor

---

## 🌐 [Jaringan](https://wiki.archlinux.org/title/Network_configuration)

* NetworkManager vs systemd-networkd
* Wi-Fi: `iwctl`, `nmcli`
* VPN setup
* Firewall: `ufw`, `iptables`, `nftables`

---

## 🔋 [Power Management](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate)

* Suspend, Hibernate, Hybrid Sleep
* Swapfile vs Swap Partition
* Tools: `tlp`, `powertop`
* Optimasi laptop

---

## 🛠️ [Perangkat Keras](https://wiki.archlinux.org/title/Hardware)

* GPU: NVIDIA, AMD, Intel
* Audio: ALSA, PulseAudio, PipeWire
* Printer & scanner: CUPS, sane
* Input device: touchpad, stylus

---

## 🔧 [Maintenance & Troubleshooting](https://wiki.archlinux.org/title/System_maintenance)

* Update sistem (`pacman -Syu`)
* Downgrade paket
* Backup: `rsync`, Timeshift, Snapper (btrfs)
* Recovery mode dengan live ISO
* Emergency shell (initramfs error)

---

## 🎭 [Kustomisasi](https://wiki.archlinux.org/title/Color_output_in_console)

* Konfigurasi shell prompt
* Menampilkan teks otomatis di zsh/bash
* Fastfetch/Neofetch untuk info sistem
* ASCII art di terminal
* Modifikasi tampilan bootloader & login manager

---

## 📘 [Advanced Topics](https://wiki.archlinux.org/title/General_recommendations)

* Kernel custom & patching
* Secure Boot
* Virtualisasi: KVM, QEMU, Docker, Podman
* Cross-compiling
* Hardening Arch Linux

---

## 📖 [Referensi Tambahan]()

* 📜 Arch Wiki – [Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
* 📜 Arch Wiki – [Pacman](https://wiki.archlinux.org/title/Pacman)
* 📜 Arch Wiki – [Dual boot with Windows](https://wiki.archlinux.org/title/Dual_boot_with_Windows)
* 📜 Microsoft Docs – [Partition Layout](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions)

-----
-->

[0]: ../../README.md     
[1]: ./../archlinux/arsitektur-sistem/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
[4]: ./
[5]:./filesystem/README.md
[install]: ../../linux/archlinux/instalasi/README.md
