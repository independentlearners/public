# Konfigurasi PowerShell 7 “Zsh-Like” dengan PSReadLine

---

## 1. Prasyarat

1. **PowerShell 7.x** (pwsh) sudah terinstall.
2. **Visual Studio Code** (atau editor teks lain) untuk mengedit profil.

> _Catatan_: PSReadLine sudah menjadi modul bawaan di PowerShell 7, tidak perlu instalasi terpisah.

---

## 2. Lokasi dan Pembuatan File Profil

1. Buka pwsh, jalankan:

   ```powershell
   $PROFILE | Format-List *
   ```

   Anda akan melihat beberapa path, namun yang terpakai umumnya:

   ```
   C:\Users\<UserName>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
   ```

2. Bila file belum ada, buat dengan:

   ```powershell
   if (-not (Test-Path $PROFILE.CurrentUserCurrentHost)) {
       New-Item -ItemType File -Path $PROFILE.CurrentUserCurrentHost -Force
   }
   ```

---

## 3. Mengedit Profil di VSCode

1. Buka VSCode dari pwsh:

   ```powershell
   code $PROFILE.CurrentUserCurrentHost
   ```

2. Pada file `Microsoft.PowerShell_profile.ps1`, tambahkan blok berikut di akhir file:

   ```powershell
   # ——— PSReadLine Configuration ———

   Import-Module PSReadLine

   # Autocomplete & Popup Prediction ala zsh
   Set-PSReadLineOption -PredictionSource History
   Set-PSReadLineOption -PredictionViewStyle ListView

   # Tab → MenuComplete (dropdown)
   Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

   # (Opsional) Fuzzy Finder dengan PSFzf
   # Install-Module PSFzf -Scope CurrentUser
   # Import-Module PSFzf
   # Set-PSReadLineKeyHandler -Key Ctrl+t -Function PSFzfLikeFileFinder
   ```

3. **Simpan** dan **tutup** VSCode.

---

## 4. Merefresh Profil

Di pwsh, jalankan:

```powershell
. $PROFILE.CurrentUserCurrentHost
```

atau tutup & buka ulang terminal.

---

## 5. Verifikasi dan Penggunaan Dasar

- **Tab** → menampilkan daftar opsi perintah/path (MenuComplete).
- **F7** → popup History (pilih baris, Enter untuk eksekusi).
- **Ctrl + R** → incremental reverse-search dari history.
- **Up** / **Down** → navigasi history biasa.

---

## 6. Tips dan Pintasan Lanjutan untuk Kenyamanan & Fleksibilitas

| Pintasan                   | Fungsi                                              |
| -------------------------- | --------------------------------------------------- |
| **Ctrl + Space**           | Trigger menu complete meski tidak menekan Tab       |
| **Ctrl + Left/Right**      | Pindah antar kata dalam baris perintah              |
| **Alt + F**                | Hapus kata di depan kursor                          |
| **Alt + Backspace**        | Hapus kata di belakang kursor                       |
| **Ctrl + Home/End**        | Pindah ke awal/akhir baris perintah                 |
| **Ctrl + Up/Down**         | Scroll buffer output tanpa mengganggu posisi prompt |
| **Ctrl + W**               | Hapus kata sebelumnya                               |
| **Ctrl + U**               | Hapus seluruh baris sebelum kursor                  |
| **Ctrl + L**               | Clear layar (setara `cls`)                          |
| **PSReadLine History API** |                                                     |

- `Get-PSReadLineOption` — menampilkan opsi PSReadLine saat ini
- `Get-PSReadLineKeyHandler` — menampilkan semua keybindings

> _Catatan tambahan_:
>
> - Anda dapat menyesuaikan `PredictionViewStyle` ke `View` (inline) atau `ListView` sesuai preferensi.
> - Jika sering membuka file atau direktori, integrasikan **PSFzf** untuk fuzzy-finder, lalu binding Ctrl + T.
> - Kustomisasi lebih lanjut:
>
>   ```powershell
>   # Ganti warna prompt atau highlight
>   Set-PSReadLineOption -TokenKind Parameter -ForegroundColor DarkCyan
>   ```

---

## 7. Pintasan Navigasi & Pengeditan Lanjutan

| Pintasan                     | Fungsi                                                                                                                                 | Sumber                          |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| **Shift + Enter**            | Memasukkan baris baru (multi-line), tanpa mengeksekusi; setiap baris tambahan diawali `>>`, tekan Enter untuk menjalankan.             | ([Microsoft Learn][1])          |
| **Insert**                   | Beralih antara mode **insert** dan **overwrite**.                                                                                      | ([Microsoft Learn][1])          |
| **Left Arrow**               | Pindah satu karakter ke kiri.                                                                                                          | ([Microsoft Learn][1])          |
| **Right Arrow**              | Pindah satu karakter ke kanan.                                                                                                         | ([Microsoft Learn][1])          |
| **Ctrl + Left Arrow**        | Pindah satu kata ke kiri (token-based word movement).                                                                                  | ([Microsoft Learn][1])          |
| **Ctrl + Right Arrow**       | Pindah satu kata ke kanan (token-based word movement).                                                                                 | ([Microsoft Learn][1])          |
| **Home**                     | Pindah ke **awal** baris saat ini (tekan dua kali jika ada multi-line).                                                                | ([Microsoft Learn][1])          |
| **End**                      | Pindah ke **akhir** baris saat ini (tekan dua kali jika ada multi-line).                                                               | ([Microsoft Learn][1])          |
| **Backspace**                | Hapus satu karakter di kiri kursor.                                                                                                    | ([Microsoft Learn][1])          |
| **Delete**                   | Hapus satu karakter di posisi kursor.                                                                                                  | ([Microsoft Learn][1])          |
| **Ctrl + Home**              | Hapus semua teks dari kursor hingga **awal** baris.                                                                                    | ([Microsoft Learn][1])          |
| **Ctrl + End**               | Hapus semua teks dari kursor hingga **akhir** baris.                                                                                   | ([Microsoft Learn][1])          |
| **Alt + ?**                  | Menampilkan fungsi (key binding) untuk chord/kunci apa pun: tekan `Alt+?` lalu tekan tombol yang diinginkan untuk melihat binding-nya. | ([Microsoft for Developers][2]) |
| **Ctrl + Alt + ?**           | Menampilkan **semua** binding yang sedang aktif.                                                                                       | ([Microsoft for Developers][2]) |
| **Get-PSReadLineKeyHandler** | Cmdlet untuk menampilkan daftar lengkap semua key binding PSReadLine.                                                                  | ([Microsoft Learn][1])          |
| **Get-PSReadLineOption**     | Cmdlet untuk melihat pengaturan PSReadLine saat ini (mode edit, view style, dll.).                                                     | ([Microsoft Learn][1])          |

---

## Cara Menambahkan ke Profil

1. **Buka profil** di VSCode:

   ```powershell
   code $PROFILE.CurrentUserCurrentHost
   ```

2. **Paste** blok berikut **di akhir** `Microsoft.PowerShell_profile.ps1`:

   ```powershell
   # ——— PSReadLine Advanced Shortcuts ———

   # Multi-line editing
   Set-PSReadLineKeyHandler -Chord Shift+Enter -Function AcceptLine

   # Toggle overwrite mode
   Set-PSReadLineKeyHandler -Chord Insert -Function OverwriteMode

   # (Semua binding default lain diatur otomatis)
   ```

3. **Reload** profil:

   ```powershell
   . $PROFILE.CurrentUserCurrentHost
   ```

---

[1]: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_line_editing?view=powershell-7.5 "about_Line_Editing - PowerShell | Microsoft Learn"
[2]: https://devblogs.microsoft.com/scripting/useful-shortcuts-from-psreadline-powershell-module/?utm_source=chatgpt.com "Useful Shortcuts from PSReadLine PowerShell Module"

Dengan langkah ini PowerShell 7 Anda kini memiliki **popup history**, **dropdown completion**, dan **reverse-search** ala zsh—ditambah berbagai pintasan produktivitas. Selamat berproduktivitas! 🚀

> ChatGPT
