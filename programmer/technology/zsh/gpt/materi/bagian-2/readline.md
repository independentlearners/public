# READLINE

**Readline** adalah library GNU yang dipakai Bash untuk mengelola input di terminal: mengedit teks perintah, menggerakkan kursor, mengelola riwayat perintah, dan melakukan tab completion. Jadi saat kamu mengetik di prompt Bash, yang menangani pengalaman mengetiknya sebagian besar adalah Readline. [wiki.archlinux](https://wiki.archlinux.org/title/Readline)

## Yang dilakukan Readline

- Mengedit baris perintah: pindah kursor, hapus kata/karakter, copy-paste, dsb. [wiki.archlinux](https://wiki.archlinux.org/title/Readline)
- Mengelola command history: tekan panah atas/bawah atau `Ctrl-R` untuk mencari perintah lama. [en.wikipedia](https://en.wikipedia.org/wiki/GNU_Readline)
- Tab completion untuk melengkapi nama file, perintah, atau argumen. [en.wikipedia](https://en.wikipedia.org/wiki/GNU_Readline)
- Menyediakan mode shortcut gaya **Emacs** (default) atau **vi**. [wiki.archlinux](https://wiki.archlinux.org/title/Readline)

## Contoh shortcut

| Shortcut | Fungsi |
|---|---|
| `Ctrl-A` | Pindah ke awal baris |
| `Ctrl-E` | Pindah ke akhir baris |
| `Ctrl-U` | Hapus teks sebelum kursor |
| `Ctrl-R` | Cari perintah di history |
| `Tab` | Melengkapi nama perintah/file |

Contohnya, `Ctrl-A` lalu `Ctrl-E` memindahkan kursor dari awal ke akhir perintah yang sedang diketik—itu semua dikerjakan Readline, bukan Bash itu sendiri. [twobithistory](https://twobithistory.org/2019/08/22/readline.html)

## Kustomisasi

Readline bisa dikonfigurasi lewat file `~/.inputrc`, misalnya mengubah keybinding atau mengaktifkan mode vi. Bash juga punya perintah `bind` untuk mengatur binding Readline dari shell. [gnu](https://www.gnu.org/software/bash/manual/bash.html)

Singkatnya: **Bash adalah shell-nya; Readline adalah “editor satu baris” yang membuat prompt Bash nyaman dipakai.** [gnu](https://www.gnu.org/software/bash/manual/bash.html)
