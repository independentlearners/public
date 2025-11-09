# Penjelasan lengkap `efibootmgr` (ringkas, teknis, dan praktis)

Singkat: `efibootmgr` adalah utilitas pengguna (userspace) di Linux untuk membaca dan memodifikasi pengaturan Boot Manager UEFI — mis. membuat/menghapus entri boot, mengubah urutan boot, dan mengatur *BootNext*. Program ini umumnya ditulis dalam **C**, bergantung pada pustaka/driver `efivar`/`efivarfs` untuk mengakses variabel NVRAM UEFI. ([linux.die.net][1])

---

# 1) Apa arti daftar opsi yang Anda kirimkan

Keluaran bantuan/usage `efibootmgr` (baris 1–39). Berikut penjelasan ringkas tiap kelompok opsi dan implikasinya.

**Manipulasi entri boot (create / delete / modify / active):**

* `-b | --bootnum XXXX` — targetkan entri BootXXXX (angka hex, contoh `0001`).
* `-B | --delete-bootnum` — hapus entri BootXXXX yang ditargetkan.
* `-c | --create` / `-C | --create-only` — buat entri baru; `-c` juga menambahkan ke BootOrder pada indeks `-I`.
* `-a | --active` / `-A | --inactive` — tandai entri aktif/tidak aktif (bit Active pada variabel).
  Praktis: untuk menghapus entri 0003 → `sudo efibootmgr -b 0003 -B`. Untuk membuat entri baru Anda perlu menggabungkannya dengan `-d` `-p` `-l` `-L` dsb. ([linux.die.net][1])

**Pilihan disk/partisi/loader/label:**

* `-d | --disk disk` — disk tempat loader (default: `/dev/sda`).
* `-p | --part part` — partisi (default: 1).
* `-l | --loader name` — path loader dalam format EFI (umumnya `\EFI\distro\loader.efi`). `efibootmgr` menerima forward slash dan akan mengonversi bila perlu.
* `-L | --label label` — label teks yang muncul di menu firmware. ([linux.die.net][1])

**Boot order / BootNext / Timeout:**

* `-o | --bootorder` — set urutan `BootOrder` (mis. `0001,0002,0003`).
* `-n | --bootnext XXXX` — set `BootNext` — entri yang akan dipakai hanya untuk boot berikutnya (tidak permanen).
* `-t | --timeout seconds` / `-T` — atur atau hapus timeout boot manager.
  Catatan: perubahan `BootOrder` disimpan di variabel NVRAM; platform firmware mungkin hanya menerapkan setelah reset. Pastikan Anda mencatat nilai lama sebelum mengganti. ([uefi.org][2])

**EDD / device path / koneksi driver:**

* `-e | --edd [1|3]` dan `-E | --device num` berhubungan dengan format penulisan device (EDD), kadang berguna jika Anda bekerja dengan info BIOS/legacy.
* `--full-dev-path` / `--file-dev-path` mengubah cara device path ditulis dalam entri. ([linux.die.net][1])

**Kernel / memory mirroring / driver / sysprep:**

* `-m | --mirror-below-4G` dan `-M | --mirror-above-4G` berkaitan dengan memory mirroring (umumnya relevan pada server/ACPI/firmware tertentu).
* `-r | --driver` dan `-y | --sysprep` mengoperasikan variabel selain Boot Variables (Driver vars atau SysPrep vars).
  Bias pemakaian: jarang dipakai pada laptop biasa, tapi tersedia untuk kasus khusus. ([linux.die.net][1])

**Encoding / tambahan argumen / utilitas:**

* `-u | --unicode` — perlakukan extra args sebagai UCS-2 (berguna bila label berisi karakter non-ASCII/Unicode).
* `-@ | --append-binary-args file` — sisipkan argumen kernel tambahan dari file.
* `-v | --verbose` — tampilkan info lebih lengkap. ([linux.die.net][1])

**Lain-lain:**

* `-D | --remove-dups` — hapus duplicate di `BootOrder`.
* `-w | --write-signature` — menulis signature unik ke MBR jika perlu (berguna saat interoperabilitas BIOS/CSM).
* `-V | --version`, `-h | --help` — info dasar.

---

# 2) Hal-hal yang **tidak tampak** dalam daftar tapi penting dipahami

**a. `BootCurrent`, `BootOrder`, `BootXXXX` dan NVRAM**

* Enti-enti `Boot0001`, `Boot0002`, dll. adalah variabel NVRAM yang berisi device path + file path + label. `BootOrder` adalah array yang menyebut nomor-nomor itu dalam urutan coba-boot. `BootNext` adalah variabel sementara yang berlaku hanya untuk boot berikutnya. Perubahan ini disimpan di NVRAM firmware. Perilaku aktual bisa berbeda antar vendor firmware. ([uefi.org][2])

**b. Akses ke variabel UEFI memerlukan `efivar/efivarfs`**

* `efibootmgr` bergantung pada kernel interface `efivarfs` (atau legacy `efivars`) atau library `efivar` untuk membaca/menulis variabel. Jika Anda menjalankan chroot dari installer dan mendapatkan error “EFI variables are not supported”, biasanya `efivarfs` belum dimount atau modul belum di-load. Mount: `mount -t efivarfs efivarfs /sys/firmware/efi/efivars` atau `modprobe efivarfs`. ([GitHub][3])

**c. Menghapus entri di NVRAM ≠ menghapus file EFI di partisi ESP**

* Menghapus `BootXXXX` lewat `efibootmgr -B` hanya menghapus variabel NVRAM. Jika Anda ingin *benar-benar* menghilangkan boot option, Anda juga harus menghapus file `.efi` yang terkait dari ESP (EFI System Partition, biasanya mount di `/boot/efi` atau `/boot`) karena installer/bootloader lain bisa membuat kembali entri jika file masih ada. Forum/guide pengguna sering menekankan langkah gabungan ini. ([bbs.archlinux.org][4])

**d. Beberapa firmware (vendor) berperilaku aneh**

* Ada bug/inkonsistensi di beberapa firmware: encoding label yang aneh, entri kembali muncul, atau firmware mengabaikan `BootOrder` tertentu. Jika terjadi, dokumentasi UEFI dan forum distribusi biasanya adalah tempat rujukan. ([mjg59.dreamwidth.org][5])

---

# 3) Contoh perintah praktis (langsung pakai)

1. **Lihat entri sekarang (dengan device path):**
   `sudo efibootmgr -v`
   → tampilkan `BootCurrent`, `Timeout`, `BootOrder`, dan setiap `BootXXXX` beserta `HD(...)` device path.

2. **Hapus entri 0003:**
   `sudo efibootmgr -b 0003 -B`  (atau `--bootnum 0003 --delete-bootnum`)

3. **Set BootOrder (contoh):**
   `sudo efibootmgr -o 0001,0002,0003`

4. **Set BootNext (boot sekali saja ke entri 0002):**
   `sudo efibootmgr -n 0002`

5. **Buat entri baru (contoh — sesuaikan disk/part/loader/path):**
   `sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Arch Linux" -l '\EFI\arch\vmlinuz-linux' -u 'root=/dev/nvme0n1p2 initrd=\initramfs-linux.img'`
   Catatan: banyak distribusi menggunakan forward slash; `efibootmgr` akan mengonversi ke device path EFI sesuai kebutuhan. Pastikan path benar dan `efivarfs` aktif. ([linux.die.net][1])

---

# 4) Persiapan teknis untuk **mengembangkan atau memodifikasi** `efibootmgr` (sesuai permintaan Anda)

Anda ingin kemampuan memodifikasi — ini checklist teknis dan kompetensi:

**Bahasa & skill yang diperlukan**

* **C (wajib):** kode sumber `efibootmgr` ditulis di C; pemahaman pointer, struktur data, pemanggilan sistem (syscalls), manajemen memori. ([GitHub][3])
* **Make / autotools / Makefile** — cara membangun proyek `make` dengan variabel (mis. `EFIDIR`, `EFI_LOADER`). ([linuxfromscratch.org][6])
* **Pemahaman UEFI & NVRAM:** cara kerja BootOrder, BootNext, device path (EFI device path format), dan batasan firmware. Baca UEFI Spec bagian Boot Manager. ([uefi.org][2])
* **Linux systems programming dasar** — bekerja dengan `/sys/firmware/efi/efivars`, mount efivarfs, user vs root privilege.
* **PKG/DEPENDENCIES:** `libefivar` (efivar), `popt` (parsing argumen) atau dependensi lain yang disebutkan di README. Di distribusi: paket `efivar` dan `popt` biasanya diperlukan. ([linuxfromscratch.org][6])

**Perangkat & langkah build singkat**

* Siapkan toolchain: `gcc`, `make`, `autoconf` (jika perlu), `git`.
* Pasang dependensi: library `efivar` (`libefivar`), `popt` (atau library parsing yang diperlukan). Pada distro berbasis Arch/Debian: `pacman -S efivar popt` / `apt install libefivar-dev libpopt-dev` (nama paket bervariasi). ([archlinux.org][7])
* Clone repo: `git clone https://github.com/rhboot/efibootmgr.git` → baca `README`.
* Build contoh (BLFS/LFS): `make EFIDIR=/boot/efi EFI_LOADER=grubx64.efi` → `make install` (jalankan sebagai root saat install). Sesuaikan `EFIDIR` dengan subdir yang ada di ESP. ([linuxfromscratch.org][6])

**Hal yang perlu diuji/dipahami sebelum meng-commit perubahan**

* Cara menulis/backup variabel NVRAM (uji di VM/Hardware spare).
* Interoperability antar firmware vendors (bug quirks).
* Cara menangani encoding label dan path (UCS-2 / ASCII).
* Behavior saat Secure Boot aktif (modifikasi entri bisa memengaruhi chain of trust).

---

# 5) Troubleshooting umum & mitigasi risiko

* **Pesan: “UEFI variables are not supported”** → pastikan kernel menyediakan efivars/efivarfs; jalankan `modprobe efivarfs` dan mount `/sys/firmware/efi/efivars`. Jika chroot, mount efivarfs di host sebelum chroot. ([Unix & Linux Stack Exchange][8])
* **Perubahan tidak terlihat di firmware menu** → beberapa firmware hanya menerapkan perubahan setelah reset atau memiliki bug yang menimpa NVRAM; coba reboot penuh (power-cycle) atau update firmware (jika aman). ([uefi.org][2])
* **Entri terus muncul setelah dihapus** → hapus juga file `.efi` di partisi ESP; beberapa bootloaders (systemd-boot, shim, os-prober) dapat membuat ulang entri. ([forums.linuxmint.com][9])
* **Jangan lupa backup** → catat `efibootmgr -v` sebelum perubahan. Jika ingin dump lebih formal, gunakan `efibootdump` (sering disertakan) atau simpan output `efibootmgr -v` lalu simpan file ESP. ([linuxfromscratch.org][6])

---

# 6) Ringkasan tindakan cepat (cheat sheet)

* Lihat: `sudo efibootmgr -v` ([linux.die.net][1])
* Hapus entri: `sudo efibootmgr -b 0003 -B`
* Set BootNext: `sudo efibootmgr -n 0002`
* Set urutan: `sudo efibootmgr -o 0001,0002,0003`
* Buat entri: `sudo efibootmgr -c -d /dev/sdX -p 1 -L "Name" -l '\EFI\... \loader.efi' -u 'args'`
* Jika error UEFI variables not supported → `modprobe efivarfs` / `mount -t efivarfs efivarfs /sys/firmware/efi/efivars`. ([Unix & Linux Stack Exchange][8])

---

# 7) Sumber dan bacaan lanjutan (referensi utama)

* Manual `efibootmgr` (man page) — daftar opsi & penjelasan. ([linux.die.net][1])
* Repo resmi `rhboot/efibootmgr` (source, README, catatan build). ([GitHub][3])
* UEFI Specification — bagian *Boot Manager* (penjelasan NVRAM/BootOrder/BootNext). ([uefi.org][2])
* BLFS / LFS build notes untuk efibootmgr (instruksi build & dependensi seperti `efivar`/`popt`). ([linuxfromscratch.org][6])
* Paket `efivar` (penjelasan libefivar/libefiboot dependency) di repositori distribusi (contoh Arch). ([archlinux.org][7])

---

[1]: https://linux.die.net/man/8/efibootmgr?utm_source=chatgpt.com "efibootmgr(8): change EFI Boot Manager - Linux man page"
[2]: https://uefi.org/specs/UEFI/2.10/03_Boot_Manager.html?utm_source=chatgpt.com "3. Boot Manager — UEFI Specification 2.10 documentation"
[3]: https://github.com/rhboot/efibootmgr?utm_source=chatgpt.com "rhboot/efibootmgr: efibootmgr development tree"
[4]: https://bbs.archlinux.org/viewtopic.php?id=301046&utm_source=chatgpt.com "[SOLVED] how to remove old/redundant entry from EFI ..."
[5]: https://mjg59.dreamwidth.org/20187.html?utm_source=chatgpt.com "More in the series of bizarre UEFI bugs"
[6]: https://www.linuxfromscratch.org/blfs/view/svn/postlfs/efibootmgr.html?utm_source=chatgpt.com "efibootmgr-18"
[7]: https://archlinux.org/packages/core/x86_64/efivar/?utm_source=chatgpt.com "efivar 39-1 (x86_64)"
[8]: https://unix.stackexchange.com/questions/91620/efi-variables-are-not-supported-on-this-system?utm_source=chatgpt.com "\"EFI variables are not supported on this system\""
[9]: https://forums.linuxmint.com/viewtopic.php?t=415832&utm_source=chatgpt.com "[SOLVED] How to remove all linux entry on the uefi menu? ..."

