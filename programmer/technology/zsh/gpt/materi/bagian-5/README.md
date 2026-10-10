# Lesson 04 — Associative Arrays

## 1. Mengapa associative array diperlukan?

Array biasa menggunakan indeks numerik:

Zsh

```bash
tools=(git fzf neovim)

print -r -- "${tools[1]}"
```

Output:

```bash
git
```

Anda harus mengetahui indeks untuk mengambil elemen. Namun, jika data memiliki nama atau kategori, kunci teks bisa lebih mudah dipahami.

Misalnya, kita ingin menyimpan informasi tentang beberapa program:

```bash
editor  → neovim
search  → fzf
files   → yazi
```

Associative array memungkinkan kita mengambil nilai menggunakan kunci seperti `editor`, bukan angka `1`.

## 2. Membuat associative array

Dalam Zsh, gunakan `typeset -A` untuk mendeklarasikan associative array.

```bash
typeset -A tools

tools=(
    editor neovim
    search fzf
    files  yazi
)
```

Penjelasan:

* `typeset` adalah builtin Zsh untuk mendeklarasikan atau mengatur atribut parameter.

* `-A` menetapkan parameter sebagai associative array.

* `tools` adalah nama array.

* Setiap kunci dipasangkan dengan sebuah nilai.

Susunan tersebut merupakan pasangan kunci–nilai (key–value pairs).

## 3. Mengakses nilai berdasarkan kunci

Gunakan kunci di dalam subscript:

```bash
print -r -- "${tools[editor]}"
print -r -- "${tools[search]}"
print -r -- "${tools[files]}"
```

Output:

```
neovim
fzf
yazi
```

Perhatikan perbedaan berikut:

```bash
# Array numerik
print -r -- "${tools[1]}"

# Associative array
print -r -- "${tools[editor]}"
```

Pada array numerik, `1` berarti indeks pertama. Pada associative array, `editor` adalah kunci yang dicari.

Jangan menggunakan nama array yang sama untuk kedua contoh sekaligus dalam satu shell karena keduanya memiliki jenis deklarasi berbeda. Contoh di atas hanya untuk membandingkan sintaksnya.

## 4. Menambah dan memperbarui nilai

Anda bisa menambahkan pasangan kunci–nilai setelah deklarasi:

Zsh

```
typeset -A tools

tools=(
    editor neovim
    search fzf
)

tools[files]=yazi
tools[terminal]=foot
```

Jika kunci sudah ada, pemberian nilai baru akan memperbarui nilai tersebut:

Zsh

```
tools[editor]=helix

print -r -- "${tools[editor]}"
```

Output:

```
helix
```

Jadi, penugasan pada kunci yang sudah ada tidak membuat kunci baru; nilai yang tersimpan pada kunci tersebut diganti.

## 5. Mengambil semua kunci dan semua nilai

Untuk mengambil semua kunci, gunakan ekspansi `(k)`:

Zsh

```
print -r -- "${(k)tools}"
```

Untuk mengambil semua nilai, gunakan ekspansi `(v)`:

Zsh

```
print -r -- "${(v)tools}"
```

Di sini `(k)` berarti keys, sedangkan `(v)` berarti values.

Urutan keluaran associative array tidak boleh diasumsikan sebagai urutan deklarasi. Jika program memerlukan urutan tertentu, urutkan kuncinya secara eksplisit atau simpan urutan tersebut di array numerik terpisah.

## 6. Memeriksa apakah suatu kunci tersedia

Gunakan operator pemeriksaan parameter `${+...}`:

Zsh

```
if (( ${+tools[editor]} )); then
    print -r -- "Kunci editor tersedia"
else
    print -r -- "Kunci editor tidak tersedia"
fi
```

`1` berarti parameter atau elemen dengan kunci tersebut tersedia; `0` berarti tidak tersedia.

Pemeriksaan ini berbeda dari sekadar mengecek apakah nilainya tidak kosong. Sebuah kunci bisa tersedia meskipun nilainya berupa string kosong.

## 7. Menghapus satu kunci

Gunakan `unset` dengan ekspresi kunci yang dikutip:

Zsh

```
unset 'tools[search]'
```

Setelah itu, kunci `search` tidak lagi menjadi bagian dari associative array.

Mengutip ekspresi tersebut membantu memastikan sintaks subscript diteruskan secara utuh ke `unset`.

---

<details>
  <summary>
    <strong>📝 Latihan 04</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Kumpulan Jawaban</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

---

Tuliskan prediksi output atau jelaskan perilaku setiap potongan kode berikut.

Soal 1 — Mengakses nilai

Zsh

```
typeset -A apps
apps=(editor neovim terminal foot)
print -r -- "${apps[terminal]}"
```

Soal 2 — Memperbarui nilai

Zsh

```
typeset -A apps
apps=(editor neovim)
apps[editor]=helix
print -r -- "${apps[editor]}"
```

Soal 3 — Memeriksa kunci

Zsh

```
typeset -A apps
apps=(editor neovim)
if (( ${+apps[terminal]} )); then
    print -r -- "ada"
else
    print -r -- "tidak ada"
fi
```

  </div>
</details>

Setelah associative arrays, kita akan menuntaskan operasi dan pemrosesan data array yang diperlukan, sebelum berpindah ke Lesson 05 — Glob / Filename Generation.

## 04.10 — Iterasi array

Iterasi berarti mengunjungi setiap elemen array secara berurutan, biasanya menggunakan `for`.

Zsh

```
tools=(git fzf neovim yazi)

for tool in "${tools[@]}"; do
    print -r -- "$tool"
done
```

Output:

```
git
fzf
neovim
yazi
```

Mekanismenya:

1. `"${tools[@]}"` menghasilkan elemen array sebagai kata-kata terpisah.

2. `for tool in ...` mengambil setiap elemen secara bergantian.

3. Variabel `tool` berisi elemen yang sedang diproses.

4. `print -r -- "$tool"` mencetak nilainya tanpa interpretasi tambahan terhadap backslash.

Mengapa ekspansi array dikutip? Karena sebuah elemen bisa mengandung spasi.

Zsh

```
tools=("GNU Stow" git neovim)

for tool in "${tools[@]}"; do
    print -r -- "$tool"
done
```

Output tetap terdiri dari tiga elemen, bukan empat kata terpisah.

## 04.11 — Memproses associative array

Associative array juga dapat diproses menggunakan `for`, tetapi kita perlu memilih apakah akan mengiterasi kunci atau nilai.

Zsh

```
typeset -A apps

apps=(
    editor neovim
    search fzf
    files  yazi
)

for key in "${(k)apps}"; do
    print -r -- "$key"
done
```

`(k)` meminta kunci-kunci associative array.

Jika kita ingin mengambil nilai berdasarkan setiap kunci:

Zsh

```
for key in "${(k)apps}"; do
    print -r -- "$key: ${apps[$key]}"
done
```

Contoh hasil:

```
editor: neovim
search: fzf
files: yazi
```

Urutan kunci tidak dijamin. Jika urutan tertentu penting, jangan bergantung pada urutan iterasi associative array.

## 04.12 — Membuat array dari hasil perintah

Anda mungkin ingin menyimpan hasil suatu perintah ke dalam array. Di Zsh, ada perbedaan penting antara command substitution biasa dan menangkap baris keluaran sebagai elemen array.

Misalnya:

Zsh

```
output=$(print -r -- $'git\nfzf\nyazi')
```

`output` adalah parameter scalar yang menyimpan teks, termasuk baris baru.

Untuk memecah teks berdasarkan baris menjadi elemen array, gunakan flag ekspansi `(f)`:

Zsh

```
output=$(print -r -- $'git\nfzf\nyazi')
items=("${(@f)output}")

print -r -- "${items[1]}"
print -r -- "${items[2]}"
print -r -- "${items[3]}"
```

Output:

```
git
fzf
yazi
```

Penjelasan dua flag:

* `(f)` memecah teks berdasarkan karakter baris baru.

* `(@)` mempertahankan hasil ekspansi array sebagai elemen-elemen terpisah ketika ekspansi dikutip.

Teknik ini berguna untuk mengolah keluaran perintah yang memang menghasilkan satu item per baris. Namun, jangan menggunakannya untuk keluaran arbitrer yang mungkin mengandung baris baru di dalam nama atau data sebuah item.

## 04.13 — Ringkasan konsep array

| Kebutuhan                         | Sintaks                    |
| --------------------------------- | -------------------------- |
| Membuat array numerik             | `items=(alpha beta gamma)` |
| Mengakses elemen                  | `${items[1]}`              |
| Mengambil rentang indeks          | `${items[2,3]}`            |
| Mengakses dari belakang           | `${items[-1]}`             |
| Menghitung jumlah elemen          | `${#items}`                |
| Mengambil seluruh elemen          | `"${items[@]}"`            |
| Menambah elemen                   | `items+=(delta)`           |
| Mengubah elemen                   | `items[2]=new_value`       |
| Menghapus elemen                  | `unset 'items[2]'`         |
| Mendeklarasikan associative array | `typeset -A data`          |
| Mengambil kunci associative array | `${(k)data}`               |
| Mengambil nilai associative array | `${(v)data}`               |
| Memeriksa keberadaan kunci        | `${+data[key]}`            |

Perlu dibedakan bahwa `${items[2,3]}` adalah bentuk subscript Zsh untuk mengambil rentang indeks, sedangkan ekspansi seperti `${items[@]:offset:length}` memiliki aturan tersendiri. Untuk sekarang, prioritaskan bentuk subscript Zsh yang sudah dipelajari.

---

<details>
  <summary>📃 Latihan penutup Lesson 04</summary>

Buat sebuah script Zsh yang melakukan hal-hal berikut. Tujuannya adalah menggabungkan konsep, bukan sekadar menghafal sintaks:

- 1. Menyimpan `git`, `fzf`, dan `yazi` dalam array numerik bernama `tools`.

- 2. Menambahkan `neovim` ke array tersebut.

- 3. Mencetak jumlah elemennya.

- 4. Mengiterasi seluruh elemen dan mencetak setiap nama program.

- 5. Membuat associative array bernama `commands` yang memetakan `editor` ke `neovim` dan `files` ke `yazi`.

- 6. Mencetak nilai yang terkait dengan kunci `editor`.

---

</details>

Setelah array numerik, slicing, associative array, dan iterasi dasar ini, kita siap berpindah ke Lesson 05 — Glob / Filename Generation, yaitu mekanisme khas Zsh untuk mencocokkan nama file dan direktori.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

<!----------------------------------------------------->

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./

