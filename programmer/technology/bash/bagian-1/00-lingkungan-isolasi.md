# 📚 Dokumentasi: Lingkungan Belajar Bash Terisolasi dengan `systemd-nspawn`

> **Tujuan**: Menyediakan lingkungan Arch Linux yang terisolasi penuh untuk mempelajari Bash secara mendalam tanpa mengganggu sistem utama (host) yang sudah menggunakan Zsh.
>
> **Prasyarat**: Arch Linux dengan `systemd` (default), akses `sudo`, dan koneksi internet untuk instalasi awal.

---

## 1. Latar Belakang & Filosofi

### Mengapa Isolasi Penting?

Saat belajar Bash secara mendalam, Anda akan sering melakukan eksperimen "berbahaya" seperti:

- Menulis ulang file konfigurasi (`~/.bashrc`, `~/.profile`)
- Menguji perilaku `set -e`, `set -u`, `set -o pipefail`
- Mencoba skrip yang memodifikasi `PATH`, alias, atau fungsi shell
- Eksperimen dengan `trap`, subshell, dan job control
- Mengubah perilaku globbing, IFS, dan parameter expansion

Melakukan ini di sistem utama berisiko merusak konfigurasi Zsh Anda atau bahkan sistem secara keseluruhan. Lingkungan terisolasi memberi Anda **kebebasan untuk merusak tanpa konsekuensi**.

### Mengapa `systemd-nspawn`?

| Kriteria | `systemd-nspawn` | VM | Docker |
| :--- | :--- | :--- | :--- |
| Isolasi proses/filesystem | ✅ Kuat (namespace) | ✅ Penuh | ✅ Kuat |
| Overhead resource | 🟢 Sangat rendah | 🔴 Tinggi | 🟢 Rendah |
| Persistent state | ✅ Ya | ✅ Ya | ⚠️ Perlu volume |
| Kompleksitas setup | 🟡 Sedang | 🔴 Tinggi | 🟢 Rendah |
| Cocok untuk "OS utuh" | ✅ Ya | ✅ Ya | ❌ (container minimal) |
| Bawaan Arch Linux | ✅ Ya | ❌ | ❌ |

`systemd-nspawn` adalah **container OS penuh** — bukan sekadar aplikasi terisolasi — sehingga Anda benar-benar merasakan pengalaman "OS Bash murni" dengan systemd, service, dan user management lengkap.

---

## 2. Setup Awal (Sekali Saja)

### 2.1 Instalasi Prasyarat

```bash
sudo pacman -S arch-install-scripts
```

Paket `arch-install-scripts` menyediakan `pacstrap` (untuk menginstal sistem dasar) dan `arch-chroot`.

### 2.2 Membuat Direktori Container

```bash
mkdir -p ~/labs/bash-lab
```

> 💡 **Tips**: Gunakan direktori terpisah seperti `~/labs/` untuk memisahkan dari proyek lain. Anda bisa membuat **beberapa container** dengan nama berbeda (misal `bash-lab`, `zsh-lab`, `dotfiles-lab`) — sangat berguna saat nanti belajar Zsh dan dotfiles.

### 2.3 Instalasi Sistem Dasar Arch

```bash
sudo pacstrap -K -c ~/labs/bash-lab base nano
```

**Penjelasan opsi:**
- `-K` → inisialisasi keyring pacman (mencegah error GPG key)
- `-c` → gunakan cache paket dari host (instalasi jauh lebih cepat)
- `base` → paket minimal wajib (termasuk `bash`, `systemd`, `pacman`)
- `nano` → editor teks ringan untuk latihan (ganti dengan `vim`/`neovim` bila suka)

**Opsional** — paket tambahan yang berguna untuk belajar Bash:

```bash
sudo pacstrap -K -c ~/labs/bash-lab base nano \
  bash-completion man-db which tree \
  shellcheck strace ltrace
```

| Paket | Kegunaan |
| :--- | :--- |
| `bash-completion` | Melatih pemahaman completion (`<TAB>`, `COMP_*`) |
| `man-db` | Akses `man bash` secara lengkap |
| `tree` | Visualisasi struktur direktori |
| `shellcheck` | Linter skrip Bash — wajib untuk belajar kualitas kode |
| `strace`, `ltrace` | Debug syscall dan library call |

### 2.4 Konfigurasi Awal Container

Masuk ke container dalam mode `chroot` (tanpa boot penuh):

```bash
sudo systemd-nspawn -D ~/labs/bash-lab
```

Di dalam container, lakukan:

```bash
# Atur password root
passwd

# Opsional: buat user non-root untuk latihan user management
useradd -m -G wheel -s /bin/bash labuser
passwd labuser

# Keluar
exit
```

> ⚠️ **Catatan**: Di sistem asli Anda shell user adalah Zsh. Di container, user baru sengaja diberi **`/bin/bash`** sebagai shell default — inilah "kandang" tempat Anda belajar.

---

## 3. Menggunakan Container Sehari-hari

### 3.1 Menjalankan Container

**Mode interaktif + boot penuh** (rekomendasi utama):

```bash
sudo systemd-nspawn -b -D ~/labs/bash-lab
```

Anda akan melihat output boot systemd, lalu diminta login.

**Mode dengan bind mount** (untuk berbagi file latihan dari host):

```bash
sudo systemd-nspawn -b -D ~/labs/bash-lab \
  --bind=$HOME/labs/bash-lab-shared:/root/latihan
```

Buat dulu direktori host-nya:

```bash
mkdir -p ~/labs/bash-lab-shared
```

Dengan ini, skrip yang Anda tulis di `~/labs/bash-lab-shared` di host akan langsung terlihat di `/root/latihan` di container. Cocok untuk mengedit dengan editor favorit Anda di host, lalu mengeksekusinya di container.

**Mode jaringan dengan VETH** (lebih isolasi, opsional):

```bash
sudo systemd-nspawn -b -D ~/labs/bash-lab \
  --network-veth \
  --machine=bash-lab
```

### 3.2 Login & Keluar

| Aksi | Perintah |
| :--- | :--- |
| Login di dalam console | `root` + password |
| Keluar sesi (container tetap hidup) | `Ctrl` + `]` (tiga kali) |
| Mematikan container dengan bersih | `poweroff` atau `systemctl poweroff` |
| Masuk ke container yang sudah jalan | `sudo machinectl shell root@bash-lab` |

> 💡 **Trik**: `Ctrl` + `]` (3×) adalah escape sequence bawaan nspawn. Anda akan melihat pesan seperti "Container bash-lab released" saat berhasil keluar.

### 3.3 Workflow Multi-Terminal (Manfaatkan Terminal Anda)

Anda punya lebih dari satu terminal — ini adalah **aset besar**. Alur kerja yang disarankan:

```
┌──────────────────────┬──────────────────────┐
│ Terminal 1 (Host/Zsh)│ Terminal 2 (Nspawn)  │
├──────────────────────┼──────────────────────┤
│ • Edit skrip         │ • Jalankan & uji     │
│ • Git commit         │ • Eksperimen shell   │
│ • Baca dokumentasi   │ • `man bash`         │
│ • Browsing web       │ • Debug dengan       │
│   (Stack Overflow)   │   `strace`/`bash -x` │
└──────────────────────┴──────────────────────┘
```

Contoh nyata:

1. Terminal 1: `vim ~/labs/bash-lab-shared/skrip.sh` (edit di Zsh host)
2. Terminal 2: `sudo systemd-nspawn -b -D ~/labs/bash-lab --bind=...` lalu jalankan `bash /root/latihan/skrip.sh`
3. Terminal 3 (opsional): host — cari referensi web

---

## 4. Checklist Kurikulum Bash di Lingkungan Ini

Gunakan container ini untuk melatih topik-topik berikut. Setiap topik bisa Anda "bebaskan" tanpa risiko.

### 4.1 Dasar-dasar Shell

- [ ] Perbedaan `login shell` vs `non-login shell` vs `interactive` vs `non-interactive`
  - Uji: `bash -l`, `bash -i`, `bash -c "echo hi"`, `bash < skrip.sh`
- [ ] Urutan pembacaan file startup: `/etc/profile` → `~/.bash_profile` → `~/.bash_login` → `~/.profile` → `~/.bashrc`
  - Uji dengan menaruh `echo` di setiap file
- [ ] Variabel: lokal, environment, `export`, `declare`, `readonly`
- [ ] Expansi: brace, tilde, parameter, command substitution, arithmetic, pathname
- [ ] Quoting: single vs double vs backslash vs ANSI-C (`$'...'`)

### 4.2 Kontrol Alur & Fungsi

- [ ] `if`, `case`, loop (`for`, `while`, `until`, `select`)
- [ ] `[[ ]]` vs `[ ]` vs `(( ))`
- [ ] Fungsi, `local`, `return`, `$FUNCNAME`, `BASH_SOURCE`
- [ ] `getopts` untuk parsing opsi CLI

### 4.3 Advanced

- [ ] Trap & signal handling: `trap 'handler' EXIT INT TERM`
- [ ] Subshell vs group command: `( ... )` vs `{ ...; }`
- [ ] Process substitution: `<(cmd)`, `>(cmd)`
- [ ] Redireksi lanjutan: `exec`, `2>&1`, `&>`, `n>&m`, heredoc `<<EOF` dan `<<<`
- [ ] Job control: `jobs`, `fg`, `bg`, `disown`, `&`, `wait`
- [ ] IFS dan pemecahan kata
- [ ] `set -euo pipefail` dan implikasinya
- [ ] `shopt` — pelajari minimal: `nullglob`, `globstar`, `extglob`, `nocaseglob`, `lastpipe`

### 4.4 Debugging & Kualitas

- [ ] `bash -x skrip.sh` (tracing eksekusi)
- [ ] `bash -n skrip.sh` (syntax check tanpa eksekusi)
- [ ] `set -x` / `set +x` on the fly
- [ ] `shellcheck skrip.sh`
- [ ] `strace -f -e trace=process bash skrip.sh` (lihat fork/exec)

### 4.5 Studi Kasus Realistis

Tulis ulang dari nol (tanpa melihat referensi):
- [ ] Skrip backup dengan trap cleanup
- [ ] Skrip `getopts` dengan `-v` (verbose) dan `-h` (help)
- [ ] Wrapper `find | xargs` yang aman terhadap nama file berspasi
- [ ] Skrip retry dengan exponential backoff
- [ ] Skrip parallel sederhana dengan `xargs -P` atau job control

---

## 5. Tips Produktivitas di Dalam Container

### 5.1 Prompt Informasi

Tambahkan di `~/.bashrc` di dalam container agar Anda selalu ingat sedang di lab:

```bash
PS1='[LAB] \u@\h:\w\$ '
```

Atau lebih ekspresif:

```bash
PS1='\[\e[1;33m\][nspawn:bash-lab]\[\e[0m\] \u@\h:\w\$ '
```

### 5.2 Snapshot Sebelum Eksperimen Berisiko

Karena container hanyalah direktori, Anda bisa backup dengan mudah:

```bash
# Dari host
cp -a ~/labs/bash-lab ~/labs/bash-lab.snapshot-$(date +%F)
```

Untuk restore:

```bash
rm -rf ~/labs/bash-lab
cp -a ~/labs/bash-lab.snapshot-2026-10-19 ~/labs/bash-lab
```

> 💡 Ini adalah "time machine" gratis tanpa perlu ZFS/Btrfs snapshot.

### 5.3 Alias Berguna di Host (`.zshrc` Anda)

Tambahkan alias di Zsh host untuk mempercepat akses:

```zsh
# ~/.zshrc di host
alias bashlab='sudo systemd-nspawn -b -D ~/labs/bash-lab --bind=$HOME/labs/bash-lab-shared:/root/latihan'
alias bashlab-shell='sudo machinectl shell root@bash-lab'
alias bashlab-snap='sudo cp -a ~/labs/bash-lab ~/labs/bash-lab.snapshot-$(date +%F-%H%M)'
```

### 5.4 Mengedit File Container dari Host

Karena container hanyalah direktori, Anda bisa langsung edit file dari host:

```bash
# Edit .bashrc container dari Zsh host
vim ~/labs/bash-lab/root/.bashrc
```

Ini sangat berguna saat Anda ingin menyiapkan skrip pelajaran dari host.

---

## 6. Manajemen Container dengan `machinectl`

```bash
# Lihat container yang sedang jalan
machinectl list

# Masuk sebagai root tanpa login ulang
sudo machinectl shell root@bash-lab

# Masuk sebagai user tertentu
sudo machinectl shell labuser@bash-lab

# Power off container
sudo machinectl poweroff bash-lab

# Lihat status
sudo machinectl status bash-lab

# Lihat log container
sudo journalctl -M bash-lab
```

---

## 7. Troubleshooting

| Gejala | Kemungkinan Penyebab | Solusi |
| :--- | :--- | :--- |
| `Failed to register machine: Unit machine-bash\x2dlab.scope already exists` | Container sudah berjalan | `sudo machinectl poweroff bash-lab` dulu |
| `Directory tree ... is not a valid OS tree` | `pacstrap` belum jalan atau gagal | Cek `~/labs/bash-lab/usr/bin/bash` ada, ulangi `pacstrap` |
| Tidak bisa konek internet di dalam container | Firewall host (mis. `ufw`, `nftables`) memblokir NAT | Cek dengan `--network-veth --network-bridge=...` atau matikan firewall host sementara |
| Password root tidak bisa diatur | `systemd-nspawn -D` dijalankan tanpa `sudo` | Selalu jalankan dengan `sudo` |
| `bash: command not found` saat login | Paket `base` tidak terinstal benar | Masuk via `-D`, jalankan `pacman -S bash` |
| Container boot tapi tidak ada network interface | Tidak ada `systemd-networkd` di container | `systemctl enable --now systemd-networkd` di dalam container (bila pakai `--network-veth`) |

---

## 8. Pembersihan

Bila ingin menghapus container sepenuhnya:

```bash
# Pastikan container tidak berjalan
sudo machinectl poweroff bash-lab 2>/dev/null || true

# Hapus direktori
sudo rm -rf ~/labs/bash-lab

# Hapus snapshot (jika ada)
rm -rf ~/labs/bash-lab.snapshot-*
```

`systemd-nspawn` tidak meninggalkan sisa di sistem host selain direktori container itu sendiri.

---

## 9. Referensi Cepat

| Kebutuhan | Perintah |
| :--- | :--- |
| Instal sistem dasar | `sudo pacstrap -K -c ~/labs/bash-lab base` |
| Boot interaktif | `sudo systemd-nspawn -b -D ~/labs/bash-lab` |
| Boot + bind mount | `sudo systemd-nspawn -b -D ~/labs/bash-lab --bind=SRC:DST` |
| Masuk tanpa boot | `sudo systemd-nspawn -D ~/labs/bash-lab` |
| Shell ke container aktif | `sudo machinectl shell root@bash-lab` |
| Lihat container aktif | `machinectl list` |
| Matikan | `sudo machinectl poweroff bash-lab` |
| Snapshot | `cp -a ~/labs/bash-lab ~/labs/bash-lab.snapshot-$(date +%F)` |
| Hapus total | `sudo rm -rf ~/labs/bash-lab` |

---

## 10. Langkah Selanjutnya (Roadmap)

Setelah familiar dengan Bash di container ini, Anda bisa memperluas lab:

1. **Container Zsh kedua** — ulangi setup dengan `~/labs/zsh-lab`, lalu bandingkan perilaku startup, globbing (`EXTENDED_GLOB`), dan parameter expansion Zsh vs Bash.
2. **Container "dotfiles lab"** — taruh repo dotfiles di `~/labs/bash-lab-shared/dotfiles`, uji `stow`/symlink management di dalam container.
3. **Container "destruktif"** — khusus untuk menguji `rm -rf`, `dd`, `mkfs` di virtual disk (file `.img` via `--bind`). Isolasi ekstra agar tidak menyentuh disk asli.
4. **Bash di dalam Podman** — sebagai perbandingan: container Docker-style dengan `bash`, untuk memahami trade-off isolasi vs portabilitas.

---

*Dokumen ini adalah bagian dari materi belajar Bash. Simpan sebagai `docs/00-lingkungan-isolasi.md` di repo materi Anda.*
