# **Word Splitting** 

---

## **1. Definisi**

**Word splitting** adalah proses di mana shell (Bash, Zsh, dsb.) **memecah string menjadi kata-kata terpisah** berdasarkan nilai variabel `IFS` (*Internal Field Separator*) setelah **parameter expansion**, **command substitution**, dan **arithmetic expansion** selesai.

⚠ **Penting:** Word splitting terjadi **hanya jika hasil ekspansi tidak di-*quote*.**

---

## **2. Mekanisme Dasar**

* **IFS default** = spasi, tab, newline (`' \t\n'`).
* Shell akan memotong string di setiap karakter pemisah yang ada di IFS.
* Kutipan (`" "`) mencegah word splitting.

---

## **3. Contoh**

```bash
# Default IFS: spasi, tab, newline
var="a b   c"
echo $var     # a b c   (split menjadi tiga argumen: a, b, c)
echo "$var"   # a b   c (satu argumen utuh)

# Mengubah IFS
IFS=:
data="user:pass:123"
echo $data    # user pass 123
```

---

## **4. Urutan Terjadinya di Shell**

Bash melakukan ini setelah:

1. **Brace expansion** `{}`
2. **Tilde expansion** `~`
3. **Parameter/variable expansion** `$var`
4. **Command substitution** `` `cmd` `` atau `$(cmd)`
5. **Arithmetic expansion** `$((...))`
6. **Word splitting** (jika tidak di-quote)
7. **Pathname expansion (globbing)**

---

## **5. Bahaya Umum**

* **Breaking arguments:**

  ```bash
  files=$(ls)  # <-- Hasil ls bisa ter-split di spasi
  ```

  Solusi:

  ```bash
  IFS= read -r line
  mapfile -t files < <(ls)  # Bash array aman
  ```

* **Injection risk:** Data dari variable bisa memecah argumen program jika tidak di-quote.

---

## **6. Best Practice**

* Selalu quote variable kecuali memang mau split:

  ```bash
  "$var"
  ```
* Gunakan array untuk daftar data, bukan string tunggal.
* Modifikasi `IFS` hanya sementara:

  ```bash
  oldIFS=$IFS
  IFS=:
  # proses
  IFS=$oldIFS
  ```
---

#### Berikut flowchart urutan ekspansi shell yang menunjukkan di mana tepatnya word splitting terjadi

```
+----------------------+
|  1. Brace Expansion  |   {a,b} → a b
+----------+-----------+
           |
           v
+----------------------+
|  2. Tilde Expansion  |   ~ → /home/user
+----------+-----------+
           |
           v
+------------------------------+
|  3. Parameter Expansion      |   $var → value
|     (Variable Substitution)  |
+----------+-------------------+
           |
           v
+------------------------------+
|  4. Command Substitution     |   $(cmd) → output cmd
+----------+-------------------+
           |
           v
+------------------------------+
|  5. Arithmetic Expansion     |   $((1+2)) → 3
+----------+-------------------+
           |
           v
+==============================+
||  6. WORD SPLITTING          ||   berdasarkan IFS (default: space, tab, newline)
+==============================+
           |
           v
+------------------------------+
|  7. Pathname Expansion       |   *.txt → file1.txt file2.txt
|     (Globbing)               |
+----------+-------------------+
           |
           v
+----------------------+
|  Final Arguments     |
|  dikirim ke program  |
+----------------------+
```

💡 **Tips cepat ingat:** *"Brace, Tilde, Param, Cmd, Math → Split → Glob → Run"*
 
**Versi ANSI Color**
(Salin ke file `.sh` lalu jalankan dengan `cat` atau `echo -e` biar warnanya muncul.)

```bash
#!/usr/bin/env bash

# ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

echo -e "
${GREEN}+----------------------+
|  1. Brace Expansion  |   {a,b} → a b
+----------+-----------+
           |
           v
+----------------------+
|  2. Tilde Expansion  |   ~ → /home/user
+----------+-----------+
           |
           v
+------------------------------+
|  3. Parameter Expansion      |   \$var → value
|     (Variable Substitution)  |
+----------+-------------------+
           |
           v
+------------------------------+
|  4. Command Substitution     |   \$(cmd) → output cmd
+----------+-------------------+
           |
           v
+------------------------------+
|  5. Arithmetic Expansion     |   \$((1+2)) → 3
+----------+-------------------+
           |
           v
${RED}+==============================+
||  6. WORD SPLITTING          ||   berdasarkan IFS (default: space, tab, newline)
+==============================+
${NC}           |
           v
${CYAN}+------------------------------+
|  7. Pathname Expansion       |   *.txt → file1.txt file2.txt
|     (Globbing)               |
+----------+-------------------+
           |
           v
+----------------------+
|  Final Arguments     |
|  dikirim ke program  |
+----------------------+${NC}
"

```

Kalau dijalankan, step **WORD SPLITTING** akan merah, step awal hijau, globbing biru, biar langsung **terbaca urutannya**. Berikut versi **animasi ANSI** di terminal yang akan menampilkan urutan ekspansi shell **step-by-step** dengan delay, biar terasa “eksekusi real-time”-nya.

```bash
#!/usr/bin/env bash

# ANSI colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Fungsi untuk pause antar langkah
step() {
    echo -e "$1"
    sleep 0.8
}

clear

step "${GREEN}+----------------------+
|  1. Brace Expansion  |   {a,b} → a b
+----------------------+${NC}"

step "           |
           v"

step "${GREEN}+----------------------+
|  2. Tilde Expansion  |   ~ → /home/user
+----------------------+${NC}"

step "           |
           v"

step "${GREEN}+------------------------------+
|  3. Parameter Expansion      |   \$var → value
|     (Variable Substitution)  |
+------------------------------+${NC}"

step "           |
           v"

step "${GREEN}+------------------------------+
|  4. Command Substitution     |   \$(cmd) → output cmd
+------------------------------+${NC}"

step "           |
           v"

step "${GREEN}+------------------------------+
|  5. Arithmetic Expansion     |   \$((1+2)) → 3
+------------------------------+${NC}"

step "           |
           v"

step "${RED}+==============================+
||  6. WORD SPLITTING          ||   berdasarkan IFS (default: space, tab, newline)
+==============================+${NC}"

step "           |
           v"

step "${CYAN}+------------------------------+
|  7. Pathname Expansion       |   *.txt → file1.txt file2.txt
|     (Globbing)               |
+------------------------------+${NC}"

step "           |
           v"

step "+----------------------+
|  Final Arguments     |
|  dikirim ke program  |
+----------------------+"

```

📌 Cara pakai:

1. Simpan sebagai `shell_expansion_demo.sh`
2. `chmod +x shell_expansion_demo.sh`
3. Jalankan: `./shell_expansion_demo.sh`

Hasilnya nanti flowchart akan **muncul satu per satu** setiap 0.8 detik, dan bagian **WORD SPLITTING** bakal nyala merah.

#### **Versi Interaktif**

Ketik sebuah perintah, lalu skrip akan **mensimulasikan setiap tahap ekspansi shell** dengan hasil nyata dari input yang kamu masukkan.

```bash
#!/usr/bin/env bash

# Warna ANSI
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

# Prompt input
read -p "Masukkan perintah shell: " CMD
ORIGINAL="$CMD"

clear
echo -e "📜 ${GREEN}Simulasi Shell Expansion Step-by-Step${NC}"
echo -e "Perintah asli: \"$CMD\"\n"
sleep 1

# 1. Brace Expansion
STEP1=$(eval echo "$CMD" | sed 's/ /§/g')
BRACE=$(eval echo $CMD)
echo -e "${GREEN}[1] Brace Expansion${NC}: $BRACE"
sleep 1

# 2. Tilde Expansion
TILDE=$(eval echo "$BRACE")
echo -e "${GREEN}[2] Tilde Expansion${NC}: $TILDE"
sleep 1

# 3. Parameter Expansion
PARAM=$(eval echo "$TILDE")
echo -e "${GREEN}[3] Parameter Expansion${NC}: $PARAM"
sleep 1

# 4. Command Substitution
CMD_SUB=$(eval echo "$PARAM")
echo -e "${GREEN}[4] Command Substitution${NC}: $CMD_SUB"
sleep 1

# 5. Arithmetic Expansion
ARITH=$(eval echo "$CMD_SUB")
echo -e "${GREEN}[5] Arithmetic Expansion${NC}: $ARITH"
sleep 1

# 6. Word Splitting
IFS_SAVE="$IFS"
IFS=" "
SPLIT=($ARITH)
IFS="$IFS_SAVE"
echo -e "${RED}[6] Word Splitting${NC}: ${SPLIT[*]}"
sleep 1

# 7. Pathname Expansion (Globbing)
GLOB=$(eval echo ${SPLIT[@]})
echo -e "${CYAN}[7] Pathname Expansion${NC}: $GLOB"
sleep 1

# Final
echo -e "\n✅ ${GREEN}Final Arguments${NC}:"
printf '%s\n' "${SPLIT[@]}"
```

---

### 📌 Cara Pakai

1. Simpan file → `shell_expansion_interactive.sh`
2. Jadikan executable:

   ```bash
   chmod +x shell_expansion_interactive.sh
   ```
3. Jalankan:

   ```bash
   ./shell_expansion_interactive.sh
   ```
4. Ketik contoh:

   ```
   echo ~/{a,b}/*.txt
   ```
5. Script akan memproses **brace → tilde → parameter → command → arithmetic → word splitting → globbing** sambil menampilkan hasil di tiap tahap.

---

# **Versi full animasi**

1. Menerima input perintah dari user
2. Menjalankan simulasi **step-by-step shell expansion**
3. Menampilkan **hasil nyata di tiap tahap**
4. Memberikan **keterangan di setiap langkah dalam kode** (supaya bisa dipelajari)

---

```bash
#!/usr/bin/env bash
#
# Shell Expansion Debugger - Versi Interaktif & Animasi
# Menunjukkan proses ekspansi di Bash: brace, tilde, parameter, command, arithmetic, word splitting, globbing.
#

# -----------------------------
# WARNA ANSI untuk memperjelas output
# -----------------------------
RED='\033[1;31m'     # Merah → highlight untuk Word Splitting
GREEN='\033[1;32m'   # Hijau → tahap normal
CYAN='\033[1;36m'    # Biru → highlight untuk globbing
NC='\033[0m'         # Reset warna (No Color)

# -----------------------------
# FUNGSI untuk animasi step-by-step
# -----------------------------
step() {
    echo -e "$1"    # Cetak teks dengan warna
    sleep 1         # Delay 1 detik agar terasa prosesnya
}

# -----------------------------
# Minta input user
# -----------------------------
read -p "Masukkan perintah shell: " CMD
ORIGINAL="$CMD"

clear
echo -e "📜 ${GREEN}Simulasi Shell Expansion Step-by-Step${NC}"
echo -e "Perintah asli: \"$CMD\"\n"
sleep 1

# -----------------------------
# 1. Brace Expansion
# {a,b} → a b
# -----------------------------
BRACE=$(eval echo $CMD)
step "${GREEN}[1] Brace Expansion${NC}: $BRACE"

# -----------------------------
# 2. Tilde Expansion
# ~ → /home/user
# -----------------------------
TILDE=$(eval echo "$BRACE")
step "${GREEN}[2] Tilde Expansion${NC}: $TILDE"

# -----------------------------
# 3. Parameter Expansion
# $VAR → nilai variabel
# -----------------------------
PARAM=$(eval echo "$TILDE")
step "${GREEN}[3] Parameter Expansion${NC}: $PARAM"

# -----------------------------
# 4. Command Substitution
# $(cmd) → output dari cmd
# -----------------------------
CMD_SUB=$(eval echo "$PARAM")
step "${GREEN}[4] Command Substitution${NC}: $CMD_SUB"

# -----------------------------
# 5. Arithmetic Expansion
# $((1+2)) → 3
# -----------------------------
ARITH=$(eval echo "$CMD_SUB")
step "${GREEN}[5] Arithmetic Expansion${NC}: $ARITH"

# -----------------------------
# 6. Word Splitting
# Memecah string menjadi kata berdasarkan IFS (default: spasi, tab, newline)
# -----------------------------
IFS_SAVE="$IFS"   # Simpan nilai IFS asli
IFS=" "           # Set IFS ke spasi
SPLIT=($ARITH)    # Pecah string menjadi array
IFS="$IFS_SAVE"   # Kembalikan IFS
step "${RED}[6] Word Splitting${NC}: ${SPLIT[*]}"

# -----------------------------
# 7. Pathname Expansion (Globbing)
# *.txt → file1.txt file2.txt
# -----------------------------
GLOB=$(eval echo ${SPLIT[@]})
step "${CYAN}[7] Pathname Expansion${NC}: $GLOB"

# -----------------------------
# Final Arguments
# Inilah argumen akhir yang dikirim ke program
# -----------------------------
echo -e "\n✅ ${GREEN}Final Arguments${NC}:"
printf '%s\n' "${SPLIT[@]}"

```

---

## 📌 Keterangan Kode

1. **ANSI Color** → untuk memberi warna pada setiap tahap supaya gampang dibedakan
2. **step()** → fungsi kecil untuk print + delay
3. **eval echo** → memaksa Bash untuk melakukan ekspansi tahap demi tahap
4. **IFS** → mengatur Internal Field Separator agar bisa melihat efek *word splitting*
5. **Array SPLIT** → hasil *word splitting* disimpan ke array agar terlihat jelas
6. **Globbing** → ditampilkan dengan hasil ekspansi `*.txt` atau pola lainnya

---

## 📌 Cara Pakai

```bash
chmod +x shell_expansion_debugger.sh
./shell_expansion_debugger.sh
```

Contoh input:

```
echo ~/{a,b}/*.txt
```

Output akan memunculkan **7 tahap ekspansi** dengan animasi.

---
