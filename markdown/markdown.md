# Heading 1 \_\_\_

## Heading 2 \_\_\_

### Heading 3 \_\_\_

#### Heading 4 \_\_\_

##### Heading 5 \_\_\_

###### Heading 6 \_\_\_

---

## Horizontal Rules

### List

#### Order

1. Dart
2. Flutter
3. SDK

#

#### Unorder

- Variable
- Data Type
- Operator

#

#### Nested

1. Function( )
2. Map[ ]

#

- Super
- Key
  - parent
  - class
  - exstand

#

- Constructor
- inheritance

#

- [x] ceks box
- - ceks box
- - ceks box
- - [x] ceks box

# Text Style

_italic_

**bold**

~~Coret~~

```dart
void main() => 'Oke Google';
```

_**Italic Bold**_
**_Italic Bold_**

#

# BlockQuote

> blockquote 1
>
> > blockquote 2
> >
> > > bloclquote 3
> > >
> > > > bloclquote 4
> > > >
> > > > > bloclquote 5
> > > > >
> > > > > > bloclquote 6
>
> - kayak diagram atau index ya 😀

#

```Java Script
tempat penulisan kode juga bisa disini
void main(){

}
```

```Python
tempat penulisan kode juga bisa disini
print();
```

# Inline Code

membuat baris yang dibungkus `seperti ini`

# link

https://www.youtube.com

[You Tube](https://www.youtube.com "ke yutup")

[google][1]

[facebook][2]

[1]: https://google.com
[2]: https://facebook.com

## Link Over

[google][1]

[facebook][2]

[1]: https://google.com
[2]: https://facebook.com

# Amirkulal

![gambar](https://avatars.githubusercontent.com/u/70124885?v=4)

| No. | Nama    | Deskripsi |
| --- | ------- | --------- |
| 1.  | Dart    | languange |
| 2.  | Flutter | Framework |

> <span style="color: cyan;">I'm develops from mobile apps</span>

---

## <span style="border-bottom: 1px solid orange;">Garis bawah</span>

<span style="color: red; border-bottom: 2px wavy red;">Kode error</span>

[$Error Code$](E:\coding\dart\saya.html)

<blockquote class="imgur-embed-pub" lang="en" data-id="q4q70hU"><a href="https://imgur.com/q4q70hU">View post on imgur.com</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

# $flutter$

<!--
Untuk menghubungkan baris `# Lua[1:]` dengan file `README.md` menggunakan format _Markdown link reference_, kamu perlu memastikan bahwa referensi `[1]: ...` di bagian bawah Markdown sesuai dengan tag `[1]` yang dipakai di bagian atas.

Namun, jika kamu ingin agar tulisan `# Lua[1:]` menjadi **tautan yang bisa diklik**, maka kamu perlu mengubah penulisannya menjadi seperti ini:

```markdown
# [Lua](public/programmer/embedded/lua/pembelajaran-praktis/dasar/README.md)
```

Penjelasan:

- `# [Lua](...)` artinya `Lua` adalah judul (`#` = heading 1) sekaligus hyperlink.
- Path seperti `public/programmer/...` digunakan dalam bentuk **relatif**, jadi pastikan file Markdown yang berisi tautan ini berada di tempat yang sesuai agar link tersebut benar-benar bisa ditemukan oleh Markdown renderer seperti GitHub atau VS Code.

Kalau kamu memang sengaja menggunakan `[1:]` seperti:

```markdown
# Lua[1:]

[1]: (public\programmer\embedded\lua\pembelajaran-praktis\dasar\README.md)
```

Itu **tidak valid secara Markdown**. Format referensi Markdown yang sah adalah seperti ini:

```markdown
[Lua]: public/programmer/embedded/lua/pembelajaran-praktis/dasar/README.md

# [Lua][Lua]
```

Atau bisa disingkat:

```markdown
# [Lua][1]

[1]: public/programmer/embedded/lua/pembelajaran-praktis/dasar/README.md
```

### Tips:

- Gunakan `/` bukan `\` untuk path di Markdown agar lintas platform dan valid secara URL.
- Gunakan tautan relatif jika file tersebut masih dalam repositori lokal atau GitHub repo yang sama. -->

Kalau kamu ingin **menampilkan karakter backtick (`` ` ``)** di dalam Markdown, **tapi tetap menggunakan Markdown code block atau inline code**, kamu harus **"melarikan" (escape) atau mengapit dengan tanda backtick lebih banyak dari yang kamu gunakan di dalamnya.**

---

### ✅ Kasus 1: Ingin menampilkan satu backtick di inline code

Misalnya kamu ingin menampilkan:

> tampilan seperti \`ini\`

Gunakan tiga backtick:

```markdown
`` ` ``
```

Hasilnya: `` ` ``

---

### ✅ Kasus 2: Ingin menampilkan tiga backtick dalam blok kode

Markdown biasa tidak bisa pakai tiga backtick di dalam tiga backtick. Solusinya:

- Gunakan **empat backtick sebagai pembuka dan penutup**:

````markdown
```markdown

```
````

kode diapit tiga backtick

```

```

```

Hasilnya:

```

kode diapit tiga backtick

```

---

### ✅ Tambahan: Menampilkan kombinasi karakter aneh lainnya

Jika kamu ingin menampilkan teks Markdown seperti:

```

# Judul [teks](link)

````

Kamu cukup bungkus dengan tiga backtick biasa:

    ```markdown
    # Judul [teks](link)
    ```

Markdown **tidak akan merender isi di dalam blok kode** sebagai format. Semua dianggap teks mentah.

---

Kalau kamu sebutkan situasi spesifiknya (di dalam dokumen, dalam kode Lua, atau di dalam komentar), aku bisa bantu lebih presisi. Markdown bisa tricky kadang, tapi gampang kalau udah ngerti polanya 💪
````

# Daftar Isi

- [Pengantar Lua](#pengantar-bahasa-lua)
- [Struktur Dasar](#struktur-dasar)

## Pengantar Bahasa Lua

Penjelasan tentang Lua...

## Struktur Dasar

Bagian ini membahas struktur kode...
