`pandoc` adalah alat konversi dokumen yang sangat serbaguna. Berikut adalah cara penggunaan dasar dari beberapa fitur utamanya:

### Cara Dasar Menggunakan Pandoc:

1. **Mengkonversi file dari satu format ke format lain**:

   ```bash
   pandoc input.md -o output.pdf
   ```

   Perintah ini akan mengkonversi file `input.md` (Markdown) ke file PDF (`output.pdf`).

2. **Mengatur Format Input dan Output**:

   ```bash
   pandoc -f markdown -t html input.md -o output.html
   ```

   Di sini, `-f markdown` mengatur format input sebagai Markdown dan `-t html` mengatur format output sebagai HTML.

3. **Menambahkan Metadata**:

   ```bash
   pandoc -M title="Judul Dokumen" input.md -o output.html
   ```

   Menambahkan metadata, seperti judul, ke dalam dokumen.

4. **Menggunakan Template**:

   ```bash
   pandoc --template=mytemplate.tex input.md -o output.pdf
   ```

   Menggunakan template LaTeX khusus (`mytemplate.tex`) untuk mengkonversi file Markdown ke PDF.

5. **Menyertakan CSS untuk HTML**:

   ```bash
   pandoc -c styles.css input.md -o output.html
   ```

   Menyertakan file CSS (`styles.css`) untuk mengatur gaya dari dokumen HTML output.

6. **Menambahkan Daftar Isi**:

   ```bash
   pandoc --toc input.md -o output.html
   ```

   Menambahkan daftar isi (`--toc`) ke dalam dokumen output.

7. **Mengkonversi ke PDF dengan mesin PDF khusus**:
   ```bash
   pandoc input.md --pdf-engine=xelatex -o output.pdf
   ```
   Menggunakan mesin pdf seperti `xelatex` untuk konversi ke PDF.

Jika ada opsi atau fitur lain yang ingin Anda jelaskan lebih dalam, beri tahu saya!
