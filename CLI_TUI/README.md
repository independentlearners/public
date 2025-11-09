* **Bahasa sumber utama** tempat tool tersebut ditulis.
* **Tujuan dan manfaat utama**.
* **Pra-syarat jika ingin memodifikasi atau mengembangkannya.**

---

## 🧭 1. Dasar Sistem dan Navigasi

| Tool                                               | Bahasa Sumber | Fungsi                                     | Syarat jika ingin memodifikasi        |
| -------------------------------------------------- | ------------- | ------------------------------------------ | ------------------------------------- |
| **coreutils** (`ls`, `cp`, `mv`, `rm`, `cat`, dll) | C             | Utilitas dasar sistem GNU                  | Kuasai C dan sistem POSIX API         |
| **tree**                                           | C             | Menampilkan struktur direktori             | Dasar I/O C dan manipulasi filesystem |
| **bat**                                            | Rust          | Pengganti `cat` dengan warna & nomor baris | Pahami Rust dan crate `syntect`       |
| **exa / eza**                                      | Rust          | Pengganti modern untuk `ls`                | Rust dan konsep filesystem Linux      |
| **btop**                                           | C++           | Monitor sistem dengan TUI                  | C++ dan konsep sistem proses Linux    |

---

## 🐚 2. Shell dan Automasi

| Tool        | Bahasa | Fungsi                                           | Syarat Pengembangan                 |
| ----------- | ------ | ------------------------------------------------ | ----------------------------------- |
| **bash**    | C      | Shell klasik dan scripting utama                 | Teori shell grammar, fork/exec      |
| **zsh**     | C      | Shell interaktif modern                          | C dan konfigurasi `zle`             |
| **fish**    | C++    | Shell dengan fitur otomatisasi pintar            | C++ dan parser fish-script          |
| **nushell** | Rust   | Shell berbasis data structured (pipeline modern) | Rust dan konsep AST & JSON pipeline |
| **tmux**    | C      | Multiplexer terminal                             | Pahami ncurses dan event loop       |
| **dtach**   | C      | Lightweight session detach                       | C dasar dan UNIX socket             |

---

## 📦 3. Manajemen Paket

| Tool                   | Bahasa           | Fungsi                           | Syarat Pengembangan                |
| ---------------------- | ---------------- | -------------------------------- | ---------------------------------- |
| **pacman**             | C                | Package manager utama Arch Linux | C dan libalpm                      |
| **yay / paru**         | Go / Rust        | AUR helper untuk Arch            | Go/Rust dan pacman wrapper         |
| **apt / dnf / zypper** | C / C++ / Python | Package manager distro lain      | Sistem dependensi & database lokal |
| **Homebrew**           | Ruby             | Package manager macOS/Linux      | Ruby dan DSL internal Homebrew     |
| **winget / scoop**     | C# / PowerShell  | Package manager Windows          | C#, PowerShell scripting           |

---

## 💻 4. Terminal Emulator

| Tool          | Bahasa     | Kelebihan                   | Syarat Modifikasi         |
| ------------- | ---------- | --------------------------- | ------------------------- |
| **Kitty**     | C + Python | GPU-accelerated terminal    | OpenGL + Python scripting |
| **Alacritty** | Rust       | Performa tinggi via GPU     | Rust dan konsep OpenGL    |
| **WezTerm**   | Rust + Lua | Terminal modern + scripting | Lua + Rust interop        |
| **Foot**      | C          | Ringan dan Wayland-native   | Wayland API dan C dasar   |

---

## 🧰 5. Tools Pengembang (DevTools)

| Tool              | Bahasa       | Fungsi                     | Syarat Modifikasi                     |
| ----------------- | ------------ | -------------------------- | ------------------------------------- |
| **git**           | C            | Version control system     | C dan algoritma delta encoding        |
| **make**          | C            | Build automation           | Parsing Makefile dan shell invocation |
| **cmake**         | C++          | Build system generator     | AST parser untuk build rules          |
| **yacc / bison**  | C            | Generator parser           | Teori compiler, CFG, LALR parser      |
| **lex / flex**    | C            | Generator lexer            | Teori automata dan token scanning     |
| **meson / ninja** | Python / C++ | Build system modern        | Build graph, dependency tree          |
| **pandoc**        | Haskell      | Konversi dokumen universal | Haskell dan AST transformer           |
| **jq / yq**       | C / Go       | Parser JSON & YAML CLI     | C/Go dan parser structured data       |
| **ripgrep (rg)**  | Rust         | Pencarian teks cepat       | Rust, regex engine                    |
| **fzf**           | Go           | Fuzzy finder interaktif    | Go dan konsep TUI event loop          |

---

## 🧩 6. Editor & IDE Terminal

| Tool             | Bahasa  | Kelebihan                          | Syarat Modifikasi         |
| ---------------- | ------- | ---------------------------------- | ------------------------- |
| **vim / neovim** | C / Lua | Editor klasik, bisa diprogram      | Lua dan C API             |
| **helix**        | Rust    | Modern modal editor                | Rust dan konsep rope text |
| **nano**         | C       | Editor ringan untuk sistem minimal | C dasar                   |
| **micro**        | Go      | Editor TUI dengan plugin Go        | Go dan TUI rendering      |

---

## 🔣 7. Scripting dan Bahasa CLI

| Bahasa     | Alasan Relevan di CLI                   | Syarat Pengembangan            |
| ---------- | --------------------------------------- | ------------------------------ |
| **Bash**   | Shell utama Linux                       | Shell syntax & POSIX           |
| **Lua**    | Embeddable, dipakai di Neovim & WezTerm | Lua runtime dan FFI            |
| **Python** | Automasi sistem dan parser file         | Python CLI & argparse          |
| **Dart**   | CLI lintas platform (Flutter, SDK CLI)  | Dart SDK, isolate & arg parser |
| **Go**     | Kompilasi cepat untuk CLI statis        | Go CLI & cobra framework       |
| **Rust**   | CLI high-performance                    | Clap crate, ownership concept  |

---

## 🌐 8. Remote dan Networking

| Tool                  | Bahasa  | Fungsi                      | Syarat Modifikasi             |
| --------------------- | ------- | --------------------------- | ----------------------------- |
| **ssh / scp / rsync** | C       | Remote akses & sinkronisasi | C dan protokol TCP/SSH        |
| **curl / wget**       | C       | Transfer data HTTP          | Libcurl dan TCP/IP dasar      |
| **nmap**              | C / Lua | Network scanning            | C dan scripting Lua           |
| **iperf3**            | C       | Pengukuran bandwidth        | Socket programming            |
| **mosh**              | C++     | SSH dengan UDP              | Network protocol & reassembly |

---

## 🧠 9. Dokumentasi, Markdown, dan Output

| Tool       | Bahasa  | Fungsi                | Syarat Modifikasi     |
| ---------- | ------- | --------------------- | --------------------- |
| **man**    | C       | Dokumentasi sistem    | roff macro & pager    |
| **tldr**   | Node.js | Ringkasan perintah    | Node + JSON API       |
| **pandoc** | Haskell | Konversi antar format | Haskell & pandoc AST  |
| **mdbook** | Rust    | Buku dari Markdown    | Rust & pulldown-cmark |

---

## ⚙️ 10. Eksperimen dan Debug CLI

| Tool            | Bahasa  | Fungsi                    | Syarat Pengembangan    |
| --------------- | ------- | ------------------------- | ---------------------- |
| **strace**      | C       | Lacak syscall proses      | Kernel & syscall table |
| **lsof**        | C       | Daftar file terbuka       | File descriptor system |
| **htop / btop** | C / C++ | Monitor proses interaktif | ncurses                |
| **perf**        | C       | Profiling kernel-level    | Linux perf API         |
| **gdb**         | C       | Debugger                  | ELF, symbol table      |

---

## 🧱 Kesimpulan Umum

| Kategori         | Tool Inti                 | Bahasa Utama   | Tingkat Kesulitan Modifikasi |
| ---------------- | ------------------------- | -------------- | ---------------------------- |
| Sistem Dasar     | coreutils, tree, bat, exa | C / Rust       | Mudah–Menengah               |
| Shell & Automasi | bash, zsh, nushell        | C / Rust       | Menengah                     |
| Paket            | pacman, yay               | C / Go         | Menengah                     |
| Terminal         | kitty, wezterm, foot      | C / Rust       | Menengah–Sulit               |
| DevTools         | make, yacc, git           | C              | Sulit                        |
| Editor           | neovim, helix             | C / Lua / Rust | Menengah–Sulit               |
| Bahasa CLI       | Bash, Lua, Dart, Go, Rust | —              | Menengah–Sulit               |

---

