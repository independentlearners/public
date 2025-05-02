## Halaman Manual Git

### judul

git - pelacak konten bodoh

**Sinopsis**

```ps
git [-v | --version] [-h | --help] [-C <path>] [-c <name>=<value>]
    [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
    [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--no-lazy-fetch]
    [--no-optional-locks] [--no-advice] [--bare] [--git-dir=<path>]
    [--work-tree=<path>] [--namespace=<name>] [--config-env=<name>=<envvar>]
    <command> [<args>]
```

**Deskripsi**

GIT adalah sistem kontrol revisi yang cepat, skalabel, terdistribusi dengan
set perintah yang kaya secara tidak biasa yang menyediakan
operasi tingkat tinggi
dan akses penuh ke internal.

Lihat gittutorial(7) untuk memulai, lalu lihat
giteveryday(7) untuk set minimum yang berguna
perintah. Manual Pengguna Git memiliki pengenalan yang lebih
mendalam.

Setelah Anda menguasai konsep dasar, Anda dapat kembali ke halaman ini untuk mempelajari perintah apa yang ditawarkan Git. Anda dapat mempelajari lebih lanjut tentang
perintah Git individu dengan "git help command". Halaman manual gitcli(7) memberikan Anda gambaran tentang sintaks perintah baris.

Salinan yang diformat dan dilinkkan dari dokumentasi Git terbaru
dapat dilihat [disini](https://git.github.io/htmldocs/git.html)
atau [disini](https://git-scm.com/docs).

#### PILIHAN

Cetak versi suite Git yang berasal dari program git.

Pilihan ini secara internal dikonversi menjadi git version dan menerima
pilihan yang sama seperti perintah git-version(1). Jika --help juga diberikan, itu mengambil
prioritas atas --version.

Cetak sinopsis dan daftar perintah yang paling umum digunakan. Jika opsi --all atau -a diberikan maka semua
perintah yang tersedia dicetak. Jika sebuah perintah Git disebut opsi ini akan
membuka halaman manual untuk perintah tersebut.

Opsi lain tersedia untuk mengendalikan cara halaman manual ditampilkan. Lihat git-help(1) untuk informasi lebih lanjut,
karena git `--help` dikonversi secara internal menjadi git
bantuan

Jalankan seolah-olah git dimulai di <path> alih-alih direktori kerja
saat ini. Ketika opsi -C diberikan secara berganda, setiap
non-absolut -C <path> berikutnya ditafsirkan relatif terhadap -C
<path> sebelumnya. Jika <path> ada tetapi kosong, misalnya -C "", maka
direktori kerja saat ini tidak berubah.

Opsi ini mempengaruhi opsi yang mengharapkan nama jalur seperti `--git-dir dan`
--work-tree dalam interpretasi mereka dari nama jalur akan dibuat
relatif ke direktori kerja yang disebabkan oleh opsi -C. Misalnya, panggilan berikut
setara:

```ps
git --git-dir=a.git --work-tree=b -C c status
git --git-dir=c/a.git --work-tree=c/b status
```

Luluskan parameter konfigurasi ke perintah. Nilai
yang diberikan akan menimpa nilai dari file konfigurasi.
<name> diharapkan dalam format yang sama seperti yang tercantum oleh
git config (subkeys dipisahkan oleh titik).

Catatan bahwa menghilangkan = dalam git -c foo.bar ... diizinkan dan mengatur
foo.bar ke nilai boolean true (sama seperti [foo]bar akan dalam
file config). Termasuk sama tetapi dengan nilai kosong (seperti git -c
foo.bar= ...) mengatur foo.bar ke string kosong yang git config
--type=bool akan dikonversi menjadi false.
Seperti -c <name>=<value>, berikan variabel konfigurasi
<name> nilai, di mana <envvar> adalah nama
variabel lingkungan dari mana untuk mengambil nilai. Tidak seperti
-c tidak ada pintasan untuk langsung mengatur nilai ke string kosong, sebaliknya
variabel lingkungan itu sendiri harus diatur ke string kosong. Ini adalah kesalahan jika <envvar> tidak ada
di lingkungan. <envvar> mungkin tidak mengandung tanda sama
untuk menghindari ambigu dengan <name> yang mengandung satu.

Ini berguna untuk kasus di mana Anda ingin melewati opsi konfigurasi sementara ke git, tetapi melakukan hal itu
di sistem operasi di mana proses lain mungkin dapat membaca baris perintah Anda
(misalnya /proc/self/cmdline), tetapi tidak lingkungan Anda
(misalnya /proc/self/environ). Perilaku itu adalah default di
Linux, tetapi mungkin tidak di sistem Anda.

Catatan bahwa ini mungkin menambah keamanan untuk variabel seperti
http.extraHeader di mana informasi sensitif adalah bagian dari
nilai, tetapi bukan e.g. url.<base>.insteadOf di mana
informasi sensitif dapat menjadi bagian dari kunci.

Jalur ke mana program inti Git Anda terinstal.
Ini juga dapat dikendalikan dengan mengatur variabel lingkungan GIT_EXEC_PATH. Jika tidak ada jalur yang diberikan, git akan mencetak
pengaturan saat ini dan kemudian keluar.

Cetak jalur, tanpa slash trailing, di mana dokumentasi HTML Git
terpasang dan keluar.

Cetak manpath (lihat man(1)) untuk halaman manual untuk
versi Git ini dan keluar.

Cetak jalur di mana file Info yang mendokumentasikan
versi Git ini terpasang dan keluar.

Salurkan semua output ke less (atau jika diatur, $PAGER) jika output standar adalah
terminal. Ini menimpa opsi pager.<cmd>
(lihat bagian "Mechanisme Konfigurasi" di bawah).
Jangan menyalurkan output Git ke pager.

Atur jalur ke repository (".git" directory). Ini juga dapat
dikendalikan dengan mengatur variabel lingkungan GIT_DIR. Bisa
jadi jalur absolut atau jalur relatif ke direktori kerja saat ini.

Menentukan lokasi direktori ".git" menggunakan opsi ini (atau variabel lingkungan GIT_DIR) mematikan
penemuan repository yang mencoba menemukan direktori dengan
".git" subdirektori (yang merupakan cara repository dan
atas-level pohon kerja ditemukan), dan memberitahu Git
bahwa Anda berada di level atas pohon kerja. Jika Anda
tidak berada di direktori level atas pohon kerja, Anda
harus memberitahu Git di mana level atas pohon kerja,
dengan opsi --work-tree=<path> (atau variabel lingkungan GIT_WORK_TREE)

Jika Anda hanya ingin menjalankan git seolah-olah dimulai di <path> maka gunakan
git -C <path>.

Atur jalur ke pohon kerja. Bisa
jadi jalur absolut atau jalur relatif ke direktori kerja saat ini.
Ini juga dapat dikendalikan dengan mengatur variabel lingkungan GIT_WORK_TREE
dan variabel konfigurasi core.worktree (lihat core.worktree di git-config(1) untuk diskusi
lebih terperinci).

Atur namespace Git. Lihat gitnamespaces(7) untuk detail
lebih lanjut. Setara dengan mengatur variabel lingkungan GIT_NAMESPACE.

Perlakukan repository sebagai repository telanjang. Jika variabel lingkungan GIT_DIR
tidak diatur, itu diatur ke direktori kerja saat ini.

Jangan gunakan refs pengganti untuk mengganti objek Git.
Ini setara dengan mengekspor variabel lingkungan GIT_NO_REPLACE_OBJECTS
dengan nilai apa pun.
Lihat git-replace(1) untuk informasi lebih lanjut.
Jangan ambil objek yang hilang dari promisor remote secara permintaan. Berguna bersama dengan git cat-file -e <object> untuk
melihat apakah objek tersedia secara lokal.
Ini setara dengan mengatur variabel lingkungan GIT_NO_LAZY_FETCH
ke 1.

Jangan melakukan operasi opsional yang memerlukan kunci. Ini
setara dengan mengatur GIT_OPTIONAL_LOCKS ke 0.

Nonaktifkan semua petunjuk saran yang dicetak.

Perlakukan pathspecs secara harfiah (yaitu tidak ada globbing, tidak ada pathspec magic).
Ini setara dengan mengatur variabel lingkungan GIT_LITERAL_PATHSPECS ke 1.

Tambahkan "glob" magic ke semua pathspec. Ini setara dengan mengatur
variabel lingkungan GIT_GLOB_PATHSPECS ke 1. Menonaktifkan
globbing pada pathspecs individu dapat dilakukan menggunakan pathspec
magic ":(literal)"

Tambahkan "literal" magic ke semua pathspec. Ini setara dengan mengatur
variabel lingkungan GIT_NOGLOB_PATHSPECS ke 1. Mengaktifkan
globbing pada pathspecs individu dapat dilakukan menggunakan pathspec
magic ":(glob)"

Tambahkan "icase" magic ke semua pathspec. Ini setara dengan mengatur
variabel lingkungan GIT_ICASE_PATHSPECS ke 1.

Daftar perintah berdasarkan kelompok. Ini adalah opsi internal/eksperimental
dan mungkin berubah atau dihapus di masa depan. Kelompok yang didukung adalah: builtins, parseopt (builtin commands that use
parse-options), main (all commands in libexec directory),
others (all other commands in $PATH that have git- prefix),
list-<category> (lihat kategori di command-list.txt),
nohelpers (exclude helper commands), alias dan config
(retrieve command list from config variable completion.commands)
Baca gitattributes dari <tree-ish> alih-alih pohon kerja. Lihat
gitattributes(5). Ini setara dengan mengatur
variabel lingkungan GIT_ATTR_SOURCE.

PERINTAH GIT

Kami membagi Git menjadi perintah tingkat tinggi ("porcelain") dan perintah tingkat rendah
("plumbing").

Perintah tingkat tinggi (porcelain)

Kami memisahkan perintah porcelain menjadi perintah utama dan beberapa
utilitas pengguna tambahan.

Perintah porcelain utama

git-add(1)

Tambahkan konten file ke indeks.

git-am(1)

Terapkan serangkaian patch dari kotak surat.

git-archive(1)

Buat arsip file dari pohon yang diberi nama.

git-backfill(1)

Unduh objek yang hilang dalam klon parsial.

git-bisect(1)

Gunakan pencarian biner untuk menemukan commit yang memperkenalkan bug.

git-branch(1)

Daftar, buat, atau hapus cabang.

git-bundle(1)

Pindahkan objek dan refs dengan arsip.

git-checkout(1)

Beralih cabang atau memulihkan file pohon kerja.

git-cherry-pick(1)

Terapkan perubahan yang diperkenalkan oleh beberapa commit yang ada.

git-citool(1)

Alternatif grafis untuk git-commit.

git-clean(1)

Hapus file yang tidak dilacak dari pohon kerja.

git-clone(1)

Kloning repository ke direktori baru.

git-commit(1)

Rekam perubahan ke repository.

git-describe(1)

Berikan nama yang dapat dibaca manusia berdasarkan ref yang tersedia.

git-diff(1)

Tampilkan perubahan antara commit, commit dan pohon kerja, dll.

git-fetch(1)

Unduh objek dan refs dari repository lain.

git-format-patch(1)

Siapkan patch untuk pengiriman email.

git-gc(1)

Bersihkan file yang tidak perlu dan optimalkan repository lokal.
git-grep(1)

Cetak baris yang cocok dengan pola.

git-gui(1)

Antarmuka grafis portabel untuk Git.

git-init(1)

Buat repository Git kosong atau inisialisasi ulang yang ada.

git-log(1)

Tampilkan log commit.

git-maintenance(1)

Jalankan tugas untuk mengoptimalkan data repository Git.

git-merge(1)

Gabung dua atau lebih sejarah pengembangan bersama.

git-mv(1)

Pindahkan atau ubah nama file, direktori, atau simpul.

git-notes(1)

Tambahkan atau periksa catatan objek.

git-pull(1)

Ambil dari dan integrasikan dengan repository lain atau cabang lokal.

git-push(1)

Perbarui refs remote bersama dengan objek yang terkait.

git-range-diff(1)

Bandingkan dua rentang commit (misalnya dua versi cabang).

git-rebase(1)

Reapply commit di atas tip basis lain.

git-reset(1)

Reset HEAD saat ini ke keadaan tertentu.

git-restore(1)

Memulihkan file pohon kerja.

git-revert(1)

Membalikkan beberapa commit yang ada.

git-rm(1)

Hapus file dari pohon kerja dan dari indeks.

git-shortlog(1)

Ringkasan output git log.

git-show(1)

Tampilkan berbagai jenis objek.

git-sparse-checkout(1)

Kurangi pohon kerja Anda menjadi subset file yang dilacak.

git-stash(1)

Simpan perubahan di direktori kerja yang kotor.

git-status(1)

Tampilkan status pohon kerja.

git-submodule(1)

Inisialisasi, perbarui atau periksa modul.

git-survey(1)

EXPERIMENTAL: Mengukur berbagai dimensi repository.

git-switch(1)

Beralih cabang.

git-tag(1)

Buat, daftar, hapus atau verifikasi objek tag yang ditandatangani dengan GPG.

git-worktree(1)

Kelola pohon kerja yang berbeda.
gitk(1)

Browser repository Git.

scalar(1)

Alat untuk mengelola repository Git yang besar.

Perintah tambahan

Manipulator:

git-config(1)

Dapatkan dan atur opsi repository atau global.

git-fast-export(1)

Ekspor data Git.

git-fast-import(1)

Backend untuk impor data Git yang cepat.

git-filter-branch(1)

Ulangi cabang.

git-mergetool(1)

Jalankan alat konflik penggabungan untuk menyelesaikan konflik penggabungan.

git-pack-refs(1)

Pack kepala dan tag untuk akses repository yang efisien.

git-prune(1)

Prune semua objek yang tidak dapat dijangkau dari basis data objek.

git-reflog(1)

Kelola informasi reflog.

git-refs(1)

Akses tingkat rendah ke refs.

git-remote(1)

Kelola set repository yang dilacak.

git-repack(1)

Pack objek yang tidak dikemas di repository.

git-replace(1)

Buat, daftar, hapus refs untuk mengganti objek.

Interogator:

git-annotate(1)

Annotate baris file dengan informasi commit.

git-blame(1)

Tampilkan revisi dan penulis terakhir yang memodifikasi setiap baris file.

git-bugreport(1)

Kumpulkan informasi untuk pengguna untuk membuat laporan bug.

git-count-objects(1)

Hitung objek yang tidak dikemas dan konsumsi disknya.

git-diagnose(1)

Buat arsip zip informasi diagnostik.

git-difftool(1)

Tampilkan perubahan menggunakan alat diff umum.

git-fsck(1)

Memverifikasi konektivitas dan validitas objek di basis data.

git-help(1)

Tampilkan informasi bantuan tentang Git.

git-instaweb(1)

Seketika jelajahi repository kerja Anda di gitweb.

git-merge-tree(1)

Lakukan penggabungan tanpa menyentuh indeks atau pohon kerja.
git-rerere(1)

Reuse rekaman resolusi konflik penggabungan.

git-show-branch(1)

Tampilkan cabang dan commit mereka.

git-verify-commit(1)

Periksa tanda tangan GPG dari commit.

git-verify-tag(1)

Periksa tanda tangan GPG dari tag.

git-version(1)

Tampilkan informasi versi tentang Git.

git-whatchanged(1)

Tampilkan log dengan perbedaan yang diperkenalkan oleh setiap commit.

gitweb(1)

Antarmuka web Git (antarmuka depan web untuk repository Git).

Berinteraksi dengan Lainnya

Perintah ini untuk berinteraksi dengan SCM asing dan dengan orang lain melalui patch di atas email.

git-archimport(1)

Impor repository GNU Arch ke Git.

git-cvsexportcommit(1)

Ekspor commit tunggal ke checkout CVS.

git-cvsimport(1)

Selamatkan data Anda dari SCM lain yang orang suka benci.

git-cvsserver(1)

Emulator server CVS untuk Git.

git-imap-send(1)

Kirim koleksi patch dari stdin ke folder IMAP.

git-p4(1)

Impor dari dan submit ke repository Perforce.

git-quiltimport(1)

Terapkan patchset quilt ke cabang saat ini.

git-request-pull(1)

Menghasilkan ringkasan perubahan yang tertunda.

git-send-email(1)

Kirim koleksi patch sebagai email.

git-svn(1)

Operasi bolak-balik antara repository Subversion dan Git.

Reset, restore dan revert

Ada tiga perintah dengan nama yang mirip: git reset,
git restore dan git revert.

git-revert(1) adalah tentang membuat commit baru yang membalikkan
perubahan yang dibuat oleh commit lain.

git-restore(1) adalah tentang memulihkan file di pohon kerja
dari indeks atau commit lain. Perintah ini tidak
memperbarui cabang Anda. Perintah juga dapat digunakan untuk memulihkan file di
indeks dari commit lain.

git-reset(1) adalah tentang memperbarui cabang Anda, memindahkan ujung
untuk menambahkan atau menghapus commit dari cabang. Operasi ini
mengubah sejarah commit.

git reset juga dapat digunakan untuk memulihkan indeks, tumpang tindih dengan
git restore.
Perintah tingkat rendah (plumbing)

Meskipun Git mencakup lapisan
sendiri, perintah tingkat rendah cukup untuk mendukung
pengembangan porcelains alternatif. Pengembang porcelains
mungkin mulai dengan membaca tentang git-update-index(1) dan
git-read-tree(1).

Antarmuka (input, output, set opsi dan semantik)
untuk perintah tingkat rendah dimaksudkan untuk menjadi banyak lebih stabil
daripada perintah tingkat Porcelain, karena perintah ini
utama untuk penggunaan skrip.
