
# **📚 Kurikulum Instalasi Arch Linux** [↩️ Sumber Utama][0]

> Kurikulum ini menjembatani pemahaman antara **"mengerti konsep bootloader"** dan **"memahami mekanika bootloader saat instalasi"**. Setiap perintah yang digunakan akan dijelaskan konteksnya, sehingga Anda tidak sekadar mengikuti langkah, tetapi mengerti alasan dan konsekuensinya.

---

## 🎯 Tujuan Kurikulum
- **Memahami konteks**: mengapa perintah seperti `lsblk` dan `mkfs.ext4` diperlukan.  
- **Menguasai troubleshooting**: membaca pesan kesalahan, menentukan langkah perbaikan.  
- **Mencapai kemandirian**: mampu melakukan instalasi manual (termasuk enkripsi, dual-boot, dan konfigurasi kompleks) tanpa mengandalkan skrip otomatis.

---

## 🗂️ Ringkasan Struktur Fase (Singkat)
> Struktur ini dibagi menjadi fase bertahap sehingga pembelajaran bersifat progresif dan dapat diadaptasi sesuai kebutuhan praktis.

1. **[Fase 1: Persiapan dan Pra-Instalasi (Dalam Lingkungan Arch Live)][1]**  
   - Modul 1: Memahami lingkungan Arch Live & koneksi jaringan  
   - Modul 2: Manajemen partisi: Disk, GPT, dan MBR  
   - Modul 3: Memformat partisi & mounting sistem

2. **[Fase 2: Instalasi Sistem Inti dan Konfigurasi Dasar][2]**  
   - Modul 4: Instalasi paket dasar & pembuatan fstab  
   - Modul 5: Konfigurasi sistem: zona waktu, locale, dan pengguna  
   - Modul 6: Instalasi & konfigurasi bootloader (GRUB / systemd-boot)

3. **[Fase 3: Skenario Lanjutan & Troubleshooting][3]**  
   - Modul 7: Enkripsi penuh (LUKS) dan LVM  
   - Modul 8: Dual-boot dengan OS lain (Windows / macOS)  
   - Modul 9: Troubleshooting instalasi gagal  
   - Modul 10: Membangun lingkungan Sway WM dari nol  
   - Modul 11: Memahami & menggunakan `archinstall` (sebagai alat bantu relevan)

---

## 📌 Petunjuk Penggunaan Kurikulum
- Ikuti **fase** secara berurutan jika Anda baru pertama kali belajar.  
- Untuk praktik cepat, Anda dapat memilih **modul tunggal** (mis. hanya LUKS atau hanya bootloader) dan menyelesaikannya secara terpisah.  
- Simpan catatan setiap sesi pada folder proyek Anda; rekomendasi format: `Markdown` untuk dokumentasi, `bash` untuk snippet perintah, dan `diff`/`patch` jika ada perubahan konfigurasi penting.

---

## ✅ Kriteria Keberhasilan (Learning Outcomes)
Setelah menyelesaikan semua modul pada setiap fase, peserta diharapkan dapat:
- Menjelaskan peran dan alur kerja bootloader pada proses boot.  
- Memetakan partisi disk pada perangkat nyata dan menyiapkan filesystem sesuai kebutuhan.  
- Mengonfigurasi sistem dengan aman (LUKS) dan mengenali serta memperbaiki masalah umum saat boot.  
- Menyusun lingkungan Sway minimal yang dapat diulang (reproducible).

---

## 📦 Struktur Direktori Modul (Rekomendasi untuk Repos Anda)
Susun repos modul agar mudah dinavigasi dan dapat di-*clone* ulang untuk lab/praktik:

```

instalasi/
├─ bagian-1/           # Fase 1: Persiapan & Pra-Instalasi
│  └─ README.md
├─ bagian-2/           # Fase 2: Instalasi Sistem Inti
│  └─ README.md
├─ bagian-3/           # Fase 3: Lanjutan & Troubleshooting
│  └─ README.md
└─ README.md           # Screenshots, diagram, snippets perintah
```

---

## 💡 Tip Pengajaran & Evaluasi
- **Gunakan VM terlebih dahulu:** semua langkah kritis harus dicoba dalam VM sebelum diaplikasikan ke perangkat produksi.  
- **Terapkan pembelajaran aktif:** setelah tiap modul, berikan kuis singkat atau tugas lab (mis. siapkan sistem dengan EFI+LUKS dan buktikan dapat boot).  
- **Checklist penilaian:** konfigurasi `fstab`, `crypttab` (jika ada), keberhasilan `mkinitcpio`, serta validitas entri bootloader.

---

<!--## 📎 Referensi & Link Modul-->
[0]: ./../../../README.md  
[1]: ./bagian-1/README.md  
[2]: ./bagian-2/README.md  
[3]: ./bagian-3/README.md
