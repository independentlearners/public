# Text Editor CLI

Berikut daftar inti **editor CLI/terminal** yang paling relevan dan lintas platform. Daftar ini **bukan klaim absolut “semua yang pernah ada”**, karena ekosistemnya sangat luas, tetapi ini mencakup nama-nama utama yang paling dipakai dan paling sering muncul di dokumentasi resmi. 🧰

1. **Vim** — editor `vi` yang ditingkatkan; resmi mendukung UNIX, Windows, Macintosh, Amiga, OS/2, VMS, QNX, dan sistem Unix lainnya. Basis kode resminya dominan **Vim Script** dan **C**. ([vim.org][1])

2. **[Neovim][nvim]** — fork dari Vim yang fokus pada extensibility dan usability; ada paket siap pakai untuk **Windows, macOS, dan Linux**. Source tree resminya menunjukkan **C, Lua, Vim Script, CMake**; Neovim juga menyediakan API untuk banyak bahasa. ([GitHub][2])

3. **GNU Emacs** — editor yang sangat extensible; dokumen resmi menyebut dukungan untuk **GNU/Linux, BSD, Haiku, macOS, Windows, Android, Solaris, dan MS-DOS/FreeDOS**. Di mode terminal, Emacs memakai seluruh layar terminal, dan kustomisasi utamanya dilakukan lewat **Emacs Lisp**. ([gnu.org][3])

4. **Helix** — editor modal modern yang ditulis dalam **Rust**. Instalasi resminya lewat package manager OS, prebuilt binary, atau build dari source; untuk fitur penuh, Helix mengandalkan **language server**. ([GitHub][4])

5. **micro** — editor terminal yang ringan, single-binary, dan cross-platform pada platform yang didukung Go; Windows didukung, tetapi **Mingw/Cygwin tidak**. Plugin micro ditulis dalam **Lua**, dan build dari source memerlukan **Go 1.19+**. ([GitHub][5])

6. **Kakoune** — editor modal berbasis selection-first; dapat dikustomisasi memakai **macros** atau **hooks**. Kakoune dapat dibangun di **Linux, macOS, dan Cygwin**, memerlukan compiler **C++20**, dan **native Windows tidak direncanakan**. ([kakoune.org][6])

7. **JOE** — terminal-based screen editor yang sudah lama dipakai dan tersedia di banyak distribusi Linux. Dokumentasi resminya menyebut JOE ditulis dalam **C**, hanya bergantung pada **libc**, dan mudah dibangun dengan `configure` + `make install`. ([joe-editor.sourceforge.io][7])

8. **[GNU nano][nano]** — editor kecil dan ramah untuk terminal; fitur resminya mencakup **undo/redo, syntax coloring, interactive search-and-replace, auto-indentation, line numbers, word completion, backup files**, dan lain-lain. ([nano-editor.org][8])

9. **ed** — editor **line-oriented** yang dipakai interaktif maupun dari shell script. Ini adalah utilitas standar POSIX, jadi sangat fundamental di dunia Unix-like. ([gnu.org][9])

10. **vi** — editor **screen-oriented** standar POSIX; ini adalah fondasi historis dari keluarga Vim/vi. ([man7.org][10])

Kalau dilihat dari sisi **ekstensibilitas untuk belajar dan modifikasi**, urutannya biasanya paling kuat adalah **Neovim → Emacs → Vim → Helix → micro → Kakoune → JOE → nano → ed**; urutan ini saya buat dari kemampuan plugin, scripting, dan kemudahan pengembangan, bukan dari “terbaik” secara mutlak. ([GitHub][2])

[1]: https://www.vim.org/viusers.php?utm_source=chatgpt.com "for Vi users : vim online"
[2]: https://github.com/neovim/neovim "GitHub - neovim/neovim: Vim-fork focused on extensibility and usability · GitHub"
[3]: https://www.gnu.org/software/emacs/download.html "GNU Emacs download - GNU Project"
[4]: https://github.com/helix-editor/helix "GitHub - helix-editor/helix: A post-modern modal text editor. · GitHub"
[5]: https://github.com/micro-editor/micro/blob/master/README.md "micro/README.md at master · micro-editor/micro · GitHub"
[6]: https://kakoune.org/ "Kakoune - Official site"
[7]: https://joe-editor.sourceforge.io/ "Home - Joe's Own Editor"
[8]: https://www.nano-editor.org/dist/latest/nano.html?utm_source=chatgpt.com "The GNU nano text editor"
[9]: https://www.gnu.org/software/ed/manual/ed_manual.html?utm_source=chatgpt.com "GNU 'ed' Manual"
[10]: https://man7.org/linux/man-pages/man1/vi.1p.html "vi(1p) - Linux manual page"
[nvim]: ./neovim/README.md
[nano]: ./nano/README.md
