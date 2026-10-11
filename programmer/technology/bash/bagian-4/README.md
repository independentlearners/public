# **Fase 4: Pakar – Aplikasi Skala Enterprise dan Keamanan (Tingkat Pakar)**

**Tujuan Fase:** Menerapkan keterampilan scripting dalam skenario dunia nyata yang kompleks, dengan fokus kuat pada keamanan, interoperabilitas, kinerja, pengujian, dan operasionalisasi di lingkungan enterprise.

> **Catatan Pembaca:** Dokumen ini adalah versi yang telah direvisi dan dilengkapi. Setiap modul kini memuat: tujuan pembelajaran terukur, prasyarat, konsep mendalam, contoh kode yang telah diverifikasi, latihan bertingkat, kuis, proyek mini, kesalahan umum, praktik terbaik, dan referensi mutakhir. Semua contoh kode diasumsikan dijalankan pada Bash 5.x (Linux) kecuali dinyatakan lain.

---

## **Daftar Isi Fase 4**

- [Modul 4.1: Otomatisasi Tugas Administrasi Sistem](#modul-41-otomatisasi-tugas-administrasi-sistem)
- [Modul 4.2: Pertimbangan Keamanan dalam Shell Scripting](#modul-42-pertimbangan-keamanan-dalam-shell-scripting)
- [Modul 4.3: Interoperabilitas dengan Alat dan Bahasa Lain](#modul-43-interoperabilitas-dengan-alat-dan-bahasa-lain)
- [Modul 4.4: Pengujian, Linting, dan CI/CD untuk Skrip Shell](#modul-44-pengujian-linting-dan-cicd-untuk-skrip-shell)
- [Modul 4.5: Portabilitas, Debugging, dan Kinerja](#modul-45-portabilitas-debugging-dan-kinerja)
- [Proyek Akhir Fase 4](#proyek-akhir-fase-4)

---

## **Modul 4.1: Otomatisasi Tugas Administrasi Sistem**

### **Tujuan Pembelajaran**

Setelah menyelesaikan modul ini, Anda mampu:

1. Menjelaskan filosofi otomatisasi dan nilai strategis shell scripting di lingkungan enterprise.
2. Menulis skrip backup yang **idempoten**, **aman terhadap konkurensi**, **terverifikasi**, dan **dapat dipulihkan**.
3. Menulis skrip monitoring yang mengukur beberapa metrik sistem dan mengirim notifikasi terstruktur.
4. Menjadwalkan skrip menggunakan `cron`, `systemd timers`, dan `anacron`.
5. Menerapkan prinsip idempotensi pada berbagai tugas administrasi.
6. Mengelola user, grup, dan log rotation secara otomatis.

### **Prasyarat**

- Menguasai `set -euo pipefail`, fungsi, `trap`, dan penanganan error (Fase 3).
- Memahami `grep`, `sed`, `awk`, `find`, dan *pipes* (Fase 1–3).
- Familiar dengan dasar sistem Linux: user, grup, permission, filesystem.

---

### **1. Filosofi Otomatisasi dan Nilai Shell Scripting**

#### **1.1. Mengapa Otomatisasi Penting di Skala Enterprise**

Di lingkungan enterprise, satu server bisa menjalankan puluhan layanan, dan satu organisasi bisa mengelola ribuan server. Tanpa otomatisasi:

- **Biaya operasional meledak** karena setiap tugas manual membutuhkan waktu engineer.
- **Kesalahan manusia meningkat** secara eksponensial seiring jumlah server.
- **Konsistensi hilang** — server A dikonfigurasi berbeda dari server B.
- **Audit dan compliance sulit** karena tidak ada jejak eksekusi yang dapat direproduksi.

Shell scripting adalah **lapisan otomatisasi paling dasar dan universal**. Ia tersedia di hampir semua sistem Unix/Linux, tidak memerlukan runtime tambahan, dan dapat mengorkestrasi alat apa pun yang dapat dipanggil dari baris perintah.

#### **1.2. Nilai Strategis Shell Scripting**

| Aspek | Nilai |
|---|---|
| **Efisiensi** | Menyelesaikan tugas berulang dalam hitungan detik, bukan jam. |
| **Konsistensi** | Eksekusi identik setiap kali, menghilangkan variasi manusia. |
| **Auditability** | Skrip dapat disimpan di Git, direview, dan diaudit. |
| **Portabilitas** | Berjalan di hampir semua distro Linux dan Unix. |
| **Komposabilitas** | Dapat memanggil alat lain (Python, `jq`, `curl`, database CLI). |
| **Biaya** | Tidak ada lisensi, tidak ada runtime berat. |

#### **1.3. Kapan TIDAK Menggunakan Shell Scripting**

Shell scripting bukan obat segala hal. Hindari ketika:

- **Komputasi numerik intensif** — gunakan Python/NumPy, C, atau Rust.
- **Manipulasi data kompleks bersarang** — gunakan Python dengan pandas.
- **Aplikasi dengan state dan konkurensi tinggi** — gunakan Go/Rust/Java.
- **GUI** — gunakan bahasa dengan toolkit GUI.
- **Logika bisnis besar (>500 baris)** — pertimbangkan Python/Go untuk maintainability.

Shell adalah **lem** (glue), bukan **mesin utama**.

---

### **2. Studi Kasus 1: Skrip Backup Otomatis Tingkat Enterprise**

#### **2.1. Kebutuhan Nyata di Enterprise**

Skrip backup enterprise harus memenuhi kriteria berikut:

1. **Idempoten** — dapat dijalankan berulang tanpa efek samping merusak.
2. **Aman terhadap konkurensi** — tidak boleh overlap jika jadwal sebelumnya belum selesai.
3. **Terverifikasi** — checksum dan integritas arsip diperiksa.
4. **Terenskripsi** — data sensitif dienkripsi sebelum dikirim ke storage.
5. **Dapat dipulihkan** — ada prosedur restore yang diuji.
6. **Incremental/differential** — untuk menghemat bandwidth dan storage.
7. **Offsite** — disalin ke lokasi geografis berbeda.
8. **Ter-log** — setiap langkah dicatat untuk audit.
9. **Gagal dengan aman** — error ditangani, resource dibersihkan.
10. **Least privilege** — berjalan dengan hak akses minimum.

#### **2.2. Implementasi Skrip Backup Lengkap**

```bash
#!/usr/bin/env bash
#
# backup_enterprise.sh — Skrip backup idempoten, aman konkurensi, terverifikasi.
#
# Penggunaan:
#   backup_enterprise.sh [-s SOURCE] [-d DEST] [-r RETENTION] [-e RECIPIENT]
#
# Contoh:
#   backup_enterprise.sh -s /var/www -d /mnt/backups -r 14
#
set -Eeuo pipefail
IFS=$'\n\t'

# ---------------------------------------------------------------------------
# Konstanta & Konfigurasi Default
# ---------------------------------------------------------------------------
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOCK_FILE="/var/lock/${SCRIPT_NAME}.lock"
readonly LOG_TAG="backup_enterprise"

BACKUP_SOURCE="${BACKUP_SOURCE:-/var/www/html}"
BACKUP_DEST="${BACKUP_DEST:-/mnt/backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
GPG_RECIPIENT="${GPG_RECIPIENT:-}"
REMOTE_TARGET="${REMOTE_TARGET:-}"
REMOTE_SSH_KEY="${REMOTE_SSH_KEY:-}"

# ---------------------------------------------------------------------------
# Warna (hanya jika TTY)
# ---------------------------------------------------------------------------
if [[ -t 2 ]]; then
  readonly C_RED=$'\033[0;31m'
  readonly C_YEL=$'\033[0;33m'
  readonly C_GRN=$'\033[0;32m'
  readonly C_RST=$'\033[0m'
else
  readonly C_RED="" C_YEL="" C_GRN="" C_RST=""
fi

# ---------------------------------------------------------------------------
# Logging Terstruktur (systemd-journald jika tersedia, else stderr)
# ---------------------------------------------------------------------------
log() {
  local level="$1"; shift
  local msg="$*"
  local ts; ts="$(date '+%Y-%m-%dT%H:%M:%S%z')"
  if command -v logger >/dev/null 2>&1; then
    logger -t "$LOG_TAG" -p "user.${level,,}" -- "$msg"
  fi
  printf '%s [%s] %s\n' "$ts" "$level" "$msg" >&2
}

die() { log ERROR "$*"; exit 1; }
info() { log INFO "$*"; }
warn() { log WARNING "$*"; }

# ---------------------------------------------------------------------------
# Trap untuk error & pembersihan
# ---------------------------------------------------------------------------
TEMP_FILES=()

cleanup() {
  local exit_code=$?
  if (( ${#TEMP_FILES[@]} > 0 )); then
    for f in "${TEMP_FILES[@]}"; do
      [[ -e "$f" ]] && rm -rf -- "$f"
    done
  fi
  if (( exit_code != 0 )); then
    warn "Skrip keluar dengan kode $exit_code. Membersihkan resource..."
  fi
  exit "$exit_code"
}
trap cleanup EXIT INT TERM

on_error() {
  local exit_code=$?
  local line_no="$1"
  local cmd="$2"
  log ERROR "Gagal di baris $line_no: '$cmd' (exit=$exit_code)"
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

# ---------------------------------------------------------------------------
# Parsing argumen
# ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Penggunaan: $SCRIPT_NAME [OPSI]

Opsi:
  -s SOURCE      Direktori sumber (default: $BACKUP_SOURCE)
  -d DEST        Direktori tujuan (default: $BACKUP_DEST)
  -r HARI        Retensi dalam hari (default: $RETENTION_DAYS)
  -e RECIPIENT   GPG recipient untuk enkripsi (opsional)
  -h             Tampilkan bantuan ini
EOF
}

while getopts ":s:d:r:e:h" opt; do
  case "$opt" in
    s) BACKUP_SOURCE="$OPTARG" ;;
    d) BACKUP_DEST="$OPTARG" ;;
    r) RETENTION_DAYS="$OPTARG" ;;
    e) GPG_RECIPIENT="$OPTARG" ;;
    h) usage; exit 0 ;;
    :) die "Opsi -$OPTARG memerlukan argumen." ;;
    \?) die "Opsi tidak dikenal: -$OPTARG" ;;
  esac
done
shift $((OPTIND - 1))

# ---------------------------------------------------------------------------
# Validasi lingkungan
# ---------------------------------------------------------------------------
[[ -d "$BACKUP_SOURCE" ]] || die "Sumber tidak ditemukan: $BACKUP_SOURCE"
[[ -r "$BACKUP_SOURCE" ]] || die "Sumber tidak dapat dibaca: $BACKUP_SOURCE"
[[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]] || die "Retensi harus angka: $RETENTION_DAYS"

command -v tar >/dev/null 2>&1 || die "tar tidak terinstal."
command -v flock >/dev/null 2>&1 || die "flock tidak terinstal (paket util-linux)."

if [[ -n "$GPG_RECIPIENT" ]]; then
  command -v gpg >/dev/null 2>&1 || die "GPG diminta tapi gpg tidak terinstal."
fi

# ---------------------------------------------------------------------------
# Lock untuk mencegah eksekusi konkuren
# ---------------------------------------------------------------------------
exec 9>"$LOCK_FILE" || die "Tidak dapat membuka lock file: $LOCK_FILE"
if ! flock -n 9; then
  die "Skrip lain sedang berjalan (lock: $LOCK_FILE). Keluar."
fi
info "Lock diperoleh: $LOCK_FILE"

# ---------------------------------------------------------------------------
# Persiapan direktori tujuan
# ---------------------------------------------------------------------------
mkdir -p -- "$BACKUP_DEST" || die "Gagal membuat direktori: $BACKUP_DEST"
[[ -w "$BACKUP_DEST" ]] || die "Direktori tidak dapat ditulis: $BACKUP_DEST"

# ---------------------------------------------------------------------------
# Buat arsip
# ---------------------------------------------------------------------------
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BASENAME="$(basename -- "$BACKUP_SOURCE")"
ARCHIVE_BASE="${BACKUP_DEST}/${BASENAME}_${TIMESTAMP}.tar.gz"
ARCHIVE="$ARCHIVE_BASE"
[[ -n "$GPG_RECIPIENT" ]] && ARCHIVE="${ARCHIVE_BASE}.gpg"

TEMP_ARCHIVE="$(mktemp --suffix=.tar.gz "${BACKUP_DEST}/.partial.XXXXXX")"
TEMP_FILES+=("$TEMP_ARCHIVE")

info "Membuat arsip: $TEMP_ARCHIVE"
tar -czf "$TEMP_ARCHIVE" \
  --warning=no-file-changed \
  --warning=no-file-removed \
  -C "$(dirname -- "$BACKUP_SOURCE")" "$(basename -- "$BACKUP_SOURCE")" \
  2>/dev/null || {
    # tar mengembalikan 1 jika file berubah selama backup; itu masih ok.
    rc=$?
    if (( rc == 1 )); then
      warn "Beberapa file berubah selama backup (tar rc=1). Lanjut."
    else
      die "tar gagal dengan kode $rc"
    fi
  }

# ---------------------------------------------------------------------------
# Verifikasi arsip
# ---------------------------------------------------------------------------
info "Memverifikasi integritas arsip..."
tar -tzf "$TEMP_ARCHIVE" >/dev/null || die "Arsip korup: $TEMP_ARCHIVE"
CHECKSUM="$(sha256sum "$TEMP_ARCHIVE" | awk '{print $1}')"
info "Checksum SHA256: $CHECKSUM"

# ---------------------------------------------------------------------------
# Enkripsi (opsional)
# ---------------------------------------------------------------------------
if [[ -n "$GPG_RECIPIENT" ]]; then
  info "Mengenkripsi arsip untuk recipient: $GPG_RECIPIENT"
  gpg --batch --yes --trust-model always \
      --recipient "$GPG_RECIPIENT" \
      --output "$ARCHIVE" \
      --encrypt "$TEMP_ARCHIVE" \
    || die "Enkripsi GPG gagal."
  rm -f -- "$TEMP_ARCHIVE"
else
  mv -- "$TEMP_ARCHIVE" "$ARCHIVE"
fi

# Simpan checksum di samping arsip
printf '%s  %s\n' "$CHECKSUM" "$(basename -- "$ARCHIVE")" > "${ARCHIVE}.sha256"

ARCHIVE_SIZE="$(du -h -- "$ARCHIVE" | awk '{print $1}')"
info "Backup selesai: $ARCHIVE ($ARCHIVE_SIZE)"

# ---------------------------------------------------------------------------
# Salin ke remote (opsional)
# ---------------------------------------------------------------------------
if [[ -n "$REMOTE_TARGET" ]]; then
  command -v rsync >/dev/null 2>&1 || die "rsync tidak terinstal."
  info "Menyalin ke remote: $REMOTE_TARGET"
  rsync -avz --partial --progress \
    -e "ssh -i ${REMOTE_SSH_KEY:-$HOME/.ssh/id_rsa} -o StrictHostKeyChecking=accept-new" \
    "$ARCHIVE" "${ARCHIVE}.sha256" "$REMOTE_TARGET/" \
    || die "rsync ke remote gagal."
  info "Salinan remote selesai."
fi

# ---------------------------------------------------------------------------
# Rotasi backup
# ---------------------------------------------------------------------------
info "Merotasi backup lebih lama dari $RETENTION_DAYS hari..."
mapfile -t OLD_FILES < <(
  find "$BACKUP_DEST" -maxdepth 1 -type f \
    \( -name "${BASENAME}_*.tar.gz" -o -name "${BASENAME}_*.tar.gz.gpg" \) \
    -mtime +"$RETENTION_DAYS" -print
)
if (( ${#OLD_FILES[@]} > 0 )); then
  for f in "${OLD_FILES[@]}"; do
    info "Menghapus: $f"
    rm -f -- "$f" "${f}.sha256"
  done
else
  info "Tidak ada backup lama untuk dihapus."
fi

info "Semua tugas backup selesai."
```

#### **2.3. Penjelasan Mendalam**

**a. `set -Eeuo pipefail`**
- `-e`: Keluar jika perintah gagal (dengan pengecualian tertentu).
- `-E`: Trap `ERR` diwarisi oleh fungsi dan sub-shell.
- `-u`: Error jika variabel belum didefinisikan.
- `-o pipefail`: Pipeline gagal jika salah satu komponennya gagal.

**b. `IFS=$'\n\t'`**
Membatasi *word splitting* hanya pada newline dan tab, sehingga nama file dengan spasi aman.

**c. `flock -n 9`**
`flock` pada file descriptor 9 memastikan hanya satu instance skrip yang berjalan. `-n` = non-blocking; jika lock dipegang, langsung keluar.

**d. `mktemp --suffix=.tar.gz`**
Membuat file sementara dengan nama unik. `--suffix` penting agar `tar` mengenali format.

**e. `tar --warning=no-file-changed`**
Menekan warning saat file berubah selama backup. `tar` mengembalikan exit code 1 dalam kasus ini, yang kita tangani sebagai "warning, bukan error".

**f. Verifikasi `tar -tzf`**
Membaca arsip untuk memastikan tidak korup sebelum dienkripsi/dipindahkan.

**g. `sha256sum`**
Menghasilkan checksum untuk verifikasi integritas jangka panjang. Disimpan di samping arsip.

**h. GPG Encryption**
`--trust-model always` menghindari prompt interaktif. Di produksi, sebaiknya gunakan `--trust-model direct` dengan key yang sudah diverifikasi.

**i. `mapfile -t OLD_FILES < <(...)`**
Membaca output `find` ke dalam array dengan aman (newline sebagai pemisah). Menghindari masalah *word splitting*.

**j. `find ... -print` bukan `-delete`**
Kita mengumpulkan dulu, lalu hapus satu per satu agar dapat di-log. `-delete` tidak memberi kesempatan logging per file.

#### **2.4. Latihan**

1. Tambahkan opsi `-c` untuk mengaktifkan kompresi `zstd` alih-alih `gzip`.
2. Modifikasi skrip agar mendukung **backup incremental** menggunakan `tar --listed-incremental`.
3. Tambahkan fitur **restore otomatis** yang memverifikasi checksum dan mengekstrak ke direktori sementara.
4. Integrasikan dengan **Prometheus Pushgateway** untuk mengirim metrik durasi dan ukuran backup.

---

### **3. Studi Kasus 2: Skrip Monitoring Tingkat Enterprise**

#### **3.1. Kebutuhan**

Monitoring enterprise harus:

1. Mengukur **banyak metrik**: CPU, memory, disk, network, load, service health, log errors.
2. **Portabel** lintas Linux/macOS.
3. Mengirim **notifikasi terstruktur** (JSON) ke sistem seperti Slack, PagerDuty, atau webhook.
4. Memiliki **threshold yang dapat dikonfigurasi**.
5. **Tidak spam** — gunakan state file untuk mencegah alert berulang.
6. **Cepat** — hindari perintah yang mahal.

#### **3.2. Implementasi**

```bash
#!/usr/bin/env bash
#
# monitor_enterprise.sh — Monitoring multi-metrik dengan notifikasi webhook.
#
set -Eeuo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly STATE_DIR="${STATE_DIR:-/var/lib/monitor_enterprise}"
readonly WEBHOOK_URL="${WEBHOOK_URL:-}"
readonly HOSTNAME_FQDN="$(hostname -f 2>/dev/null || hostname)"

# Threshold
readonly CPU_THRESHOLD="${CPU_THRESHOLD:-85}"
readonly MEM_THRESHOLD="${MEM_THRESHOLD:-90}"
readonly DISK_THRESHOLD="${DISK_THRESHOLD:-85}"
readonly LOAD_THRESHOLD="${LOAD_THRESHOLD:-4.0}"

# Service yang dipantau (dipisah spasi)
readonly SERVICES="${SERVICES:-nginx sshd cron}"

mkdir -p -- "$STATE_DIR"

log() {
  local level="$1"; shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$level" "$*" >&2
  command -v logger >/dev/null 2>&1 && logger -t monitor_enterprise -p "user.${level,,}" -- "$*" || true
}

# ---------------------------------------------------------------------------
# Deteksi platform
# ---------------------------------------------------------------------------
detect_os() {
  case "$(uname -s)" in
    Linux*)  echo "linux" ;;
    Darwin*) echo "macos" ;;
    *)       echo "unknown" ;;
  esac
}
readonly OS="$(detect_os)"

# ---------------------------------------------------------------------------
# Metrik: CPU usage (%)
# ---------------------------------------------------------------------------
get_cpu_usage() {
  case "$OS" in
    linux)
      # Baca dua kali dan hitung delta
      local -a s1 s2
      read -ra s1 < /proc/stat
      sleep 1
      read -ra s2 < /proc/stat
      local idle1=${s1[4]} total1=0 idle2=${s2[4]} total2=0
      for v in "${s1[@]:1}"; do (( total1 += v )); done
      for v in "${s2[@]:1}"; do (( total2 += v )); done
      local dt=$(( total2 - total1 ))
      local di=$(( idle2 - idle1 ))
      (( dt == 0 )) && echo 0 && return
      echo $(( 100 * (dt - di) / dt ))
      ;;
    macos)
      # top -l 2 membutuhkan 2 sampel
      top -l 2 -n 0 | awk '/CPU usage/ {gsub("%","",$7); print $7}' | tail -1
      ;;
    *) echo 0 ;;
  esac
}

# ---------------------------------------------------------------------------
# Metrik: Memory usage (%)
# ---------------------------------------------------------------------------
get_mem_usage() {
  case "$OS" in
    linux)
      local total used
      read -r _ total _ < <(grep '^MemTotal:' /proc/meminfo)
      read -r _ used  _ < <(grep '^MemAvailable:' /proc/meminfo)
      (( total == 0 )) && echo 0 && return
      echo $(( 100 * (total - used) / total ))
      ;;
    macos)
      vm_stat | awk '
        /page size of/ { ps=$8 }
        /Pages active/ { a=$3 }
        /Pages wired/ { w=$4 }
        /Pages occupied by compressor/ { c=$5 }
        END { printf "%d", (a+w+c)*ps/1024/1024 }'
      # Sederhanakan: persen dari 8GB tidak akurat; gunakan pendekatan berikut:
      # Di macOS, gunakan memory_pressure
      memory_pressure 2>/dev/null | awk '/System-wide memory free percentage/ {gsub("%","",$5); print 100-$5}' || echo 0
      ;;
    *) echo 0 ;;
  esac
}

# ---------------------------------------------------------------------------
# Metrik: Disk usage (%) untuk path tertentu
# ---------------------------------------------------------------------------
get_disk_usage() {
  local path="${1:-/}"
  # df -P = format POSIX, kolom 5 = capacity
  df -P -- "$path" 2>/dev/null | awk 'NR==2 {gsub("%","",$5); print $5}'
}

# ---------------------------------------------------------------------------
# Metrik: Load average (1 menit)
# ---------------------------------------------------------------------------
get_load() {
  case "$OS" in
    linux)  awk '{print $1}' /proc/loadavg ;;
    macos)  sysctl -n vm.loadavg | awk '{print $2}' ;;
    *)      uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ' ;;
  esac
}

# ---------------------------------------------------------------------------
# Cek service
# ---------------------------------------------------------------------------
check_service() {
  local svc="$1"
  if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active --quiet "$svc"
  elif command -v service >/dev/null 2>&1; then
    service "$svc" status >/dev/null 2>&1
  else
    pgrep -x "$svc" >/dev/null 2>&1
  fi
}

# ---------------------------------------------------------------------------
# State & anti-spam
# ---------------------------------------------------------------------------
should_alert() {
  local key="$1" value="$2" threshold="$3"
  local state_file="${STATE_DIR}/${key}.state"
  local last=""
  [[ -f "$state_file" ]] && last="$(<"$state_file")"

  if (( value > threshold )); then
    if [[ "$last" == "alerting" ]]; then
      return 1   # sudah alert, jangan spam
    fi
    echo "alerting" > "$state_file"
    return 0
  else
    if [[ "$last" == "alerting" ]]; then
      echo "ok" > "$state_file"
      # Kirim notifikasi recovery
      send_recovery "$key" "$value"
    fi
    return 1
  fi
}

# ---------------------------------------------------------------------------
# Notifikasi webhook (Slack-compatible)
# ---------------------------------------------------------------------------
send_alert() {
  local title="$1" body="$2"
  log ALERT "$title - $body"
  [[ -z "$WEBHOOK_URL" ]] && return 0

  local payload
  payload="$(jq -n \
    --arg host "$HOSTNAME_FQDN" \
    --arg title "$title" \
    --arg body "$body" \
    --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{text: ("*[" + $host + "]* " + $title + "\n" + $body + "\n_" + $ts + "_")}')"

  curl -sS -f -X POST \
    -H 'Content-Type: application/json' \
    --max-time 10 --retry 3 --retry-delay 2 \
    -d "$payload" "$WEBHOOK_URL" \
    || log ERROR "Gagal mengirim webhook."
}

send_recovery() {
  local key="$1" value="$2"
  send_alert "RECOVERY: $key" "Nilai kembali normal: $value"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  log INFO "Memulai monitoring di $HOSTNAME_FQDN"

  local cpu mem disk load
  cpu="$(get_cpu_usage)"
  mem="$(get_mem_usage)"
  disk="$(get_disk_usage /)"
  load="$(get_load)"

  log INFO "CPU=${cpu}% MEM=${mem}% DISK=${disk}% LOAD=${load}"

  should_alert cpu "$cpu" "$CPU_THRESHOLD" \
    && send_alert "CPU tinggi" "Penggunaan CPU ${cpu}% (threshold ${CPU_THRESHOLD}%)"

  should_alert mem "$mem" "$MEM_THRESHOLD" \
    && send_alert "Memori tinggi" "Penggunaan memori ${mem}% (threshold ${MEM_THRESHOLD}%)"

  should_alert disk "$disk" "$DISK_THRESHOLD" \
    && send_alert "Disk penuh" "Penggunaan disk / ${disk}% (threshold ${DISK_THRESHOLD}%)"

  # Load dibandingkan dengan integer threshold
  local load_int="${load%.*}"
  should_alert load "$load_int" "$LOAD_THRESHOLD" \
    && send_alert "Load tinggi" "Load average ${load} (threshold ${LOAD_THRESHOLD})"

  # Cek service
  for svc in $SERVICES; do
    if ! check_service "$svc"; then
      should_alert "svc_${svc}" 1 0 \
        && send_alert "Service mati" "Service '$svc' tidak berjalan."
    else
      should_alert "svc_${svc}" 0 0 || true
    fi
  done

  log INFO "Monitoring selesai."
}

main "$@"
```

#### **3.3. Penjelasan Poin Kunci**

- **Portabilitas `df -P`**: Format POSIX mencegah wrapping dan memastikan kolom konsisten. `grep '^/dev/'` dihapus karena gagal pada overlayfs/ZFS/btrfs.
- **`/proc/stat` untuk CPU**: Delta dua sampel memberikan akurasi jauh lebih baik daripada `top`.
- **`MemAvailable` bukan `MemFree`**: `MemFree` mengabaikan cache yang dapat diklaim kembali; `MemAvailable` adalah estimasi realistis.
- **Anti-spam dengan state file**: Mencegah alert berulang setiap 5 menit. Notifikasi recovery dikirim saat kembali normal.
- **`jq -n` untuk payload JSON**: Menghindari escaping manual yang rawan bug.
- **`curl --retry`**: Ketahanan terhadap kegagalan jaringan sementara.
- **`should_alert` mengembalikan exit code**: Digunakan sebagai kondisi `&&`.

#### **3.4. Latihan**

1. Tambahkan metrik **network throughput** menggunakan `/proc/net/dev`.
2. Tambahkan **inode usage** untuk mencegah kehabisan inode.
3. Integrasikan dengan **Prometheus node_exporter textfile collector** — tulis metrik dalam format Prometheus ke `/var/lib/node_exporter/textfile/`.
4. Tambahkan **PagerDuty Events API v2** sebagai alternatif webhook.
5. Buat mode `--dry-run` yang hanya mencetak alert tanpa mengirim.

---

### **4. Penjadwalan: `cron`, `systemd timers`, dan `anacron`**

#### **4.1. `cron` — Dasar**

**Sintaks crontab:**
```
* * * * * perintah
│ │ │ │ │
│ │ │ │ └── Hari dalam minggu (0-7, 0/7 = Minggu)
│ │ │ └──── Bulan (1-12)
│ │ └────── Hari dalam bulan (1-31)
│ └──────── Jam (0-23)
└────────── Menit (0-59)
```

**Lokasi crontab:**
- `/var/spool/cron/crontabs/$USER` (Debian/Ubuntu)
- `/var/spool/cron/$USER` (RHEL/CentOS)
- `/etc/crontab` — sistem-wide, memiliki kolom `user`
- `/etc/cron.d/` — drop-in, juga memiliki kolom `user`

**Contoh `/etc/cron.d/backup`:**
```
# m h dom mon dow user  command
0 3 * * *   root  /usr/local/bin/backup_enterprise.sh >> /var/log/backup.log 2>&1
```

**Praktik terbaik `cron`:**
- **Selalu gunakan path absolut** untuk perintah dan file.
- **Set `PATH`, `MAILTO`, `SHELL`** di awal crontab:
  ```
  SHELL=/bin/bash
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  MAILTO=ops@example.com
  ```
- **Redirect output** ke log agar dapat diaudit.
- **Gunakan `flock`** untuk mencegah overlap:
  ```
  */5 * * * * root flock -n /var/lock/monitor.lock /usr/local/bin/monitor.sh
  ```
- **Gunakan `logger`** untuk integrasi dengan syslog/journald.

**Anti-pola umum:**
- ❌ `* * * * * /path/script.sh` tanpa redirect → email spam.
- ❌ `@reboot` untuk layanan jangka panjang → gunakan `systemd service`.
- ❌ `0 0 31 2 *` (31 Februari) → tidak pernah jalan.

#### **4.2. `systemd timers` — Rekomendasi Modern**

`systemd timers` lebih unggul daripada `cron` karena:
- Logging otomatis ke journald (`journalctl -u backup.timer`).
- Dependensi eksplisit (`After=`, `Requires=`).
- `Persistent=true` untuk mengejar jadwal yang terlewat.
- `RandomizedDelaySec` untuk menghindari thundering herd.
- Resource control (CPU, memory limit).

**Contoh: `/etc/systemd/system/backup.service`**
```ini
[Unit]
Description=Enterprise Backup Service
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup_enterprise.sh
User=backup
Group=backup
Nice=10
IOSchedulingClass=best-effort
IOSchedulingPriority=7
# Hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/mnt/backups
ProtectKernelTunables=true
ProtectControlGroups=true
RestrictNamespaces=true
```

**Contoh: `/etc/systemd/system/backup.timer`**
```ini
[Unit]
Description=Run backup daily at 03:00

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
RandomizedDelaySec=10m
AccuracySec=1m

[Install]
WantedBy=timers.target
```

**Aktivasi:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now backup.timer
systemctl list-timers --all
journalctl -u backup.service -f
```

**Konversi crontab ke OnCalendar:**

| Cron | systemd OnCalendar |
|---|---|
| `0 3 * * *` | `*-*-* 03:00:00` |
| `*/5 * * * *` | `*-*-* *:0/5:00` |
| `0 0 1 * *` | `*-*-01 00:00:00` |
| `@daily` | `daily` |
| `@hourly` | `hourly` |
| `@weekly` | `weekly` |
| `@reboot` | (gunakan service, bukan timer) |

Validasi dengan `systemd-analyze calendar "*-*-* 03:00:00"`.

#### **4.3. `anacron` — Untuk Mesin yang Sering Mati**

Laptop dan workstation yang sering dimatikan tidak cocok dengan `cron` karena jadwal terlewat. `anacron` menjalankan tugas yang terlewat saat mesin hidup.

**`/etc/anacrontab`:**
```
# period delay job-identifier command
1        5     cron.daily    run-parts /etc/cron.daily
7        10    cron.weekly   run-parts /etc/cron.weekly
@monthly 15    cron.monthly  run-parts /etc/cron.monthly
```

`period` dalam hari, `delay` dalam menit setelah boot.

#### **4.4. Latihan**

1. Konversi `/etc/cron.d/backup` ke `systemd timer` lengkap dengan hardening.
2. Buat timer dengan `OnBootSec=5min` untuk menjalankan monitoring 5 menit setelah boot.
3. Gunakan `systemd-analyze calendar` untuk memverifikasi jadwal `Mon..Fri *-*-* 09:00:00`.
4. Implementasikan `anacron` untuk tugas harian di laptop.

---

### **5. Konsep Idempoten dalam Otomatisasi**

#### **5.1. Definisi Formal**

Sebuah operasi `f` dikatakan **idempoten** jika `f(f(x)) = f(x)`. Dalam konteks administrasi sistem, ini berarti menjalankan skrip berkali-kali menghasilkan state akhir yang sama seperti menjalankan sekali.

#### **5.2. Mengapa Idempotensi Penting**

- **Recovery**: Jika skrip gagal di tengah, dapat dijalankan ulang tanpa merusak state.
- **Scheduling**: Cron yang overlap tidak menyebabkan korupsi.
- **Konfigurasi**: Menjamin konsistensi antar server.
- **Testing**: Memudahkan pengujian.

#### **5.3. Teknik Mencapai Idempotensi di Bash**

**a. Cek sebelum bertindak:**
```bash
# Tidak idempoten
mkdir /data

# Idempoten
mkdir -p /data
```

**b. Gunakan `install` untuk file:**
```bash
# Idempoten: hanya menulis jika berbeda
install -m 0644 -o root -g root config.conf /etc/myapp/config.conf
```

**c. Cek user sebelum dibuat:**
```bash
if ! id -u myuser >/dev/null 2>&1; then
  useradd -m -s /bin/bash myuser
fi
```

**d. Gunakan checksum untuk file konfigurasi:**
```bash
CONFIG_HASH="$(sha256sum config.conf | awk '{print $1}')"
STATE_FILE="/var/lib/myapp/config.sha256"
if [[ ! -f "$STATE_FILE" || "$(<"$STATE_FILE")" != "$CONFIG_HASH" ]]; then
  install -m 0644 config.conf /etc/myapp/config.conf
  echo "$CONFIG_HASH" > "$STATE_FILE"
fi
```

**e. `rsync` alih-alih `cp`:**
```bash
# Idempoten
rsync -a --delete /src/ /dst/
```

**f. Hindari `>>` untuk konfigurasi:**
```bash
# Tidak idempoten — duplikat setiap kali
echo "export PATH=$PATH:/opt/bin" >> ~/.bashrc

# Idempoten
grep -qF '/opt/bin' ~/.bashrc || echo "export PATH=$PATH:/opt/bin" >> ~/.bashrc
```

#### **5.4. Latihan**

1. Ubah skrip backup agar **tidak** membuat arsip baru jika konten tidak berubah (gunakan checksum direktori).
2. Tulis skrip idempoten untuk menambahkan user ke grup, memastikan tidak duplikat.
3. Tulis skrip idempoten untuk mengonfigurasi `sysctl` yang hanya menerapkan perubahan jika nilai berbeda.

---

### **6. Manajemen User dan Log Rotation**

#### **6.1. Manajemen User Otomatis**

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

readonly USERS_FILE="${1:?Penggunaan: $0 users.csv}"

# Format: username,uid,groups,shell,ssh_key_file
while IFS=',' read -r username uid groups shell key_file; do
  [[ "$username" =~ ^#.*$ || -z "$username" ]] && continue

  if ! id -u "$username" >/dev/null 2>&1; then
    useradd -m -u "$uid" -s "$shell" "$username"
    echo "User $username dibuat."
  else
    echo "User $username sudah ada, dilewati."
  fi

  IFS=',' read -ra grp_array <<< "$groups"
  for g in "${grp_array[@]}"; do
    getent group "$g" >/dev/null || groupadd "$g"
    usermod -aG "$g" "$username"
  done

  if [[ -n "$key_file" && -f "$key_file" ]]; then
    install -d -m 0700 -o "$username" -g "$username" "/home/$username/.ssh"
    install -m 0600 -o "$username" -g "$username" \
      "$key_file" "/home/$username/.ssh/authorized_keys"
  fi
done < "$USERS_FILE"
```

**Poin penting:**
- **Cek sebelum bertindak** → idempoten.
- **`usermod -aG`** bukan `-G` agar tidak menghapus grup lain.
- **Permission `.ssh` 0700, `authorized_keys` 0600** — wajib untuk SSH.
- **Validasi input** — username harus cocok regex `^[a-z_][a-z0-9_-]*$`.

#### **6.2. Log Rotation**

`logrotate` adalah standar de-facto. Konfigurasi di `/etc/logrotate.d/myapp`:

```
/var/log/myapp/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0640 myapp adm
    sharedscripts
    postrotate
        systemctl reload myapp >/dev/null 2>&1 || true
    endscript
}
```

**Penjelasan direktif:**

| Direktif | Fungsi |
|---|---|
| `daily` | Rotasi harian (bisa `weekly`, `monthly`, `size 100M`) |
| `rotate 14` | Simpan 14 file lama |
| `compress` | Gzip file lama |
| `delaycompress` | Tunda kompresi satu siklus (untuk proses yang masih menulis) |
| `missingok` | Jangan error jika file tidak ada |
| `notifempty` | Jangan rotasi jika file kosong |
| `create 0640 myapp adm` | Buat file baru dengan mode/owner |
| `sharedscripts` | Jalankan `postrotate` sekali untuk semua file |
| `postrotate` | Perintah setelah rotasi (mis. reload service) |

**Test tanpa mengubah:**
```bash
logrotate -d /etc/logrotate.d/myapp   # debug/dry-run
logrotate -f /etc/logrotate.d/myapp   # paksa rotasi
```

**Alternatif modern:**
- **`systemd-journald`**: Rotasi otomatis, konfigurasi di `/etc/systemd/journald.conf`.
- **`rsyslog` + `logrotate`**: Standar untuk syslog.
- **Vector / Fluent Bit**: Untuk lingkungan cloud-native.

#### **6.3. Latihan**

1. Buat skrip idempoten untuk membuat 100 user dari file CSV, lengkap dengan grup dan SSH key.
2. Konfigurasi `logrotate` untuk aplikasi yang menulis log 10GB/hari, dengan rotasi per 1GB.
3. Tulis skrip yang memverifikasi bahwa tidak ada user dengan UID 0 selain `root`.

---

### **7. Terminologi Kunci (Modul 4.1)**

- **Otomatisasi**: Penggunaan teknologi untuk menjalankan tugas dengan intervensi manusia minimal.
- **Idempoten**: Operasi yang hasilnya sama terlepas berapa kali dijalankan.
- **`flock`**: Utilitas untuk mengunci file dan mencegah eksekusi konkuren.
- **`mktemp`**: Membuat file/direktori sementara dengan nama unik dan aman.
- **`cron`**: Daemon penjadwal tugas klasik Unix.
- **`systemd timer`**: Unit systemd untuk penjadwalan, alternatif modern `cron`.
- **`anacron`**: Penjadwal untuk mesin yang tidak selalu hidup.
- **`logrotate`**: Utilitas rotasi log.
- **`tar`**: Arsip tape, alat standar untuk backup.
- **SHA-256**: Fungsi hash kriptografis untuk verifikasi integritas.
- **GPG**: GNU Privacy Guard, untuk enkripsi dan signing.
- **rsync**: Sinkronisasi file incremental yang efisien.
- **RPO (Recovery Point Objective)**: Berapa banyak data yang boleh hilang.
- **RTO (Recovery Time Objective)**: Berapa lama waktu pemulihan yang dapat ditoleransi.

---

### **8. Kesalahan Umum & Solusi (Modul 4.1)**

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| Skrip cron tidak jalan | PATH terbatas, path relatif | Path absolut, set PATH di crontab |
| Backup overlap | Tidak ada locking | `flock` |
| Arsip korup | Disk penuh saat menulis | Cek `df` sebelum, verifikasi `tar -tzf` |
| Rotasi hapus file salah | Pola `find` salah | Uji `find` tanpa `-delete` |
| Email alert tidak terkirim | MTA tidak dikonfigurasi | Setup postfix/msmtp, atau gunakan webhook |
| Skrip berhenti tanpa cleanup | Tidak ada `trap` | `trap cleanup EXIT INT TERM` |
| `df` gagal di ZFS/overlay | Parsing `^/dev/` | Gunakan `df -P -- "$path"` |
| `pgrep` false positive | Regex partial | `pgrep -x` |

---

### **9. Referensi (Modul 4.1)**

- **Bash Reference Manual** — https://www.gnu.org/software/bash/manual/
- **Google Shell Style Guide** — https://google.github.io/styleguide/shellguide.html
- **systemd.timer man page** — `man systemd.timer`
- **systemd-analyze calendar** — `man systemd-analyze`
- **`logrotate` man page** — `man logrotate`
- **restic** — https://restic.net/
- **borgbackup** — https://www.borgbackup.org/
- **rsnapshot** — https://rsnapshot.org/
- **BashFAQ** — https://mywiki.wooledge.org/BashFAQ
- **shellcheck** — https://www.shellcheck.net/

---

## **Modul 4.2: Pertimbangan Keamanan dalam Shell Scripting**

### **Tujuan Pembelajaran**

Setelah menyelesaikan modul ini, Anda mampu:

1. Mengidentifikasi dan mencegah **command injection**, **path hijacking**, dan **TOCTOU**.
2. Menerapkan **quoting** dengan benar di semua konteks.
3. Menggunakan `mktemp`, `umask`, dan `trap` untuk file sementara yang aman.
4. Menerapkan **least privilege** dengan `sudo`, capabilities, dan user khusus.
5. Mengelola **rahasia** dengan aman (Vault, SOPS, environment, file permission).
6. Menggunakan `shellcheck` dan `shfmt` sebagai bagian alur kerja.
7. Menghindari anti-pola seperti `eval`, `curl | bash`, dan parsing output yang tidak stabil.

### **Prasyarat**

- Modul 4.1 selesai.
- Pemahaman dasar permission Unix, user/grup, dan sistem file.

---

### **1. Filosofi Keamanan: Meminimalkan Permukaan Serangan**

Setiap baris kode adalah potensi kerentanan. Prinsip-prinsip berikut memandu penulisan skrip aman:

1. **Assume malicious input** — semua input dari luar (argumen, environment, file, network) diperlakukan sebagai berbahaya.
2. **Least privilege** — jalankan dengan hak akses minimum.
3. **Defense in depth** — beberapa lapisan pertahanan, bukan satu.
4. **Fail securely** — jika gagal, gagal ke state yang aman.
5. **Simplicity** — kode lebih sedikit = permukaan serangan lebih kecil.
6. **Validate, then trust** — validasi ketat, lalu gunakan.
7. **No secrets in code** — rahasia tidak pernah di source code.

---

### **2. Command Injection: Ancaman Utama**

#### **2.1. Bagaimana Shell Memproses Perintah**

Shell memproses baris perintah dalam urutan:
1. **Tokenisasi** — memisahkan berdasarkan `IFS` (spasi, tab, newline).
2. **Ekspansi** — variabel, command substitution, arithmetic, globbing.
3. **Pemisahan kata** — hasil ekspansi variabel yang tidak dikutip dipecah lagi.
4. **Eksekusi** — shell mencari perintah dan menjalankannya.

**Kerentanan terjadi pada langkah 3**: jika variabel berisi `; rm -rf /`, shell akan menafsirkan `;` sebagai pemisah perintah.

#### **2.2. Contoh Kerentanan**

```bash
#!/usr/bin/env bash
# VULNERABLE — jangan digunakan!
read -r -p "Nama file: " filename
grep "error" $filename
```

Jika pengguna memasukkan `foo.txt; rm -rf ~`, perintah yang dieksekusi:
```bash
grep error foo.txt; rm -rf ~
```

#### **2.3. Mitigasi Berlapis**

**Lapisan 1 — Quoting:**
```bash
grep "error" -- "$filename"
```
`"$filename"` mencegah word splitting dan globbing. `--` mencegah `$filename` ditafsirkan sebagai opsi jika diawali `-`.

**Lapisan 2 — Validasi input:**
```bash
[[ "$filename" =~ ^[a-zA-Z0-9._-]+$ ]] || { echo "Nama tidak valid"; exit 1; }
```

**Lapisan 3 — Gunakan array untuk argumen:**
```bash
args=("grep" "error" "--" "$filename")
"${args[@]}"
```

**Lapisan 4 — Hindari `eval`:**
```bash
# JANGAN
eval "grep error $filename"

# GUNAKAN
grep error -- "$filename"
```

#### **2.4. Latihan**

1. Perbaiki skrip berikut agar aman:
   ```bash
   echo "Cari user:"
   read -r user
   grep "$user" /etc/passwd | cut -d: -f1
   ```
2. Tulis fungsi `safe_grep` yang menerima pattern dan file, memvalidasi keduanya, dan menggunakan `--`.
3. Gunakan `shellcheck` untuk menemukan semua kerentanan di skrip contoh.

---

### **3. Quoting: Panduan Lengkap**

#### **3.1. Jenis Quoting di Bash**

| Jenis | Karakter | Ekspansi Variabel | Command Sub | Globbing | Word Split |
|---|---|---|---|---|---|
| Unquoted | (tidak ada) | ✅ | ✅ | ✅ | ✅ |
| Double | `"..."` | ✅ | ✅ | ❌ | ❌ |
| Single | `'...'` | ❌ | ❌ | ❌ | ❌ |
| ANSI-C | `$'...'` | ❌ | ❌ | ❌ | ❌ (escape diproses) |
| Backslash | `\x` | N/A | N/A | N/A | Mencegah interpretasi karakter tunggal |

**Aturan emas:** Selalu kutip ganda `"$var"`, kecuali Anda benar-benar tahu mengapa tidak.

#### **3.2. Kesalahpahaman Umum**

**Salah:** *"Double quotes masih mengeksekusi `$()` di dalam nilai variabel."*
```bash
x='$(rm -rf /)'
echo "$x"   # Mencetak literal: $(rm -rf /)
eval "$x"   # BARU mengeksekusi
```
Double quotes mengizinkan **command substitution pada literal yang diketik**, bukan pada hasil ekspansi variabel. Ini penting: `"$var"` **tidak** mengeksekusi `$()` yang tersimpan dalam `$var`.

**Salah:** *"Single quotes aman untuk semua kasus."*
```bash
echo 'It'\''s a test'   # Perlu escape untuk apostrof
```

#### **3.3. Pola Aman**

**a. Argumen array:**
```bash
files=("file with space.txt" "another.txt")
rm -- "${files[@]}"
```

**b. Iterasi file dengan glob:**
```bash
shopt -s nullglob
for f in *.txt; do
  [[ -f "$f" ]] || continue
  echo "Memproses: $f"
done
```

**c. `find -print0` + `read -d ''`:**
```bash
while IFS= read -r -d '' file; do
  echo "File: $file"
done < <(find . -type f -name '*.log' -print0)
```

**d. `xargs -0`:**
```bash
find . -type f -print0 | xargs -0 -r rm --
```
`-r` mencegah `xargs` menjalankan `rm` tanpa argumen.

#### **3.4. Latihan**

1. Jelaskan output dari:
   ```bash
   x='a b'; printf '[%s]\n' $x
   x='a b'; printf '[%s]\n' "$x"
   ```
2. Tulis skrip yang memproses semua file `.csv` di direktori saat ini, menangani nama dengan spasi dan newline.
3. Ubah `for f in $(ls)` menjadi bentuk aman.

---

### **4. Mengapa Tidak Boleh Mem-parsing Output `ls`**

`ls` dirancang untuk **manusia**, bukan mesin. Output-nya dapat mengandung:
- Spasi dalam nama file.
- Newline dalam nama file (legal di Unix!).
- Warna ANSI.
- Kolom yang di-wrap.
- Sorting yang bergantung locale.

**Anti-pola:**
```bash
for f in $(ls); do ...; done   # RUSAK
ls | while read -r f; do ...; done   # RUSAK untuk newline
```

**Solusi:**
```bash
# Untuk file di direktori saat ini
for f in *; do
  [[ -e "$f" ]] || continue
  ...
done

# Untuk pencarian rekursif
find . -type f -print0 | while IFS= read -r -d '' f; do
  ...
done

# Untuk sorting
mapfile -t files < <(find . -maxdepth 1 -type f -print | sort)
```

**Catatan:** `find ... -print` masih rusak untuk newline. Gunakan `-print0` jika ada kemungkinan newline.

---

### **5. File Sementara yang Aman dengan `mktemp`**

#### **5.1. Bahaya File Sementara Statis**

```bash
# BERBAHAYA
TEMP=/tmp/myapp.tmp
echo "data" > "$TEMP"
```

Risiko:
- **Symlink attack**: Penyerang membuat `/tmp/myapp.tmp` sebagai symlink ke `/etc/passwd`.
- **Race condition (TOCTOU)**: Antara cek dan penggunaan, file bisa diganti.
- **Konflik**: Dua instance skrip menggunakan file yang sama.

#### **5.2. Penggunaan `mktemp` yang Benar**

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

umask 077   # File baru hanya dapat diakses owner

TEMP_FILES=()
cleanup() {
  local rc=$?
  for f in "${TEMP_FILES[@]:-}"; do
    [[ -e "$f" ]] && rm -rf -- "$f"
  done
  exit "$rc"
}
trap cleanup EXIT INT TERM

# Buat file
TEMP_FILE="$(mktemp)" || { echo "Gagal mktemp"; exit 1; }
TEMP_FILES+=("$TEMP_FILE")

# Buat direktori
TEMP_DIR="$(mktemp -d)" || { echo "Gagal mktemp -d"; exit 1; }
TEMP_FILES+=("$TEMP_DIR")

# Gunakan
echo "rahasia" > "$TEMP_FILE"
```

**Poin penting:**
- **`umask 077` sebelum `mktemp`** — `mktemp` membuat file 0600, tapi direktori induk bisa 0777.
- **Daftarkan ke array** — agar cleanup menangani semua.
- **`trap` dipasang sebelum file pertama** — hindari kebocoran.

#### **5.3. Latihan**

1. Tulis skrip yang mengunduh file dengan `curl`, memprosesnya, dan memastikan tidak ada file sementara tertinggal meski skrip di-`Ctrl+C`.
2. Jelaskan mengapa `TEMP=/tmp/$$.tmp` tidak aman meski `$$` adalah PID.
3. Implementasikan fungsi `with_tempdir` yang menerima perintah dan menjalankannya dalam direktori sementara.

---

### **6. Least Privilege: `sudo`, Capabilities, dan User Khusus**

#### **6.1. Prinsip**

Skrip yang berjalan sebagai `root` memiliki akses tak terbatas. Jika dikompromikan, dampaknya katastrofik. **Jalankan sebagai user biasa, gunakan `sudo` hanya untuk perintah spesifik.**

#### **6.2. Pola `sudo` yang Aman**

**Anti-pola:**
```bash
sudo bash -c "rm -rf $DIR"   # $DIR bisa berisi injection
```

**Pola aman:**
```bash
sudo rm -rf -- "$DIR"
```

`sudo` meneruskan argumen ke perintah target, bukan melalui shell. Tidak ada word splitting tambahan.

#### **6.3. Konfigurasi `sudoers`**

```
# /etc/sudoers.d/myapp
myapp ALL=(root) NOPASSWD: /usr/local/bin/myapp_restart
myapp ALL=(root) NOPASSWD: /bin/systemctl restart myapp.service
```

- **Batasi perintah spesifik** — jangan `NOPASSWD: ALL`.
- **Gunakan path absolut** — mencegah PATH hijacking.
- **Validasi dengan `visudo -c`** sebelum apply.
- **`Defaults:myapp !requiretty`** jika perlu dari non-TTY.

#### **6.4. Linux Capabilities**

Untuk menghindari `root` sepenuhnya, gunakan capabilities:

```bash
# Beri kemampuan bind port < 1024 tanpa root
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/myapp

# Cek
getcap /usr/local/bin/myapp
```

Capabilities umum:
- `cap_net_bind_service` — bind port < 1024.
- `cap_net_admin` — konfigurasi network.
- `cap_sys_time` — set system time.
- `cap_dac_read_search` — bypass permission baca.

#### **6.5. User Sistem Khusus**

```bash
sudo useradd --system --no-create-home --shell /usr/sbin/nologin backup-agent
sudo chown -R backup-agent:backup-agent /var/lib/backup-agent
sudo chmod 0700 /var/lib/backup-agent
```

Jalankan skrip dengan `User=backup-agent` di systemd service.

#### **6.6. Latihan**

1. Tulis entri `sudoers` yang memungkinkan user `deploy` menjalankan hanya `systemctl restart myapp`.
2. Ganti penggunaan `sudo bash` di skrip Anda dengan perintah langsung.
3. Berikan capability `cap_net_bind_service` ke binary Go yang listen di port 80.

---

### **7. Bahaya `eval`, `source`, dan `curl | bash`**

#### **7.1. `eval`**

`eval` mengeksekusi string sebagai kode. Sangat berbahaya jika string mengandung input pengguna.

```bash
# BAHAYA
read -r cmd
eval "$cmd"   # Pengguna bisa menjalankan apa saja

# Jika harus, validasi ketat
[[ "$cmd" =~ ^(start|stop|restart)$ ]] || exit 1
case "$cmd" in
  start) ... ;;
  stop) ... ;;
  restart) ... ;;
esac
```

**Alternatif `eval` untuk variabel dinamis:**
```bash
# JANGAN
var="foo"; eval "echo \$$var"

# GUNAKAN indirect expansion
var="foo"; echo "${!var}"
```

#### **7.2. `source` File Tidak Tepercaya**

`source` menjalankan file dalam shell saat ini. Jika file dari sumber tidak tepercaya, itu sama dengan `eval`.

```bash
# BAHAYA
source /tmp/user_config.sh

# AMAN: baca sebagai data, bukan kode
while IFS='=' read -r key value; do
  [[ "$key" =~ ^[A-Z_]+$ ]] || continue
  declare "$key=$value"
done < /tmp/user_config
```

#### **7.3. `curl | bash`**

Pola populer tapi berbahaya:
```bash
curl -sSL https://example.com/install.sh | bash
```

Risiko:
- **Tidak ada verifikasi** — MITM bisa mengganti konten.
- **Tidak ada review** — Anda tidak tahu apa yang dijalankan.
- **Tidak reproducible** — URL bisa berubah.

**Pola aman:**
```bash
curl -fsSL -o /tmp/install.sh https://example.com/install.sh
curl -fsSL -o /tmp/install.sh.sig https://example.com/install.sh.sig
gpg --verify /tmp/install.sh.sig /tmp/install.sh || exit 1
bash /tmp/install.sh
```

#### **7.4. Latihan**

1. Refactor skrip yang menggunakan `eval` untuk menghindari `eval`.
2. Tulis fungsi `verify_and_source` yang memverifikasi GPG sebelum `source`.
3. Buat skrip installer yang memverifikasi checksum sebelum eksekusi.

---

### **8. PATH, IFS, dan Environment Hijacking**

#### **8.1. PATH Hijacking**

Jika `PATH` mengandung direktori yang dapat ditulis user, penyerang dapat menaruh binary berbahaya.

```bash
# BERBAHAYA
PATH=".:$PATH"
tar -czf backup.tar.gz /data   # ./tar bisa saja berbahaya
```

**Mitigasi:**
- **Set PATH eksplisit** di awal skrip:
  ```bash
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  export PATH
  ```
- **Gunakan path absolut** untuk binary kritis.
- **Jangan pernah** menambahkan `.` ke PATH.

#### **8.2. IFS Hijacking**

`IFS` (Internal Field Separator) menentukan pemisah kata. Jika penyerang mengubahnya, parsing bisa rusak.

```bash
# Di awal skrip
IFS=$' \t\n'
```

Untuk operasi spesifik, set lokal:
```bash
while IFS= read -r line; do ...; done < file
```

#### **8.3. Environment Variables Berbahaya**

- **`LD_PRELOAD`** — menyuntikkan library.
- **`BASH_ENV`** — file yang di-source saat bash start (non-interaktif).
- **`ENV`** — untuk shell POSIX.

**Mitigasi:** Di systemd service, gunakan `Environment=` eksplisit. Untuk skrip setuid, Bash otomatis menonaktifkan banyak variabel.

#### **8.4. `umask`**

Set `umask 077` di awal skrip untuk memastikan file baru hanya dapat diakses owner.

```bash
umask 077
```

#### **8.5. Latihan**

1. Tulis skrip yang secara eksplisit mengatur `PATH` dan `IFS` di awal.
2. Jelaskan mengapa `LD_PRELOAD` berbahaya untuk skrip setuid.
3. Konfigurasi systemd service dengan `Environment=` yang bersih.

---

### **9. `shellcheck` dan `shfmt`**

#### **9.1. `shellcheck`**

`shellcheck` adalah linter statis yang mendeteksi ratusan masalah: quoting, word splitting, penggunaan `[` vs `[[`, `echo -e`, variabel tak terpakai, dan banyak lagi.

**Instalasi:**
```bash
# Debian/Ubuntu
sudo apt install shellcheck

# macOS
brew install shellcheck

# Via Docker
docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable /mnt/script.sh
```

**Penggunaan:**
```bash
shellcheck script.sh
shellcheck -S warning script.sh   # hanya warning ke atas
shellcheck -f json script.sh      # output JSON untuk CI
```

**Direktif inline:**
```bash
# shellcheck disable=SC2086
echo $unquoted   # Sengaja, mis. untuk word splitting
```

**Integrasi VS Code:** Ekstensi `timonwong.shellcheck`.

**Integrasi pre-commit:**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.10.0
    hooks:
      - id: shellcheck
```

#### **9.2. `shfmt`**

`shfmt` memformat skrip Bash secara konsisten.

```bash
shfmt -w -i 2 -ci script.sh
```

- `-i 2` — indent 2 spasi.
- `-ci` — indent `case` labels.
- `-w` — write in place.

**Integrasi editor:** VS Code `foxundermoon.shell-format`.

#### **9.3. Latihan**

1. Jalankan `shellcheck` pada semua skrip di proyek Anda, perbaiki semua warning.
2. Konfigurasi `.editorconfig` untuk proyek shell.
3. Buat pre-commit hook yang menjalankan `shellcheck` dan `shfmt`.

---

### **10. Manajemen Rahasia**

#### **10.1. Anti-pola**

```bash
API_KEY="sk-abc123..."   # Di source code
echo "Password: $PASSWORD"   # Di log
curl "https://api.example.com?key=$API_KEY"   # Di URL (bisa muncul di log server)
```

#### **10.2. Praktik Terbaik**

**a. Environment variable:**
```bash
# Di systemd service
EnvironmentFile=/etc/myapp/secrets.env
ExecStart=/usr/local/bin/myapp.sh
```

File `/etc/myapp/secrets.env` harus `chmod 0600`, owner `root:myapp`.

**b. File dengan permission ketat:**
```bash
install -m 0600 -o root -g root secrets.conf /etc/myapp/secrets.conf
```

**c. HashiCorp Vault:**
```bash
API_KEY="$(vault kv get -field=api_key secret/myapp)"
```

**d. SOPS:**
```bash
sops -d secrets.enc.yaml > /run/secrets.yaml
```

**e. File descriptor:**
```bash
exec 3< /etc/myapp/api_key
API_KEY="$(cat <&3)"
exec 3<&-
```

**f. Jangan log rahasia:**
```bash
# Gunakan masking
log INFO "Menggunakan API key: ${API_KEY:0:4}****"
```

#### **10.3. Rotasi Rahasia**

- **Jangan hardcode** — gunakan Vault/SOPS.
- **Rotasi otomatis** — Vault dynamic secrets, AWS IAM roles.
- **Audit akses** — catat siapa mengakses rahasia kapan.

#### **10.4. Latihan**

1. Pindahkan API key hardcoded di skrip cuaca ke environment variable.
2. Tulis skrip yang membaca rahasia dari Vault dengan fallback ke file.
3. Konfigurasi `systemd` `LoadCredential=` untuk rahasia.

---

### **11. Terminologi Kunci (Modul 4.2)**

- **Command injection**: Menyuntikkan perintah melalui input yang tidak divalidasi.
- **TOCTOU**: Time-of-check to time-of-use, race condition.
- **Symlink attack**: Mengganti file dengan symlink ke target sensitif.
- **PATH hijacking**: Menaruh binary berbahaya di PATH.
- **IFS hijacking**: Mengubah pemisah kata untuk merusak parsing.
- **Least privilege**: Hak akses minimum yang diperlukan.
- **Capabilities**: Pembagian hak root menjadi unit-unit granular.
- **Secrets management**: Pengelolaan rahasia (API key, password) secara aman.
- **Static analysis**: Analisis kode tanpa eksekusi.
- **Threat model**: Deskripsi sistematis tentang ancaman yang mungkin.

---

### **12. Kesalahan Umum & Solusi (Modul 4.2)**

| Kesalahan | Solusi |
|---|---|
| Variabel tidak dikutip | `"$var"` selalu |
| Menggunakan `eval` | Hindari; gunakan array atau indirect expansion |
| `source` file tidak tepercaya | Baca sebagai data, bukan kode |
| File sementara statis | `mktemp` + `trap` |
| Menjalankan seluruh skrip sebagai root | `sudo` untuk perintah spesifik |
| API key di source code | Environment, Vault, SOPS |
| Log berisi rahasia | Masking, redaction |
| `curl \| bash` | Verifikasi GPG/checksum |
| Tidak memvalidasi input | Regex whitelist |
| `PATH` mengandung `.` | Set PATH eksplisit |

---

### **13. Referensi (Modul 4.2)**

- **ShellCheck** — https://www.shellcheck.net/
- **ShellCheck Wiki (Gallery of Bad Code)** — https://github.com/koalaman/shellcheck/wiki
- **OWASP Command Injection** — https://owasp.org/www-community/attacks/Command_Injection
- **BashFAQ/050 (Quoting)** — https://mywiki.wooledge.org/BashFAQ/050
- **BashGuide/Quotes** — https://mywiki.wooledge.org/BashGuide/Quotes
- **HashiCorp Vault** — https://www.vaultproject.io/
- **SOPS** — https://github.com/getsops/sops
- **Linux Capabilities** — `man 7 capabilities`
- **Google Shell Style Guide** — https://google.github.io/styleguide/shellguide.html

---

## **Modul 4.3: Interoperabilitas dengan Alat dan Bahasa Lain**

### **Tujuan Pembelajaran**

Setelah menyelesaikan modul ini, Anda mampu:

1. Memanggil REST API dengan `curl` dan `wget` secara aman.
2. Mem-parsing dan memanipulasi JSON dengan `jq` tingkat lanjut.
3. Memproses CSV, YAML, dan XML dengan alat yang tepat.
4. Memanggil Python/Perl/Ruby dari Bash dan menangkap hasilnya.
5. Mengintegrasikan dengan database (`psql`, `mysql`, `sqlite3`).
6. Menerapkan **retry**, **timeout**, **pagination**, dan **auth** pada API.
7. Menangani error dengan benar di semua lapisan.

### **Prasyarat**

- Modul 4.1 dan 4.2 selesai.
- Familiar dengan `jq`, `curl`, `awk` dasar.

---

### **1. Filosofi "Lem" (Glue Language)**

Shell adalah **lem** yang merekatkan alat-alat khusus. Ia tidak mencoba menjadi segalanya; ia mengorkestrasi.

**Pola pikir:**
- **Jangan tulis parser JSON di Bash** — gunakan `jq`.
- **Jangan tulis komputasi numerik di Bash** — gunakan `bc`, `awk`, atau Python.
- **Jangan tulis HTTP client di Bash** — gunakan `curl`.
- **Jangan tulis manipulasi CSV kompleks di Bash** — gunakan `csvkit` atau Python.

**Kekuatan Bash:** process management, file system, piping, orchestration.
**Kelemahan Bash:** data structures, numeric, string manipulation kompleks, error handling.

---

### **2. `curl` dan `wget` Tingkat Lanjut**

#### **2.1. Opsi `curl` Penting**

| Opsi | Fungsi |
|---|---|
| `-s` / `--silent` | Sembunyikan progress |
| `-S` / `--show-error` | Tampilkan error meski `-s` |
| `-f` / `--fail` | Exit 22 jika HTTP >= 400 |
| `-L` / `--location` | Ikuti redirect |
| `-o FILE` | Output ke file |
| `-O` | Output ke nama file dari URL |
| `-X METHOD` | HTTP method |
| `-H "K: V"` | Header |
| `-d DATA` | POST data |
| `--data-binary @file` | POST dari file |
| `--max-time N` | Timeout total |
| `--connect-timeout N` | Timeout koneksi |
| `--retry N` | Retry N kali |
| `--retry-delay N` | Delay antar retry |
| `--retry-connrefused` | Retry pada connection refused |
| `-u user:pass` | Basic auth |
| `-b COOKIE` | Kirim cookie |
| `-c FILE` | Simpan cookie |
| `--cacert FILE` | CA certificate kustom |
| `--cert FILE` | Client certificate |
| `-k` / `--insecure` | **Hindari** — matikan verifikasi TLS |
| `--compressed` | Minta kompresi |
| `-w FORMAT` | Tulis metadata (mis. `%{http_code}`) |

#### **2.2. Pola Aman `curl`**

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

api_get() {
  local url="$1"
  local response http_code body

  # Tulis body ke file sementara, http_code ke stdout
  local tmp
  tmp="$(mktemp)"
  trap 'rm -f -- "$tmp"' RETURN

  if ! http_code="$(curl -sS -L \
      --connect-timeout 5 \
      --max-time 30 \
      --retry 3 --retry-delay 2 --retry-connrefused \
      -o "$tmp" \
      -w '%{http_code}' \
      "$url")"; then
    echo "curl gagal: $url" >&2
    return 1
  fi

  if (( http_code >= 400 )); then
    echo "HTTP $http_code: $url" >&2
    return 1
  fi

  cat "$tmp"
}
```

**Poin penting:**
- `-w '%{http_code}'` memisahkan body dari status.
- `-o "$tmp"` mencegah body bercampur dengan status.
- `trap ... RETURN` membersihkan file setelah fungsi selesai.
- `--retry-connrefused` menangani server yang belum up.

#### **2.3. `wget`**

`wget` unggul untuk:
- **Download rekursif** (`-r`, `-np`, `-k`).
- **Mirror situs** (`-m`).
- **Resume download** (`-c`).
- **Rate limiting** (`--limit-rate=200k`).

```bash
# Download dengan retry dan timeout
wget --tries=3 --timeout=30 --waitretry=5 \
     -O /tmp/file.zip \
     "https://example.com/file.zip"

# Mirror
wget --mirror --convert-links --page-requisites --no-parent \
     https://example.com/docs/
```

#### **2.4. Latihan**

1. Tulis fungsi `api_post` yang mengirim JSON dengan header `Authorization: Bearer`.
2. Implementasikan exponential backoff untuk retry (1s, 2s, 4s, 8s).
3. Gunakan `-w` untuk mencatat waktu total dan ukuran response.

---

### **3. `jq` Tingkat Lanjut**

#### **3.1. Dasar**

```bash
echo '{"a": {"b": [1,2,3]}}' | jq '.a.b[1]'   # 2
```

#### **3.2. Filter Penting**

| Filter | Fungsi |
|---|---|
| `.key` | Akses key |
| `.[0]` | Index array |
| `.[]` | Iterasi array/object |
| `.[]?` | Iterasi, abaikan error |
| `keys` | Daftar key |
| `length` | Panjang |
| `type` | Tipe |
| `map(f)` | Transformasi array |
| `select(f)` | Filter |
| `sort_by(f)` | Sort |
| `group_by(f)` | Group |
| `unique` | Unik |
| `add` | Jumlahkan |
| `has("key")` | Cek key |
| `//` | Default jika null |
| `?` | Abaikan error |
| `..` | Rekursif |
| `paths` | Semua path |
| `to_entries` | Object → array of `{key, value}` |
| `from_entries` | Kebalikan |
| `@csv`, `@tsv`, `@json` | Format output |

#### **3.3. Contoh Praktis**

**a. Filter array:**
```bash
echo '[{"name":"a","age":30},{"name":"b","age":20}]' \
  | jq -r '.[] | select(.age > 25) | .name'
```

**b. Transformasi:**
```bash
echo '[1,2,3]' | jq 'map(. * 2)'
# [2,4,6]
```

**c. Group by:**
```bash
echo '[{"dept":"a","name":"x"},{"dept":"b","name":"y"},{"dept":"a","name":"z"}]' \
  | jq 'group_by(.dept) | map({dept: .[0].dept, count: length})'
```

**d. Konversi ke CSV:**
```bash
echo '[{"name":"a","age":30},{"name":"b","age":20}]' \
  | jq -r '.[] | [.name, .age] | @csv'
# "a",30
# "b",20
```

**e. Merge dua JSON:**
```bash
jq -s '.[0] * .[1]' file1.json file2.json
```

**f. Baca dari variabel:**
```bash
data='{"x":1}'
echo "$data" | jq '.x'
```

**g. Argumen dari shell:**
```bash
jq -n --arg name "Bob" --argjson age 30 '{name: $name, age: $age}'
```

**h. Exit status:**
```bash
jq -e '.x == 1' <<< '{"x":1}'   # exit 0 jika true
jq -e '.x == 2' <<< '{"x":1}'   # exit 1 jika false
```

**i. Try-catch:**
```bash
jq 'try .a.b catch "error"' <<< '{"a":1}'
```

#### **3.4. Latihan**

1. Dari array JSON user, ekstrak semua email yang domainnya `example.com`.
2. Konversi JSON ke CSV dengan header.
3. Gabungkan dua file JSON berdasarkan key `id`.
4. Hitung total nilai `amount` dari array transaksi.

---

### **4. CSV, YAML, dan XML**

#### **4.1. CSV dengan `awk`**

Untuk CSV sederhana (tanpa quoted fields):
```bash
awk -F',' 'NR>1 && $2 > 28 {print $1, $3}' users.csv
```

**Batasan:** `awk -F','` gagal jika ada koma di dalam quoted field.

#### **4.2. CSV dengan `csvkit`**

```bash
pip install csvkit

csvcut -c name,age users.csv          # Pilih kolom
csvgrep -c age -m 28 users.csv        # Filter baris
csvsql --query "SELECT * FROM users WHERE age > 28" users.csv
csvjson users.csv                     # Konversi ke JSON
csvstat users.csv                     # Statistik
```

#### **4.3. CSV dengan Python**

Untuk data kompleks:
```bash
python3 - <<'PY'
import csv, sys
with open('users.csv') as f:
    reader = csv.DictReader(f)
    for row in reader:
        if int(row['age']) > 28:
            print(row['name'], row['city'])
PY
```

#### **4.4. YAML dengan `yq`**

```bash
# Mike Farah's yq (Go)
yq '.services.web.image' docker-compose.yml
yq -i '.version = "3.9"' docker-compose.yml

# Kislyuk's yq (Python, wrapper jq)
yq -y '.a.b' file.yaml
```

#### **4.5. XML dengan `xmlstarlet`**

```bash
xmlstarlet sel -t -v '//book/title' books.xml
xmlstarlet ed -u '//book/price' -x '. * 1.1' books.xml
```

#### **4.6. Latihan**

1. Baca `users.csv` dengan quoted fields yang mengandung koma, proses dengan `csvkit`.
2. Konversi YAML ke JSON dengan `yq`.
3. Ekstrak semua atribut `id` dari file XML dengan `xmlstarlet`.

---

### **5. Memanggil Python/Perl/Ruby dari Bash**

#### **5.1. Pola Dasar**

**a. Inline dengan here-doc:**
```bash
result="$(python3 - <<'PY'
import json
print(json.dumps({"status": "ok", "value": 42}))
PY
)"
echo "$result" | jq .
```

**b. Skrip terpisah:**
```bash
# worker.py
#!/usr/bin/env python3
import sys, json
data = json.load(sys.stdin)
data['processed'] = True
print(json.dumps(data))

# Bash
echo '{"x":1}' | ./worker.py | jq .
```

**c. Argumen:**
```bash
python3 script.py --input data.json --output result.json
```

#### **5.2. Penanganan Error**

```bash
if ! output="$(python3 script.py 2>&1)"; then
  echo "Python gagal: $output" >&2
  exit 1
fi
```

**Perhatikan:** `2>&1` menggabungkan stderr ke stdout. Untuk memisahkan:
```bash
if ! output="$(python3 script.py 2>/tmp/err)"; then
  echo "Error: $(</tmp/err)" >&2
  exit 1
fi
```

#### **5.3. Contoh Lengkap: Skrip Cuaca (Diperbaiki)**

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

readonly API_KEY="${OPENWEATHER_API_KEY:?Environment OPENWEATHER_API_KEY harus di-set}"
readonly CITY="${1:-Jakarta}"
readonly UNITS="${UNITS:-metric}"
readonly API_URL="https://api.openweathermap.org/data/2.5/weather"

log() { printf '%s [%s] %s\n' "$(date -Is)" "$1" "${*:2}" >&2; }

# Ambil data — perhatikan: tidak pakai $? setelah assignment dengan set -e
if ! weather_json="$(curl -sS -f -L \
    --connect-timeout 5 \
    --max-time 15 \
    --retry 3 --retry-delay 2 --retry-connrefused \
    --get \
    --data-urlencode "q=$CITY" \
    --data-urlencode "units=$UNITS" \
    --data-urlencode "appid=$API_KEY" \
    "$API_URL")"; then
  log ERROR "Gagal mengambil data cuaca untuk $CITY"
  exit 1
fi

# Validasi JSON
if ! jq -e . >/dev/null 2>&1 <<<"$weather_json"; then
  log ERROR "Respons bukan JSON valid"
  exit 1
fi

# Ekstrak field dengan default
readonly TEMP="$(jq -r '.main.temp // "N/A"' <<<"$weather_json")"
readonly DESC="$(jq -r '.weather[0].description // "N/A"' <<<"$weather_json")"
readonly HUM="$(jq -r '.main.humidity // "N/A"' <<<"$weather_json")"
readonly NAME="$(jq -r '.name // "N/A"' <<<"$weather_json")"

if [[ "$NAME" == "N/A" ]]; then
  log ERROR "Kota tidak ditemukan: $CITY"
  exit 1
fi

cat <<EOF
--- Cuaca ${NAME} ---
Temperatur : ${TEMP}°C
Kondisi    : ${DESC}
Kelembaban : ${HUM}%
EOF
```

**Perbaikan dari versi sebelumnya:**
- `if ! var=$(cmd); then` — benar dengan `set -e`.
- API key dari environment, bukan hardcoded.
- `--data-urlencode` untuk escaping otomatis.
- Validasi JSON sebelum parsing.
- `<<<"$var"` menghindari `echo | jq` yang bisa bermasalah dengan string panjang.

#### **5.4. Latihan**

1. Tulis skrip yang memanggil Python untuk menghitung statistik dari file CSV.
2. Tangkap output JSON dari Ruby dan parsing dengan `jq`.
3. Implementasikan retry dengan exponential backoff untuk API call.

---

### **6. Integrasi Database**

#### **6.1. `psql` (PostgreSQL)**

```bash
# Koneksi via environment
export PGHOST=localhost PGPORT=5432 PGUSER=app PGPASSWORD="$DB_PASS" PGDATABASE=mydb

# Query
psql -tAc "SELECT id, name FROM users WHERE active = true" | while IFS='|' read -r id name; do
  echo "User $id: $name"
done

# Output CSV
psql -c "COPY (SELECT * FROM users) TO STDOUT WITH CSV HEADER"

# Output JSON
psql -tAc "SELECT json_agg(t) FROM (SELECT * FROM users) t" | jq .

# Jalankan file SQL
psql -f migration.sql
```

**Poin aman:**
- **Jangan interpolasi input pengguna ke SQL** — gunakan parameter.
  ```bash
  # BAHAYA
  psql -c "SELECT * FROM users WHERE name = '$name'"
  
  # AMAN — gunakan variabel psql
  psql -v name="$name" -c "SELECT * FROM users WHERE name = :'name'"
  ```
  `:'name'` melakukan escaping yang benar.

#### **6.2. `mysql` / `mariadb`**

```bash
mysql --batch --skip-column-names -e "SELECT id, name FROM users"
```

**File kredensial** `~/.my.cnf` dengan mode 0600:
```
[client]
user=app
password=secret
host=localhost
```

#### **6.3. `sqlite3`**

```bash
sqlite3 mydb.db "SELECT id, name FROM users" -separator '|'
sqlite3 -json mydb.db "SELECT * FROM users"
```

#### **6.4. Latihan**

1. Ekspor tabel PostgreSQL ke JSON, kirim via webhook.
2. Tulis skrip migrasi yang idempoten (cek apakah kolom sudah ada).
3. Gunakan `psql -v` untuk parameterisasi query.

---

### **7. Retry, Timeout, Pagination, Auth**

#### **7.1. Retry dengan Exponential Backoff**

```bash
retry_with_backoff() {
  local max_attempts="${1:-5}"
  local base_delay="${2:-1}"
  shift 2
  local attempt=1 delay

  while (( attempt <= max_attempts )); do
    if "$@"; then
      return 0
    fi
    if (( attempt == max_attempts )); then
      return 1
    fi
    delay=$(( base_delay * (2 ** (attempt - 1)) ))
    echo "Attempt $attempt gagal. Retry dalam ${delay}s..." >&2
    sleep "$delay"
    (( attempt++ ))
  done
}

retry_with_backoff 5 2 curl -fsSL https://api.example.com/data
```

#### **7.2. Timeout**

```bash
# Wrapper timeout standar
timeout 30 curl -fsSL https://api.example.com/data

# Timeout dengan signal
timeout -s TERM 30 long_running_command

# Untuk seluruh blok
timeout 60 bash -c '...'
```

#### **7.3. Pagination**

```bash
fetch_all_pages() {
  local url="$1"
  local page=1
  local all="[]"

  while :; do
    local response
    response="$(curl -fsSL "${url}?page=${page}&per_page=100")" || return 1
    local count
    count="$(jq 'length' <<<"$response")"
    (( count == 0 )) && break

    all="$(jq -s '.[0] + .[1]' <<<"$all" <<<"$response")"
    (( page++ ))
  done

  echo "$all"
}
```

#### **7.4. Auth**

```bash
# Bearer token
curl -fsSL -H "Authorization: Bearer $TOKEN" https://api.example.com/me

# Basic auth
curl -fsSL -u "$USER:$PASS" https://api.example.com/me

# API key di header
curl -fsSL -H "X-API-Key: $API_KEY" https://api.example.com/me

# OAuth2 refresh
TOKEN="$(curl -fsSL -X POST \
  -d "grant_type=refresh_token" \
  -d "refresh_token=$REFRESH" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  https://oauth.example.com/token | jq -r .access_token)"
```

#### **7.5. Latihan**

1. Implementasikan `retry_with_backoff` dengan jitter acak.
2. Buat fungsi `paginate` yang generik untuk API apa pun.
3. Implementasikan caching token OAuth2 dengan expiry.

---

### **8. Terminologi Kunci (Modul 4.3)**

- **API**: Application Programming Interface.
- **REST**: Arsitektur API berbasis HTTP.
- **JSON**: Format data ringan untuk pertukaran.
- **YAML**: Format data untuk konfigurasi.
- **CSV**: Format tabular sederhana.
- **Pagination**: Teknik membagi hasil besar menjadi halaman.
- **Exponential backoff**: Strategi retry dengan delay bertambah.
- **Idempotency key**: Kunci unik untuk mencegah duplikasi request.
- **OAuth2**: Protokol otorisasi.
- **Bearer token**: Token akses di header Authorization.

---

### **9. Kesalahan Umum & Solusi (Modul 4.3)**

| Kesalahan | Solusi |
|---|---|
| `curl` tanpa `-f` | Tambah `-f` untuk fail pada HTTP >= 400 |
| `curl` tanpa `-s` | Tambah `-s -S` |
| Parsing JSON dengan `grep`/`sed` | Gunakan `jq` |
| Parsing CSV dengan `cut` | Gunakan `awk -F,` atau `csvkit` |
| API key hardcoded | Environment/Vault |
| `if [[ $? -ne 0 ]]` setelah `set -e` | `if ! cmd; then` |
| Interpolasi SQL | Parameterized query |
| Tidak ada timeout | `--max-time`, `--connect-timeout` |
| Tidak ada retry | `--retry` atau fungsi retry |
| Python tanpa shebang | Tambah `#!/usr/bin/env python3` |
| Menjalankan `./script.py` | `python3 script.py` atau `chmod +x` + shebang |

---

### **10. Referensi (Modul 4.3)**

- **jq Manual** — https://jqlang.github.io/jq/manual/
- **Everything curl** — https://everything.curl.dev/
- **csvkit** — https://csvkit.readthedocs.io/
- **yq (Mike Farah)** — https://github.com/mikefarah/yq
- **xmlstarlet** — http://xmlstar.sourceforge.net/
- **GNU Wget Manual** — https://www.gnu.org/software/wget/manual/
- **OWASP API Security Top 10** — https://owasp.org/API-Security/
- **PostgreSQL psql** — https://www.postgresql.org/docs/current/app-psql.html
- **PostgREST** — https://postgrest.org/

---

## **Modul 4.4: Pengujian, Linting, dan CI/CD untuk Skrip Shell**

### **Tujuan Pembelajaran**

Setelah menyelesaikan modul ini, Anda mampu:

1. Menulis unit test untuk skrip Bash dengan `bats-core`.
2. Mengintegrasikan `shellcheck` dan `shfmt` dalam alur kerja.
3. Membangun pipeline CI/CD untuk skrip shell.
4. Menggunakan container untuk pengujian terisolasi.
5. Menerapkan semantic versioning dan release otomatis.

### **1. Mengapa Pengujian Penting**

Skrip shell sering dianggap "tidak perlu diuji". Ini berbahaya: skrip produksi yang salah bisa menghapus data, membocorkan rahasia, atau mematikan layanan. Pengujian memberi:

- **Kepercayaan** untuk refactor.
- **Dokumentasi** perilaku yang diharapkan.
- **Deteksi regresi** lebih awal.
- **Regression testing** sebelum deploy.

### **2. `bats-core` — Bash Automated Testing System**

#### **2.1. Instalasi**

```bash
# Git submodule
git submodule add https://github.com/bats-core/bats-core.git test/bats
git submodule add https://github.com/bats-core/bats-support.git test/test_helper/bats-support
git submodule add https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert

# Atau via npm
npm install -g bats

# Atau via apt
sudo apt install bats
```

#### **2.2. Contoh Test**

```bash
#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  TEST_DIR="$(mktemp -d)"
  export TEST_DIR
}

teardown() {
  rm -rf -- "$TEST_DIR"
}

@test "backup_enterprise.sh menolak sumber yang tidak ada" {
  run ./backup_enterprise.sh -s /nonexistent -d "$TEST_DIR"
  assert_failure
  assert_output --partial "Sumber tidak ditemukan"
}

@test "backup_enterprise.sh membuat arsip" {
  mkdir -p "$TEST_DIR/src"
  echo "data" > "$TEST_DIR/src/file.txt"
  run ./backup_enterprise.sh -s "$TEST_DIR/src" -d "$TEST_DIR/dst"
  assert_success
  [ -f "$TEST_DIR/dst/src_"*.tar.gz ]
}

@test "backup_enterprise.sh idempoten" {
  mkdir -p "$TEST_DIR/src"
  echo "data" > "$TEST_DIR/src/file.txt"
  run ./backup_enterprise.sh -s "$TEST_DIR/src" -d "$TEST_DIR/dst"
  assert_success
  local count1
  count1="$(find "$TEST_DIR/dst" -name '*.tar.gz' | wc -l)"
  run ./backup_enterprise.sh -s "$TEST_DIR/src" -d "$TEST_DIR/dst"
  assert_success
  local count2
  count2="$(find "$TEST_DIR/dst" -name '*.tar.gz' | wc -l)"
  [ "$count2" -eq $((count1 + 1)) ]  # dua arsip berbeda waktu
}
```

#### **2.3. Menjalankan**

```bash
bats test/
bats --tap test/
bats --jobs 4 test/
```

#### **2.4. Latihan**

1. Tulis test untuk `safe_grep` yang memverifikasi penolakan input berbahaya.
2. Test `retry_with_backoff` dengan mock perintah yang gagal 2 kali lalu sukses.
3. Test `should_alert` untuk memverifikasi anti-spam.

---

### **3. Linting dan Formatting**

#### **3.1. `shellcheck` di CI**

```yaml
# .github/workflows/lint.yml
name: Lint
on: [push, pull_request]
jobs:
  shellcheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run shellcheck
        uses: ludeeus/action-shellcheck@master
        with:
          severity: warning
```

#### **3.2. `shfmt` di CI**

```yaml
- name: Install shfmt
  run: |
    curl -sSL https://github.com/mvdan/sh/releases/download/v3.7.0/shfmt_v3.7.0_linux_amd64 \
      -o /usr/local/bin/shfmt
    chmod +x /usr/local/bin/shfmt
- name: Check formatting
  run: shfmt -d -i 2 -ci .
```

#### **3.3. `pre-commit`**

`.pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.10.0
    hooks:
      - id: shellcheck
        args: [-S, warning]
  - repo: https://github.com/scop/pre-commit-shfmt
    rev: v3.7.0-1
    hooks:
      - id: shfmt
        args: [-i, "2", -ci, -w]
```

Instalasi:
```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

---

### **4. CI/CD Pipeline Lengkap**

```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ludeeus/action-shellcheck@master
        with:
          severity: warning
      - name: shfmt
        run: |
          curl -sSL https://github.com/mvdan/sh/releases/download/v3.7.0/shfmt_v3.7.0_linux_amd64 -o /usr/local/bin/shfmt
          chmod +x /usr/local/bin/shfmt
          shfmt -d -i 2 -ci .

  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - name: Install bats
        run: |
          if [[ "$RUNNER_OS" == "Linux" ]]; then
            sudo apt-get install -y bats
          else
            brew install bats-core
          fi
      - name: Run tests
        run: bats --tap test/

  integration:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
    steps:
      - uses: actions/checkout@v4
      - name: Integration test
        env:
          PGPASSWORD: test
        run: ./test/integration.sh
```

---

### **5. Pengujian Terisolasi dengan Container**

```bash
#!/usr/bin/env bash
# test-in-docker.sh
set -Eeuo pipefail

docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  -e TEST_MODE=1 \
  ubuntu:22.04 \
  bash -c "apt-get update && apt-get install -y bats shellcheck && bats test/"
```

Manfaat:
- **Reproducible** — environment identik.
- **Isolasi** — tidak mengotori host.
- **Multi-distro** — test di Ubuntu, Debian, Alpine, CentOS.

---

### **6. Semantic Versioning dan Release**

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['v*']
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Create release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            bin/*
            LICENSE
```

**Konvensi:**
- `vMAJOR.MINOR.PATCH`
- `MAJOR` — breaking change.
- `MINOR` — fitur baru, backward compatible.
- `PATCH` — bug fix.

---

### **7. Latihan**

1. Buat test suite `bats` untuk skrip backup dan monitoring.
2. Konfigurasi GitHub Actions untuk lint + test di Ubuntu dan macOS.
3. Buat pipeline yang mem-build Docker image dengan skrip dan test di dalamnya.
4. Implementasikan release otomatis dengan tag Git.

---

### **8. Referensi (Modul 4.4)**

- **bats-core** — https://github.com/bats-core/bats-core
- **shellcheck** — https://www.shellcheck.net/
- **shfmt** — https://github.com/mvdan/sh
- **pre-commit** — https://pre-commit.com/
- **GitHub Actions** — https://docs.github.com/en/actions
- **Semantic Versioning** — https://semver.org/

---

## **Modul 4.5: Portabilitas, Debugging, dan Kinerja**

### **Tujuan Pembelajaran**

Setelah menyelesaikan modul ini, Anda mampu:

1. Menulis skrip yang portabel antara Linux, macOS, dan BSD.
2. Menggunakan teknik debugging lanjutan (`bash -x`, `trap DEBUG`, `PS4`).
3. Mengukur dan mengoptimalkan kinerja skrip.
4. Menggunakan `strace`, `time`, `hyperfine`, dan `parallel`.

### **1. Portabilitas**

#### **1.1. Perbedaan Shell**

| Shell | Path | Catatan |
|---|---|---|
| Bash 5 | `/bin/bash` | Standar Linux modern |
| Bash 3.2 | `/bin/bash` | macOS default (lawas) |
| Dash | `/bin/sh` | Debian/Ubuntu `/bin/sh` |
| Zsh | `/bin/zsh` | macOS default login shell |
| Ksh | `/bin/ksh` | AIX, Solaris |

**Shebang:**
```bash
#!/usr/bin/env bash   # Portabel, menggunakan bash dari PATH
```

**Jangan:**
```bash
#!/bin/bash           # Gagal di FreeBSD (bash di /usr/local/bin)
```

#### **1.2. Perbedaan GNU vs BSD**

| Perintah | GNU (Linux) | BSD (macOS) | Solusi |
|---|---|---|---|
| `sed -i` | `sed -i` | `sed -i ''` | Gunakan `sed -i.bak` lalu hapus, atau gunakan `perl -i` |
| `date -d` | Didukung | Tidak | Gunakan `date -j -f` di macOS, atau `gdate` |
| `readlink -f` | Didukung | Tidak (versi lama) | Gunakan `realpath` atau manual |
| `grep -P` | Didukung | Tidak | Gunakan `grep -E` |
| `tar --wildcards` | Didukung | Tidak | Gunakan `tar -x` dengan glob |
| `stat -c` | Didukung | `stat -f` | Deteksi via `uname` |
| `xargs -r` | Didukung | Tidak | Pipe melalui `if` atau gunakan `-0` |
| `find -maxdepth` | GNU & BSD | Didukung | OK |
| `mktemp -p` | GNU | BSD pakai `-t` | Gunakan template |

#### **1.3. Deteksi Platform**

```bash
detect_os() {
  case "$(uname -s)" in
    Linux*)  echo linux ;;
    Darwin*) echo macos ;;
    FreeBSD*) echo freebsd ;;
    *)       echo unknown ;;
  esac
}
readonly OS="$(detect_os)"

case "$OS" in
  linux)
    DATE_CMD="date -d"
    STAT_CMD="stat -c"
    ;;
  macos)
    DATE_CMD="gdate -d"   # brew install coreutils
    STAT_CMD="stat -f"
    ;;
  *)
    echo "OS tidak didukung: $OS" >&2
    exit 1
    ;;
esac
```

#### **1.4. Fitur Bash yang Tidak Portabel**

- **Array asosiatif** (`declare -A`) — Bash 4+. macOS Bash 3.2 tidak mendukung.
- **`mapfile`/`readarray`** — Bash 4+.
- **`${var,,}` / `${var^^}`** — Bash 4+.
- **`**` globstar** — perlu `shopt -s globstar`, Bash 4+.
- **`&>>`** — Bash 4+.
- **`|&`** — Bash 4+.

**Solusi untuk macOS Bash 3.2:**
- Gunakan `tr '[:upper:]' '[:lower:]'` alih-alih `${var,,}`.
- Gunakan `while read` alih-alih `mapfile`.
- Instal Bash 5 via Homebrew: `brew install bash`.

#### **1.5. Latihan**

1. Tulis skrip yang berjalan di Linux dan macOS, mendeteksi perbedaan `sed -i`.
2. Ganti `date -d "yesterday"` dengan alternatif portabel.
3. Uji skrip Anda di container Alpine (BusyBox `sh`).

---

### **2. Debugging Lanjutan**

#### **2.1. `bash -x`**

```bash
bash -x script.sh
```

Atau di dalam skrip:
```bash
set -x   # Aktifkan tracing
...
set +x   # Matikan
```

**`PS4` untuk tracing informatif:**
```bash
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
set -x
```

Output:
```
+ script.sh:10:main: echo hello
hello
```

#### **2.2. `trap DEBUG`**

```bash
trap 'echo "Line $LINENO: $BASH_COMMAND" >&2' DEBUG
```

Dijalankan sebelum **setiap** perintah. Sangat verbose tapi berguna untuk bug sulit.

#### **2.3. `trap ERR`**

```bash
trap 'echo "Error di $LINENO: $BASH_COMMAND (exit=$?)" >&2' ERR
```

Hanya dipicu saat perintah gagal.

#### **2.4. `set -v`**

Menampilkan baris yang dibaca (sebelum ekspansi). Berguna untuk memverifikasi parsing.

#### **2.5. `shellcheck` sebagai Debugger**

`shellcheck` mendeteksi banyak bug sebelum runtime. Jalankan selalu.

#### **2.6. `bashdb`**

Debugger interaktif untuk Bash:
```bash
bashdb script.sh
```
Perintah: `next`, `step`, `break`, `print`, `continue`.

#### **2.7. Teknik Debugging Praktis**

**a. Echo ke stderr:**
```bash
echo "DEBUG: var=$var" >&2
```

**b. Fungsi debug:**
```bash
debug() {
  [[ "${DEBUG:-0}" == "1" ]] || return 0
  echo "DEBUG: $*" >&2
}
debug "Nilai x=$x"
```

**c. Isolasi masalah:**
- Komentari bagian yang mencurigakan.
- Jalankan dengan `bash -x` dan perhatikan baris terakhir sebelum error.
- Gunakan `set -e` untuk fail-fast.

#### **2.8. Latihan**

1. Aktifkan `PS4` yang menampilkan file, baris, dan fungsi.
2. Gunakan `trap DEBUG` untuk melacak eksekusi skrip backup.
3. Debug skrip yang gagal dengan `set -e` dan temukan baris penyebabnya.

---

### **3. Kinerja**

#### **3.1. Mengukur Waktu**

```bash
time script.sh

# Lebih akurat
hyperfine './script.sh'
hyperfine --warmup 3 --runs 10 './script.sh'
```

#### **3.2. Bottleneck Umum**

| Bottleneck | Solusi |
|---|---|
| Subshell dalam loop | Hindari `$(...)` di dalam loop besar |
| Fork per iterasi | Gunakan builtin Bash |
| `grep`/`sed`/`awk` berulang | Gabungkan dengan satu `awk` |
| Baca file per baris dengan `cat` | Gunakan `while read < file` |
| `find` + `xargs` serial | `xargs -P` untuk paralel |
| String concatenation besar | Gunakan array lalu `printf` |

#### **3.3. Contoh Optimasi**

**Lambat:**
```bash
for i in $(seq 1 100000); do
  result=$(echo "$i" | awk '{print $1 * 2}')
  echo "$result"
done
```

**Cepat:**
```bash
awk 'BEGIN { for (i=1; i<=100000; i++) print i*2 }'
```

**Lambat:**
```bash
while read -r line; do
  echo "$line" | grep "error"
done < huge.log
```

**Cepat:**
```bash
grep "error" huge.log
```

#### **3.4. Paralelisasi dengan `xargs -P`**

```bash
find . -type f -name '*.log' -print0 \
  | xargs -0 -n 1 -P "$(nproc)" gzip
```

#### **3.5. GNU `parallel`**

```bash
parallel -j 8 'gzip {}' ::: *.log

# Dengan progress
parallel --bar -j 8 'process {}' ::: *.dat
```

#### **3.6. `coproc` untuk Komunikasi Dua Arah**

```bash
coproc MYPROC { bc -l; }
echo "2+2" >&"${MYPROC[1]}"
read -r result <&"${MYPROC[0]}"
echo "Hasil: $result"   # 4
```

#### **3.7. Profiling dengan `strace`**

```bash
strace -c -f script.sh
```

Menampilkan syscall yang paling banyak memakan waktu.

#### **3.8. Latihan**

1. Optimalkan loop yang memanggil `grep` per baris menjadi satu `grep`.
2. Gunakan `xargs -P` untuk memproses 1000 file secara paralel.
3. Ukur waktu sebelum dan sesudah optimasi dengan `hyperfine`.
4. Gunakan `strace -c` untuk menemukan syscall terbanyak di skrip.

---

### **4. Referensi (Modul 4.5)**

- **Bash Pitfalls** — https://mywiki.wooledge.org/BashPitfalls
- **BashFAQ** — https://mywiki.wooledge.org/BashFAQ
- **hyperfine** — https://github.com/sharkdp/hyperfine
- **GNU parallel** — https://www.gnu.org/software/parallel/
- **bashdb** — https://bashdb.sourceforge.net/
- **Portable Shell Programming** — https://www.gnu.org/software/autoconf/manual/autoconf.html

---

## **Proyek Akhir Fase 4**

### **Deskripsi**

Bangun **sistem backup + monitoring + notifikasi** yang lengkap, aman, dan teruji untuk aplikasi web fiktif `myapp`.

### **Kebutuhan Fungsional**

1. **Backup harian** direktori `/var/www/myapp` dan database PostgreSQL `myapp_db`.
2. **Enkripsi** backup dengan GPG sebelum upload.
3. **Upload** ke remote (S3 atau rsync ke server lain).
4. **Rotasi** backup lokal (7 hari) dan remote (30 hari).
5. **Monitoring** CPU, memory, disk, dan service `nginx`, `postgresql`, `myapp`.
6. **Notifikasi** ke Slack webhook saat threshold terlampaui atau backup gagal.
7. **State file** untuk mencegah alert berulang.
8. **Logging** terstruktur ke systemd journal.
9. **Idempoten** — dapat dijalankan ulang tanpa efek samping.
10. **Aman** — least privilege, tidak ada rahasia di kode.

### **Kebutuhan Non-Fungsional**

1. **Testing** dengan `bats` untuk minimal 10 skenario.
2. **Linting** dengan `shellcheck` (0 warning).
3. **Formatting** dengan `shfmt`.
4. **CI/CD** di GitHub Actions: lint, test di Ubuntu + macOS.
5. **Dokumentasi** README dengan contoh penggunaan, instalasi, dan troubleshooting.
6. **Portabilitas** Linux (Ubuntu 22.04) dan macOS (Ventura).

### **Deliverable**

1. Repositori Git dengan struktur:
   ```
   myapp-ops/
   ├── bin/
   │   ├── backup.sh
   │   ├── monitor.sh
   │   └── lib/
   │       ├── common.sh
   │       └── notify.sh
   ├── systemd/
   │   ├── myapp-backup.service
   │   ├── myapp-backup.timer
   │   ├── myapp-monitor.service
   │   └── myapp-monitor.timer
   ├── test/
   │   ├── backup.bats
   │   └── monitor.bats
   ├── .github/workflows/ci.yml
   ├── .pre-commit-config.yaml
   ├── .shellcheckrc
   ├── README.md
   └── LICENSE
   ```

2. **README** yang menjelaskan:
   - Arsitektur sistem.
   - Cara instalasi.
   - Cara konfigurasi (environment variables).
   - Cara menjalankan test.
   - Cara deploy.
   - Troubleshooting.

3. **Demo** — video atau dokumentasi langkah demi langkah menjalankan sistem di VM.

### **Kriteria Penilaian**

| Kriteria | Bobot |
|---|---|
| Fungsionalitas | 30% |
| Keamanan | 20% |
| Pengujian | 15% |
| Portabilitas | 10% |
| Dokumentasi | 10% |
| Idempotensi | 10% |
| Kode bersih (lint pass) | 5% |

### **Tips**

- Mulai dari `lib/common.sh` untuk fungsi bersama (logging, config, error handling).
- Tulis test **sebelum** atau **bersamaan** dengan implementasi.
- Gunakan `shellcheck` setiap kali menyimpan file.
- Uji di container Ubuntu 22.04 dan Alpine untuk memastikan portabilitas.
- Dokumentasikan asumsi dan keputusan desain.

---

## **Penutup**

Anda telah menyelesaikan **Fase 4: Pakar – Aplikasi Skala Enterprise dan Keamanan**. Dengan materi yang telah diperluas ini, Anda kini memiliki:

1. **Pemahaman mendalam** tentang otomatisasi, keamanan, interoperabilitas, pengujian, dan kinerja.
2. **Keterampilan praktis** untuk membangun sistem backup, monitoring, dan integrasi API tingkat enterprise.
3. **Alat dan teknik** untuk menulis skrip yang aman, idempoten, portabel, dan teruji.
4. **Kesadaran keamanan** untuk mengidentifikasi dan mencegah kerentanan umum.
5. **Kemampuan operasional** untuk mendeploy skrip dengan systemd, CI/CD, dan container.

### **Langkah Selanjutnya**

- **Kontribusi open source** — cari proyek Bash di GitHub, perbaiki bug, tambahkan test.
- **Spesialisasi** — pilih domain: SRE, DevOps, security automation, cloud engineering.
- **Bahasa pelengkap** — pelajari Python atau Go untuk tugas yang lebih kompleks.
- **Infrastructure as Code** — pelajari Ansible, Terraform, Kubernetes.
- **Continuous learning** — ikuti r/linuxadmin, r/devops, dan konferensi seperti FOSDEM, KubeCon.

### **Kutipan Penutup**

> *"Simplicity is prerequisite for reliability."* — Edsger W. Dijkstra
>
> *"Make it work, make it right, make it fast."* — Kent Beck
>
> *"The most dangerous phrase in the language is: 'We've always done it this way.'"* — Grace Hopper

Selamat berkarya. Semoga skrip Anda selalu **aman**, **idempoten**, dan **teruji**.

---

<!----------------------------------------------------->


> * **[Ke Atas](#fase-4-pakar--aplikasi-skala-enterprise-dan-keamanan-tingkat-pakar)**
> * **[Selanjutnya][selanjutnya]**
> * **[Sebelumnya][sebelumnya]**
> * **[Kurikulum][kurikulum]**
> * **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[1]: ../README.md#fase-4-pakar--aplikasi-skala-enterprise-dan-keamanan-tingkat-pakar
