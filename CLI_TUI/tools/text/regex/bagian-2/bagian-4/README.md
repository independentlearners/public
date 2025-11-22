# **Curly-brace quantifier**

Di bawah ini daftar lengkap yang berguna, contoh, penjelasan token-per-token, variasi greedy/lazy/possessive, serta catatan kompatibilitas antar-flavor (PCRE / JS / Python / .NET). Semua contoh mengikuti konvensi: quantifier selalu mengikuti *atom* (karakter, kelas, grup).

---

# Ringkasan cepat — bentuk yang umum

* `{n}` → tepat **n** pengulangan.
  Contoh: `a{3}` cocok dengan `aaa` (tapi tidak `aa` atau `aaaa`).
* `{n,}` → **minimal n**, maksimal tak terbatas (∞).
  Contoh: `a{2,}` cocok `aa`, `aaa`, `aaaa`, ...
* `{n,m}` → **minimal n, maksimal m** (n ≤ m).
  Contoh: `a{1,3}` cocok `a`, `aa`, `aaa` (tapi tidak `aaaa`).
* `{,m}` → beberapa engine **mengizinkan** (artinya 0 sampai m), tetapi **tidak semua flavor menjamin** dukungan; untuk portabilitas gunakan eksplisit `{0,m}`. (Catatan: dokumentasi Python menyebutkan Anda bisa menghilangkan m atau n; tetapi beberapa dokumentasi engine lain tidak menampilkan bentuk ini secara eksplisit — jadi hati-hati). ([Python documentation][1])

---

# Penjelasan detail

Ambil pola contoh `X{n,m}` — dimana `X` adalah atom sebelumnya (mis. `a`, `\d`, `[A-Z]`, atau grup `(ab)`).

* `X`
  → atom yang akan diulang (karakter, class, grup).
* `{` dan `}`
  → pembuka/penutup quantifier; wajib untuk menandakan bentuk jumlah eksplisit.
* `n` (desimal non-negatif)
  → jumlah minimal pengulangan (integer ≥ 0).
* `,`
  → pemisah antara batas bawah dan batas atas.
* `m` (desimal non-negatif)
  → jumlah maksimal pengulangan. Jika dikosongkan (`{n,}`) → berarti tidak ada batas atas (∞).
* Aturan penting: jika ditulis `{n,m}`, harus terpenuhi `n ≤ m` (beberapa engine akan membuat aturan khusus / error bila `n > m`). ([man7.org][2])

Contoh konkret dan penjelasan:

* `\d{4}`
  → `\d` = digit; `{4}` → tepat 4 digit; cocok: `2025` (tidak cocok: `123`, `12345`).
* `a{2,}`
  → `a` diulang minimal 2 kali; cocok: `aa`, `aaa`, ...
* `(ab){1,3}`
  → grup `ab` diulang 1 sampai 3 kali; cocok: `ab`, `abab`, `ababab`.

---

# Greedy vs Lazy vs Possessive

* Secara default quantifier bersifat **greedy**: mencoba mencocokkan sebanyak mungkin (mis. `a{1,}` akan melahap sebanyak mungkin `a`). Untuk membuatnya **lazy (non-greedy)** tambahkan `?` setelah quantifier: `{n,m}?` atau `*?`/`+?`. Contoh: `a{1,3}?` akan memilih jumlah sekecil mungkin yang masih memenuhi pola. ([developer.mozilla.org][3])
* **Possessive quantifier** (mis. `{n,m}+`, `*+`, `++`) — tersedia di beberapa engine (Java, PCRE, Perl, R, PHP, dsb.): quantifier ini tidak akan me-backtrack sama sekali, berguna untuk optimisasi/keamanan terhadap backtracking blow-up. Jika engine mendukung, sintaksnya menambahkan `+` setelah quantifier. ([rexegg.com][4])

---

# Perilaku dan edge-cases penting

1. **Tidak boleh berdiri sendiri**: `{n}` harus mengikuti sebuah atom; jika muncul di tempat tanpa atom, beberapa engine (PCRE2) menganggapnya *error*, sedangkan Perl terkadang memperlakukan `{` sebagai literal jika tidak valid konteksnya. ([man7.org][2])
2. **Batasan internal**: beberapa implementasi (mis. Perl versi lama) punya limit maksimal pengulangan internal (batas integer yang dapat berubah antar-versi); untuk pola ekstrem waspadai hal ini. ([effectiveperlprogramming.com][5])
3. **`n > m`**: perilaku berbeda antar engine — ada yang menganggap pola tidak pernah bisa cocok (selalu gagal), ada yang error saat kompilasi. Periksa dokumentasi engine yang Anda gunakan. ([man7.org][2])
4. **Portabilitas `{,m}`**: meskipun beberapa dokumentasi (mis. Python) mengizinkan menghilangkan `n` sehingga `{,m}` artinya `0..m`, banyak referensi dan cheat-sheet menunjukkan bentuk yang paling umum dan kompatibel adalah `{n}`, `{n,}`, `{n,m}`. Untuk kompatibilitas lintas-engine gunakan `{0,m}` jika maksudnya 0..m. ([Python documentation][1])

---

# Contoh tabel & hasil match cepat

| Regex     |                                              Artinya | Cocok (contoh)                                    |
| --------- | ---------------------------------------------------: | ------------------------------------------------- |
| `a{3}`    |                                          tepat 3 `a` | `aaa` ✅, `aa` ❌, `aaaa` (match substring `aaa`) ✅ |
| `b{2,4}`  |                                       2 sampai 4 `b` | `bb`, `bbb`, `bbbb` ✅, `b` ❌                      |
| `\d{1,}`  |              1 atau lebih digit (sama seperti `\d+`) | `1`, `12`, `1234` ✅                               |
| `x{0,3}`  | 0 sampai 3 `x` (setara `{,3}` bila engine mendukung) | ``, `x`, `xx`, `xxx` ✅                            |
| `(ab){2}` |                                  tepat dua kali `ab` | `abab` ✅, `ab` ❌                                  |

---

# Praktik & tips

* Untuk **portabilitas**: gunakan bentuk eksplisit `{n}`, `{n,}`, `{n,m}`; jika butuh 0..m, gunakan `{0,m}` daripada `{,m}`. (Lebih aman lintas JS / PCRE / Python / .NET). ([developer.mozilla.org][6])
* Gunakan `{n,}` bila Anda butuh "setidaknya n" (readable dibanding `n+` kombinasi).
* Ketika bekerja dengan input besar, pertimbangkan efek **backtracking** — quantifier luas pada pola yang ambiguitas dapat menyebabkan *catastrophic backtracking*. Solusi: restrukturisasi pola, gunakan possessive quantifier bila tersedia, atau gunakan atomic groups / anchors. ([rexegg.com][4])
* Bila butuh laziness (sering dalam parsing HTML-like): pakai `?` setelah quantifier — mis. `.{1,}?` atau `.*?`.

---

# Referensi singkat (bacaan lanjutan)

* MDN — Quantifier overview (JavaScript): tabel `{count}`, `{min,}`, `{min,max}` dan greedy/lazy. ([developer.mozilla.org][6])
* Python `re` HOWTO — menjelaskan `{m,n}` dan omisi m/n (interpreted as 0 or ∞). ([Python documentation][1])
* PCRE / PCRE2 syntax summary — referensi formal untuk behavior di engine PCRE (PHP, many tools). ([PCRE][7])
* REXEGG / tutorial quantifier — artikel mendalam tentang greedy vs lazy vs possessive dan optimisasi. ([rexegg.com][4])

---

[1]: https://docs.python.org/3/howto/regex.html?utm_source=chatgpt.com "Regular Expression HOWTO"
[2]: https://man7.org/linux/man-pages/man3/pcre2compat.3.html?utm_source=chatgpt.com "pcre2compat(3) - Linux manual page"
[3]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions/Quantifiers?utm_source=chatgpt.com "Quantifiers - JavaScript - MDN Web Docs - Mozilla"
[4]: https://www.rexegg.com/regex-quantifiers.php?utm_source=chatgpt.com "Regex Quantifier Tutorial: Greedy, Lazy, Possessive"
[5]: https://www.effectiveperlprogramming.com/2018/12/perl-v5-30-lets-you-match-more-with-the-general-quantifier/?utm_source=chatgpt.com "Perl v5.30 lets you match more with the general quantifier"
[6]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Regular_expressions/Quantifier?utm_source=chatgpt.com "Quantifier: *, +, ?, {n}, {n,}, {n,m} - JavaScript - MDN Web Docs"
[7]: https://www.pcre.org/current/doc/html/pcre2syntax.html?utm_source=chatgpt.com "pcre2syntax specification"

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
