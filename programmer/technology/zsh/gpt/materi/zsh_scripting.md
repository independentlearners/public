> By GPT

# **ZSH Scripting**

Prinsip bahwa target akhirnya bukan sekadar bisa menulis `.zshrc`, tetapi mampu memahami mekanisme internal Zsh sehingga Anda dapat membangun fitur terminal sendiri.
Kurikulum ini mengikuti jalur yang sudah kita tetapkan sebelumnya: fondasi Bash → Zsh language → options → interactive Zsh → configuration → internals → productivity engineering. Struktur tersebut juga sesuai dengan materi yang sudah kita tetapkan sebelumnya. 

## Kurikulum Zsh — Beginner → Zsh Configuration Engineer

```text
ZSH SCRIPTING
│
├── 00. Persiapan & Mental Model
│
├── 01. Zsh vs Bash
│
├── 02. Zsh Language
│   ├── Parameters
│   ├── Expansion
│   ├── Quoting
│   ├── Arrays
│   ├── Associative Arrays
│   ├── Functions
│   ├── Conditions
│   ├── Loops
│   ├── Arithmetic
│   ├── Command Substitution
│   ├── Process Substitution
│   ├── Redirection
│   └── Exit Status
│
├── 03. Parameter Expansion
│
├── 04. Arrays & Data Manipulation
│
├── 05. Filename Generation / Glob
│
├── 06. Zsh Options
│   ├── setopt
│   ├── unsetopt
│   ├── Option flags
│   ├── Interactive options
│   └── Emulation
│
├── 07. Zsh Builtins & Native Features
│
├── 08. Functions & Autoload
│
├── 09. Zsh Startup Architecture
│   ├── .zshenv
│   ├── .zprofile
│   ├── .zshrc
│   ├── .zlogin
│   └── .zlogout
│
├── 10. Environment & PATH
│
├── 11. History
│
├── 12. Prompt
│
├── 13. Completion System
│   ├── compinit
│   ├── zstyle
│   ├── tags
│   ├── completers
│   └── completion functions
│
├── 14. ZLE
│   ├── Line editor
│   ├── Keymaps
│   ├── bindkey
│   ├── Widgets
│   └── BUFFER / CURSOR
│
├── 15. Hooks
│
├── 16. Zsh Modules
│   ├── zmodload
│   └── module architecture
│
├── 17. Modular Configuration
│
├── 18. Plugin Architecture
│
├── 19. Terminal Integration
│   ├── Git
│   ├── fzf
│   ├── zoxide
│   ├── yazi
│   └── external CLI tools
│
├── 20. Custom Productivity Features
│   ├── Custom aliases
│   ├── Custom functions
│   ├── Custom widgets
│   ├── Custom completion
│   └── Custom hooks
│
├── 21. Reading Zsh Plugins
│
├── 22. Modifying Existing Plugins
│
├── 23. Building Zsh Plugins
│
└── 24. Personal Zsh Framework
```

Ini bukan sekadar daftar topik. Setiap tahap akan mempunyai pola:

```text
TEORI
  ↓
SINTAKS
  ↓
EKSPERIMEN
  ↓
LATIHAN
  ↓
MINI PROJECT
  ↓
REVIEW
  ↓
EVALUASI
```

Jadi kita tidak akan hanya membaca dokumentasi.

---

## [00 — Persiapan & Mental Model][00]

Sebelum menyentuh konfigurasi, kita pastikan Anda memahami apa sebenarnya yang sedang Anda jalankan.

Materi:

```text
shell
├── shell sebagai interpreter
├── interactive shell
├── login shell
├── non-login shell
├── parent/child shell
├── environment
├── process
└── terminal
```

Kemudian:

```text
Bash
   │
   └── shell scripting

Zsh
   │
   ├── shell scripting
   └── programmable interactive shell
```

Target tahap:

> Anda mampu menjelaskan mengapa Zsh bukan sekadar “Bash dengan fitur lebih banyak”.

---

## [01 — Zsh vs Bash][01]

Ini akan menjadi tahap transisi Anda.

Kita tidak mengulang seluruh Bash.

Kita membandingkan:

```text
Bash                    Zsh
────────────────────────────────
variable                variable
parameter expansion     parameter expansion
array                   array
function                function
glob                    glob
condition               condition
option                  option
builtin                 builtin
trap                    hook/signal mechanism
completion              completion system
readline                ZLE
```

Fokusnya:

> “Saya sudah tahu konsep ini di Bash. Bagaimana Zsh mengimplementasikannya?”

Ini penting karena dokumentasi dan konfigurasi Zsh akan sering terlihat asing meskipun Anda sudah memahami shell.

---

## [02 — Zsh Language][02]

Kita mulai benar-benar menulis Zsh.

Urutannya:

```text
02.1 Parameters
02.2 Quoting
02.3 Expansion
02.4 Conditions
02.5 Functions
02.6 Loops
02.7 Arithmetic
02.8 Command substitution
02.9 Process substitution
02.10 Redirection
02.11 Exit status
```

Contoh awal:

```zsh
name="Cendekiawan"

print -r -- "$name"
```

Kemudian secara bertahap kita akan melihat perbedaan antara:

```zsh
$name
"$name"
${name}
"${name}"
```

dan mengapa quoting tetap penting di Zsh.

---

## [03 — Parameter Expansion][03]

Ini akan menjadi salah satu tahap paling penting.

Kita akan mempelajari:

```zsh
${name}
${name:u}
${name:l}
${name:h}
${name:t}
${name:s/foo/bar/}
${name//foo/bar}
${(q)name}
${(f)text}
```

Tujuannya bukan menghafal syntax.

Kita akan membangun mental model:

```text
parameter
    ↓
parameter expansion
    ↓
flags
    ↓
transformasi
    ↓
hasil
```

Tahap ini akan sangat membantu ketika nanti membaca plugin Zsh.

---

## [04 — Arrays & Data Manipulation][04]

Zsh sangat kuat pada array.

Kita pelajari:

```zsh
files=(one two three)
```

kemudian:

```text
indexed array
associative array
array slicing
array expansion
array transformation
array iteration
```

Termasuk:

```zsh
${files[1]}
${files[1,2]}
${files[@]}
${#files}
```

dan:

```zsh
typeset -A config
```

Target:

> Anda mampu menggunakan array sebagai struktur data native Zsh tanpa bergantung pada `sed`, `awk`, atau `cut` untuk setiap manipulasi sederhana.

---

## [05 — Filename Generation / Glob][05]

Ini salah satu kekuatan besar Zsh.

Kita mulai dari:

```zsh
*.txt
```

kemudian:

```zsh
**/*.lua
```

hingga extended glob:

```zsh
^*.bak
```

dan berbagai qualifier/filter glob.

Kita akan belajar membedakan:

```text
parameter expansion
        vs
filename generation
        vs
command substitution
```

Ini penting karena ketiganya sering bercampur ketika membaca konfigurasi Zsh.

---

## [06 — Zsh Options][06]

Ini adalah milestone pertama yang sangat besar.

Kita masuk ke:

```zsh
setopt
unsetopt
```

dan memahami:

```text
option
option name
option flag
default state
interactive option
emulation
```

Contoh:

```zsh
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt HIST_IGNORE_DUPS
```

ArchWiki juga menempatkan option dan konfigurasi `.zshrc` sebagai bagian penting dari konfigurasi Zsh. ([Wiki Arch Linux][1])

Target:

> Ketika melihat `setopt` dalam dotfiles orang lain, Anda langsung dapat memahami efeknya dan alasan penggunaannya.

---

## [07 — Zsh Builtins & Native Features][07]

Kita mulai mengurangi ketergantungan pada program eksternal ketika Zsh sudah menyediakan mekanisme native.

Misalnya memahami:

```text
print
typeset
autoload
functions
whence
which
read
fc
dirs
pushd
popd
source
```

dan lain-lain.

Targetnya bukan “jangan menggunakan command eksternal”.

Targetnya:

> tahu kapan Zsh sendiri sudah menyediakan mekanisme yang lebih tepat.

---

## [08 — Functions & Autoload][08]

Dari function biasa:

```zsh
my_function() {
    print "hello"
}
```

menuju:

```text
function
    ↓
autoload
    ↓
function file
    ↓
function discovery
    ↓
modular code
```

Ini akan menjadi jembatan menuju plugin architecture.

---

## [09 — Zsh Startup Architecture][09]

Ini sangat penting untuk tujuan Anda karena inti proyek Anda adalah konfigurasi Zsh.

Kita akan membedah:

```text
/etc/zsh/zshenv
        ↓
~/.zshenv
        ↓
/etc/zsh/zprofile
        ↓
~/.zprofile
        ↓
/etc/zsh/zshrc
        ↓
~/.zshrc
        ↓
/etc/zsh/zlogin
        ↓
~/.zlogin
        ↓
~/.zlogout
```

Urutan aktual bergantung pada jenis shell; ArchWiki mendokumentasikan startup/login/interactive path tersebut secara rinci. ([Wiki Arch Linux][1])

Kita juga akan mempelajari:

```zsh
$ZDOTDIR
```

dan bagaimana menempatkan konfigurasi Zsh di:

```text
~/.config/zsh/
```

ArchWiki juga mendokumentasikan penggunaan `$ZDOTDIR` untuk memindahkan konfigurasi Zsh ke XDG-style directory. ([Wiki Arch Linux][2])

Ini sangat relevan dengan dotfiles Anda.

---

## [10 — Environment & PATH][010]

Kita pelajari hubungan:

```text
shell variable
environment variable
PATH
path array
export
```

Salah satu karakteristik Zsh yang menarik adalah hubungan `PATH` dengan array `path`.

Ini akan menjadi contoh nyata bagaimana Zsh tidak selalu memperlakukan sesuatu seperti Bash.

---

## [11 — History][011]

Kita masuk ke:

```text
HISTFILE
HISTSIZE
SAVEHIST
history expansion
fc
history options
shared history
history search
```

Kemudian menghubungkannya dengan productivity workflow.

---

## [12 — Prompt][012]

Bukan langsung Starship.

Kita terlebih dahulu memahami prompt native Zsh:

```text
PS1
PROMPT
RPROMPT
prompt expansion
prompt themes
```

Kemudian baru:

```text
Starship
Powerlevel10k
custom prompt
```

Tujuannya agar ketika suatu plugin mengubah prompt, Anda memahami mekanisme di bawahnya.

---

## [13 — Completion System][013]

Ini milestone besar kedua.

Kita akan membedah:

```text
compinit
    ↓
completion system
    ↓
zstyle
    ↓
tags
    ↓
completers
    ↓
completion functions
```

Bukan hanya:

```zsh
autoload -Uz compinit
compinit
```

tetapi:

> “Apa yang sebenarnya terjadi setelah `compinit`?”

Ini akan membawa Anda dari pengguna Zsh menuju pembaca source code Zsh.

---

## [14 — ZLE][014]

Ini kemungkinan akan menjadi salah satu bagian yang paling Anda sukai.

```text
ZLE
│
├── line editor
├── keymap
├── bindkey
├── widget
├── BUFFER
├── CURSOR
└── editing state
```

Kemudian kita buat:

```zsh
my_widget() {
    BUFFER="echo hello"
    CURSOR=${#BUFFER}
}

zle -N my_widget
bindkey '^G' my_widget
```

ZLE menjadi fondasi untuk custom keyboard-driven productivity.

---

## [15 — Hooks][015]

Kita pelajari bagaimana menjalankan mekanisme ketika event tertentu terjadi.

Mental model:

```text
event
  ↓
hook
  ↓
function
  ↓
action
```

Ini akan menjadi dasar untuk membuat automation dalam interactive shell.

---

## [16 — Zsh Modules][015]

Kemudian:

```zsh
zmodload
```

dan konsep:

```text
module
builtin functionality
dynamic loading
zsh modules
```

Ini membawa kita lebih dekat ke pemahaman internal Zsh.

---

## [17 — Modular Configuration][015]

Sekarang kita mulai membangun konfigurasi nyata:

```text
~/.config/zsh/
├── .zshenv
├── .zprofile
├── .zshrc
├── options.zsh
├── environment.zsh
├── history.zsh
├── aliases.zsh
├── functions.zsh
├── completion.zsh
├── keybinds.zsh
├── prompt.zsh
└── integrations/
```

Kita akan menentukan apa yang seharusnya berada di masing-masing file.

---

## [18 — Plugin Architecture][015]

Baru setelah mekanisme Zsh dipahami, kita membahas:

```text
plugin
plugin manager
autoload
source
function path
completion path
load order
dependency
lazy loading
```

Dengan demikian Anda tidak menjadi pengguna plugin yang hanya menjalankan:

```zsh
source plugin.zsh
```

tanpa memahami isinya.

---

## [19 — Terminal Integration][015]
Baru kita integrasikan lingkungan Anda:

```text
Zsh
├── Git
├── fzf
├── zoxide
├── yazi
├── bat
├── eza
├── starship
└── terminal emulator
```

Tetapi setiap integrasi akan dipelajari dari sisi:

```text
external program
       ↓
Zsh interface
       ↓
function / alias / widget / hook
       ↓
interactive workflow
```

---

## [20 — Custom Productivity Features][015]
Sekarang mulai membuat fitur sendiri.

Contoh:

```text
Ctrl+G
   ↓
custom ZLE widget
   ↓
fzf
   ↓
select file
   ↓
insert result into BUFFER
```

Atau:

```text
directory change
       ↓
hook
       ↓
detect project
       ↓
change environment
       ↓
update prompt
```

Di tahap ini kemampuan Anda mulai berubah dari:

> “Saya mengonfigurasi Zsh.”

menjadi:

> “Saya memprogram perilaku Zsh.”

---

## [21–23 — Membaca, Memodifikasi, Membuat Plugin][015]
Ini adalah tahap menuju tujuan akhir.

Urutannya:

```text
21. Read plugin
       ↓
22. Understand mechanism
       ↓
23. Modify plugin
       ↓
24. Build own plugin
```

Kita akan mengambil plugin nyata dan membedahnya.

Anda akan belajar mencari:

```text
autoload
function
zstyle
compdef
zle
bindkey
hook
setopt
zmodload
```

di source code.

---

## [24 — Personal Zsh Framework][015]

### Final project.

Anda membangun konfigurasi/framework Zsh sendiri:

```text
my-zsh/
│
├── bootstrap
├── core
│   ├── options
│   ├── environment
│   └── history
│
├── functions
├── aliases
├── completion
├── widgets
├── hooks
├── prompt
├── integrations
│   ├── git
│   ├── fzf
│   ├── zoxide
│   └── yazi
│
└── plugins
```

Target akhirnya:

```text
Anda menemukan kebutuhan baru
        ↓
tentukan mekanisme Zsh
        ↓
baca dokumentasi
        ↓
eksperimen
        ↓
buat function/widget/hook/completion
        ↓
integrasikan
        ↓
uji
        ↓
masukkan ke dotfiles
```

Itulah kompetensi yang sebenarnya kita kejar.

## Sistem evaluasi kita

Setiap selesai materi saya akan memberikan:

```text
Pemahaman konsep       /10
Pemahaman syntax       /10
Kemampuan praktik      /10
Kemampuan debugging    /10
Pemahaman internal     /10
```

Kemudian:

```text
Progress Kurikulum
████░░░░░░░░░░░░░░░░  20%
```

Nilai tidak akan diberikan hanya karena Anda berhasil menjalankan command. Saya akan menilai apakah Anda memahami **mengapa mekanisme tersebut bekerja**.

---

# Kita mulai sekarang — Lesson 00.1

Sebelum masuk ke syntax, kita buat lingkungan eksperimen yang aman.

Jangan langsung mengganti shell login Anda. Kita jalankan Zsh sebagai child shell:

```bash
zsh
```

Kemudian periksa:

```zsh
print -r -- "$ZSH_VERSION"
print -r -- "$ZSH_NAME"
print -r -- "$SHELL"
```

Perhatikan perbedaannya.

`$SHELL` menunjukkan shell login yang tercatat untuk user, sehingga nilainya tidak harus berubah hanya karena Anda menjalankan `zsh` dari Bash.

Kemudian:

```zsh
ps -p $$
```

dan:

```zsh
echo $-
```

Tujuan latihan pertama ini sederhana: **membedakan shell yang sedang berjalan dari shell login dan memahami bahwa kita dapat bereksperimen dengan Zsh tanpa mengubah sistem login.**

Ini juga pendekatan yang aman untuk tahap awal; ArchWiki menyarankan Zsh dapat dijalankan langsung untuk memastikan instalasinya sebelum menjadikannya default shell. ([Wiki Arch Linux][1])

Setelah itu kita masuk ke **Lesson 00.2: interactive shell vs login shell**, karena konsep tersebut akan menjadi fondasi untuk memahami seluruh arsitektur `.zshenv → .zprofile → .zshrc → .zlogin → .zlogout`.

[1]: https://wiki.archlinux.org/title/zsh?source=post_page---------------------------&utm_source=chatgpt.com "Zsh - ArchWiki"
[2]: https://wiki.archlinux.org/title/XDG_Base_Directory?utm_source=chatgpt.com "XDG Base Directory - ArchWiki"

[00]: ./bagian-1/README.md
[01]: ./bagian-2/README.md
[02]: ./bagian-3/README.md
[03]: ./bagian-4/README.md
[04]: ./bagian-5/README.md
[05]: ./bagian-6/README.md
[06]: ./bagian-7/README.md
[07]: ./bagian-8/README.md
[08]: ./bagian-9/README.md
[09]: ./bagian-10/README.md
[010]: ./bagian-11/README.md
[011]: ./bagian-12/README.md
[012]: ./bagian-13/README.md
[013]: ./bagian-14/README.md
[014]: ./bagian-15/README.md

