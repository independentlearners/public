
## GNU nano itu apa

`nano` adalah editor teks kecil untuk terminal. Ia dirancang agar sederhana dan ramah dipakai, dengan fokus pada pengeditan teks biasa di lingkungan CLI/TUI. Di dokumentasi resminya, nano digambarkan sebagai penerus gaya kerja Pico, tetapi dengan fitur yang lebih lengkap seperti undo/redo, syntax highlighting, search-and-replace interaktif, auto-indentation, line numbers, word completion, file locking, backup file, dan dukungan internasionalisasi. ([Nano Editor][1])

## Identitas proyek

Nano adalah **official GNU package**. Halaman resminya juga menyebut bahwa proyek ini dimulai pada 1999, dengan tujuan utama menggantikan Pico secara bebas, menjaga kompatibilitas yang wajar, dan tetap menambahkan fitur yang berguna secara bawaan. Halaman “Who’s who” resmi mencantumkan **Chris Allegretta** sebagai original author dan **Benno Schulenberg** sebagai current maintainer. ([Nano Editor][2])

## Versi terbaru dan status resmi

Halaman utama resmi nano saat ini menandai **versi terbaru 9.0** dan diperbarui pada **2026-04-08**. News resmi juga menuliskan rilis nano 9.0 pada 8 April 2026. ([Nano Editor][3])

## Cara menjalankan nano

Sintaks umum di manual resminya adalah:

```bash
nano [options] [[+line[,column]] file]...
nano [options] [[+[crCR]{/|?}string] file]...
```

Artinya, nano bisa dibuka dengan nama file biasa, atau langsung diarahkan ke baris/kolom tertentu, bahkan ke kemunculan string tertentu. Contoh resmi di manual: `nano +c/Foo file` membuka file pada kemunculan pertama kata `Foo`. Jika argumennya adalah tanda minus (`-`), nano membaca dari standard input. ([Nano Editor][4])

## Shortcut inti yang paling penting

Dokumentasi resmi shortcut nano menampilkan alur kerja dasar seperti berikut: `Ctrl+O` untuk simpan, `Ctrl+X` untuk keluar, `Ctrl+K` untuk cut baris, `Ctrl+U` untuk paste, `Ctrl+W` untuk pencarian, `Ctrl+\` untuk replace, `Ctrl+G` untuk bantuan, `Ctrl+C` untuk posisi kursor, dan `Alt+U` / `Alt+E` untuk undo dan redo. Nano memang didesain agar operasi utama tetap bisa dilakukan langsung dari keyboard tanpa menu kompleks. ([Nano Editor][5])

## Konfigurasi nano

File konfigurasi **nanorc** dipakai untuk mengubah perilaku nano saat startup. Dokumentasi resmi menyebut urutan baca konfigurasi seperti ini: jika `--rcfile` tidak diberikan, nano membaca setting sistem lalu setting pengguna; jika `--rcfile` diberikan, nano hanya membaca file itu. Dokumen yang sama juga menegaskan bahwa **opsi command-line mengalahkan nanorc**, dan **nanorc mengalahkan default bawaan**. Di nanorc, kamu juga bisa mengatur syntax highlighting dan melakukan rebind key. ([Nano Editor][6])

## Build dari source

Halaman README resmi menyatakan nano bisa dibangun dengan alur klasik autoconf:

```bash
./configure
make
make install
```

README juga menyebut bahwa untuk sukses menjalankan `./configure`, kamu perlu **header files ncurses** terpasang. Source code-nya tersedia di **git.savannah.gnu.org/git/nano.git**. ([Nano Editor][2])

## Gambaran praktis

Secara praktis, nano cocok untuk:

* edit file cepat di server, shell, recovery mode, atau container;
* pemula yang butuh editor terminal tanpa mode yang rumit;
* pengguna yang ingin konfigurasi ringan lewat `nanorc`. ([Nano Editor][2])

Ia kurang cocok bila kamu menginginkan ekosistem plugin sangat besar atau arsitektur editor yang sangat modular; dokumentasi resminya menekankan kesederhanaan, bukan extensibility berat seperti editor yang lebih besar. ([Nano Editor][2])

## Sumber resmi utama

* Homepage resmi: **nano-editor.org**. ([Nano Editor][7])
* Dokumentasi resmi: manual, FAQ, shortcuts, man page, nanorc man page, README, ChangeLog, NEWS. ([Nano Editor][8])
* Source code resmi: repository Git di Savannah GNU. ([Nano Editor][9])
* Info maintainer dan sejarah tim. ([Nano Editor][10])

---

**[Konfigurasi nanorc][nanorc]**

[1]: https://www.nano-editor.org/dist/latest/nano.html?utm_source=chatgpt.com "The GNU nano text editor"
[2]: https://www.nano-editor.org/dist/latest/README "www.nano-editor.org"
[3]: https://www.nano-editor.org/?utm_source=chatgpt.com "nano – Text editor"
[4]: https://www.nano-editor.org/dist/latest/nano.1.html "NANO"
[5]: https://www.nano-editor.org/dist/latest/cheatsheet.html "Cheatsheet for GNU nano"
[6]: https://www.nano-editor.org/dist/latest/nanorc.5.html "NANORC"
[7]: https://www.nano-editor.org/ "nano – Text editor"
[8]: https://www.nano-editor.org/docs.php "nano – Documentation"
[9]: https://www.nano-editor.org/git.php "nano – Source code"
[10]: https://www.nano-editor.org/who.php "nano – Who's who"
[nanorc]: ./nanorc/README.md 
