# Kurikulum  Fase 2
### Audit 
Sebelum masuk ke materi, ada beberapa hal teknis yang perlu dicatat dari struktur kurikulum yang Anda berikan. Audit ini tidak untuk dijawab seluruhnya, melainkan untuk memastikan fondasi materi yang akan dibangun tidak salah arah.

**Temuan audit:**

1. **Modul 2.1 menyebut `Keys.onPressed` dan merujuk ke Modul 2.5.** Ini benar secara struktural, tetapi ada potensi kebingungan: Modul 2.1 membahas *mode fokus keyboard pada layer-shell* (tingkat protokol Wayland), sedangkan Modul 2.5 membahas *rantai fokus QML* (tingkat toolkit). Keduanya berbeda lapisan abstraksi. Materi 2.1 harus secara eksplisit memisahkan “fokus di tingkat compositor” dari “fokus di tingkat QML” agar tidak tumpang tindih secara membingungkan.

2. **`exclusionMode` disebut sebagai “biasanya mengatur ruang yang dipesan secara otomatis dari tinggi dan anchor.”** Ini kurang tepat secara teknis. `ExclusionMode.Auto` *mencoba* menghitung zona eksklusif berdasarkan dimensi dan anchor, tetapi hanya berhasil optimal jika **tepat tiga anchor** terhubung (misalnya `top: true; left: true; right: true`). Jika anchor tidak lengkap, perilakunya bisa tidak seperti yang diharapkan. Ini perlu diklarifikasi.

3. **Peringatan “`Exclusive` bukan mekanisme kunci sesi yang aman”** sangat penting dan sudah benar. Namun, kurikulum belum menyebutkan **mengapa** secara teknis: `zwlr_layer_shell_v1` tidak memiliki mekanisme autentikasi atau isolasi input tingkat sesi. `WlSessionLock` (protokol `ext-session-lock-v1`) adalah mekanisme yang dirancang khusus untuk itu. Ini akan dijelaskan di Modul 2.1.

4. **Tidak ada modul yang secara eksplisit membahas `zwlr_layer_shell_v1` sebagai protokol Wayland** (hanya disebut sebagai istilah). Padahal, memahami protokol di tingkat Wayland—bukan hanya API Quickshell—sangat penting untuk debugging dan untuk memahami *mengapa* batasan tertentu ada. Materi 2.1 akan menambahkan lapisan penjelasan protokol ini sebagai **materi tambahan** yang tetap mengacu pada kurikulum.

5. **Transparansi dan blur** disebut sebagai bagian dari Modul 2.1, tetapi mekanismenya bergantung pada compositor (Hyprland menggunakan `layerrule` dengan `namespace`). Kurikulum sudah menyinggung `namespace`, tetapi belum menjelaskan hubungan sebab-akibat antara `namespace` di Quickshell dan aturan blur di compositor. Ini akan dijembatani.

Dengan catatan ini, saya akan membangun materi Modul 2.1 selengkap mungkin, mencakup hal-hal yang sudah ada di kurikulum maupun yang belum tetapi esensial.

---

# Modul 2.1 — Wayland Layer-Shell, Fokus Keyboard, dan Transparansi

> *“Layar adalah kanvas; layer-shell adalah cara Anda memesan tempat di atasnya tanpa harus berebut dengan jendela lain.”*

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Arsitektur Wayland dan peran compositor** — mengapa layer-shell ada, dan apa yang dilakukan compositor terhadapnya.
2. **Protokol `zwlr_layer_shell_v1`** — apa yang sebenarnya dikirim klien ke compositor (materi tambahan).
3. **Layer, anchor, dan `exclusionMode`** — cara memesan ruang dan mengapa `Auto` membutuhkan tiga anchor.
4. **Fokus keyboard layer-surface** — `None`, `OnDemand`, `Exclusive`; mengapa `Exclusive` bukan lockscreen.
5. **`PanelWindow` vs `FloatingWindow` vs `PopupWindow`** — kapan memakai yang mana.
6. **Transparansi dan aturan layer compositor (blur)** — bagaimana `namespace` menghubungkan Quickshell ke Hyprland.
7. **Debugging dengan `wayland-info` dan `hyprctl layers`**.
8. **Praktik terbaik, kesalahan umum, dan latihan**.

---

## 1. Arsitektur Wayland dan Peran Compositor

### Deskripsi Konkret & Peran dalam Kurikulum

Di Wayland, **compositor adalah pusat segalanya**. Berbeda dari X11 di mana aplikasi bisa menggambar langsung ke layar dan saling menimpa sesuka hati, Wayland memaksa setiap aplikasi untuk “menyerahkan” permukaannya (`wl_surface`) kepada compositor. Compositor-lah yang memutuskan **di mana** permukaan itu muncul, **kapan** ia terlihat, dan **apakah** ia menerima input.

Layer-shell adalah **protokol ekstensi** yang memberi klien cara untuk mengatakan kepada compositor: “Saya bukan jendela biasa. Saya ingin menempel di tepi layar, berada di lapisan tertentu, dan memesan ruang agar jendela lain tidak menimpa saya.” Tanpa layer-shell, panel dan bar Wayland tidak punya cara standar untuk mendeklarasikan niat tersebut.

**Mengapa ini penting dalam kurikulum:** Seluruh Modul 2.1—dan sebagian besar shell yang akan Anda bangun—berdiri di atas premis bahwa Anda dapat menempatkan UI Anda di lapisan yang tepat tanpa harus menjadi window manager. Memahami peran compositor mencegah Anda menganggap layer-shell sebagai “API ajaib” dan membantu Anda men-debug ketika perilakunya tidak sesuai harapan.

### Konsep Kunci & Filosofi

**Filosofi Wayland: compositor sebagai otoritas tunggal.** Di X11, siapa pun bisa menjadi window manager, dan aplikasi bisa “curang” dengan menggambar di atas segalanya. Di Wayland, compositor adalah satu-satunya yang memegang kendali atas tampilan dan input. Layer-shell tidak melanggar prinsip ini; ia **memperluas** negosiasi antara klien dan compositor.

**Analogi:** Bayangkan compositor sebagai seorang manajer gedung. Setiap penyewa (aplikasi) tidak boleh menaruh barang di lorong sesuka hati. Layer-shell adalah formulir resmi yang memungkinkan penyewa memesan “etalaase di lantai dasar” atau “papan nama di atap”—tetapi manajer gedung (compositor) tetap yang memutuskan apakah permintaan itu dikabulkan dan bagaimana bentuk akhirnya.

**Konsekuensi praktis:** Klien layer-shell **tidak bisa** memaksa dirinya selalu di atas. Ia hanya *meminta* lapisan (`layer`), *anchor* (titik tempel), dan *zona eksklusif*. Compositor dapat mengabaikan atau menyesuaikan permintaan itu. Inilah sebabnya Anda perlu alat debugging di tingkat compositor (`hyprctl layers`), bukan hanya di tingkat Quickshell.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Wayland

PanelWindow {
    anchors { top: true; left: true; right: true }
    implicitHeight: 30
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: 'my-shell-bar'
}
```

**Penjelasan kata-per-kata:**

- `PanelWindow`: tipe jendela Quickshell yang secara desain “tanpa dekorasi” dan ditempelkan ke tepi layar. Di Wayland, `PanelWindow` **dipetakan** ke `WlrLayershell` (lihat baris 3–9 pada dokumentasi WlrLayershell: “WlrLayershell works as an attached object of PanelWindow which you should use instead if you can, as it is platform independent”). Artinya, Anda sebaiknya menggunakan `PanelWindow` dan mengatur properti layer-shell melalui *attached object* `WlrLayershell`, bukan membuat `WlrLayershell` secara langsung.
- `anchors { top: true; left: true; right: true }`: menempelkan panel ke tiga sisi: atas, kiri, kanan. Tiga anchor ini penting untuk `ExclusionMode.Auto` (dibahas nanti).
- `implicitHeight: 30`: tinggi yang diinginkan. Karena kiri dan kanan ter-anchor, lebar akan mengikuti lebar layar; tinggi tetap 30 piksel.
- `WlrLayershell.layer: WlrLayer.Top`: meminta compositor menempatkan permukaan ini di lapisan `Top`. `WlrLayer.Top` “usually renders over normal windows and below fullscreen windows”. Ini adalah lapisan yang tepat untuk bar/panel.
- `WlrLayershell.namespace: 'my-shell-bar'`: **nama yang dapat dikenali oleh compositor**. Ini bukan sekadar label; compositor seperti Hyprland dapat mencocokkan `namespace` ini dengan aturan layer (`layerrule`) untuk blur, animasi, atau perilaku khusus.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Tipe Quickshell | Lapisan Wayland |
|---|---|---|
| Bar/panel yang menempel di tepi | `PanelWindow` + `WlrLayershell` | `Top` |
| Overlay (launcher, notifikasi) | `PanelWindow` + `WlrLayershell` | `Overlay` |
| Widget desktop (di bawah jendela) | `PanelWindow` + `WlrLayershell` | `Bottom` |
| Wallpaper | `PanelWindow` + `WlrLayershell` | `Background` |
| Jendela biasa (seperti aplikasi) | `FloatingWindow` | Tidak memakai layer-shell |

### Visualisasi: Posisi Layer terhadap Compositor

```text
┌──────────────────────────────────────────────┐
│                 COMPOSITOR                   │
│  (Hyprland / Sway / dll.)                    │
│                                              │
│  ┌────────────────────────────────────────┐  │
│  │  LAYER: Overlay                        │  │  ← notifikasi, launcher
│  │  ┌──────────────────────────────────┐  │  │
│  │  │  LAYER: Top                      │  │  │  ← bar/panel Anda
│  │  │  ┌────────────────────────────┐  │  │  │
│  │  │  │  Jendela aplikasi biasa    │  │  │  │  (di bawah Top)
│  │  │  │  (toplevel)                │  │  │  │
│  │  │  └────────────────────────────┘  │  │  │
│  │  │  LAYER: Bottom                   │  │  │  ← widget desktop
│  │  │  LAYER: Background               │  │  │  ← wallpaper
│  │  └──────────────────────────────────┘  │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  Compositor memutuskan urutan akhir,         │
│  bukan klien.                                │
└──────────────────────────────────────────────┘
```

**Penjelasan diagram:** Setiap kotak adalah lapisan (`layer`) dalam ruang compositor. Klien layer-shell “meminta” lapisan, tetapi compositor yang menyusun urutan akhir. `Overlay` berada di atas segalanya (bahkan di atas fullscreen window, menurut dokumentasi `WlrLayer`: “Overlay Usually renders over fullscreen windows”). `Top` adalah tempat panel; jendela aplikasi biasa berada di bawah `Top`. `Bottom` berada di bawah jendela, `Background` paling bawah.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **Compositor** | Program yang mengelola tampilan dan input di Wayland. Ia menggabungkan permukaan klien menjadi gambar akhir dan meneruskan event input. |
| **`wl_surface`** | Objek dasar Wayland yang mewakili “permukaan gambar” milik klien. Layer-shell memberi *peran* (`role`) khusus pada `wl_surface`. |
| **Layer-shell** | Protokol ekstensi (`zwlr_layer_shell_v1`) yang memungkinkan klien membuat permukaan yang ditempelkan ke tepi layar dan ditempatkan di lapisan tertentu. |
| **Toplevel** | Jendela “biasa” yang dikelola window manager/compositor (misalnya jendela browser). |
| **Attached object** | Dalam QML, objek yang propertinya “menempel” pada objek induk. `WlrLayershell` adalah attached object dari `PanelWindow`. |

### Hubungan dengan Modul Lain

- **Prasyarat untuk Modul 2.5:** Mode fokus layer-shell (dibahas di bagian berikutnya) adalah lapisan Wayland dari konsep fokus QML yang akan Anda pelajari di Modul 2.5. Tanpa memahami `WlrKeyboardFocus`, Anda tidak akan bisa mendesain launcher yang benar-benar menerima ketikan.
- **Terkait Modul 2.2:** `namespace` yang Anda atur di sini dapat dicocokkan dengan aturan compositor, dan nantinya Anda akan mengirim perintah ke compositor melalui IPC—termasuk perintah yang memengaruhi layer (misalnya menutup overlay).

### Sumber Referensi

- Quickshell — `WlrLayershell`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Wayland/WlrLayershell/
- Quickshell — `WlrLayer`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Wayland/WlrLayer/
- Wayland.app — `wlr-layer-shell-unstable-v1`: https://wayland.app/protocols/wlr-layer-shell-unstable-v1
- Dokumentasi wlroots `wlr_layer_shell_v1.h`: https://wlroots.pages.freedesktop.org/wlr/types/wlr_layer_shell_v1_8h.html

### Tips dan Praktik Terbaik

- **Selalu gunakan `PanelWindow` + `WlrLayershell` sebagai attached object**, bukan `WlrLayershell` langsung, kecuali Anda benar-benar membutuhkan kontrol platform-spesifik. Dokumentasi Quickshell secara eksplisit menyarankan ini: “WlrLayershell works as an attached object of PanelWindow which you should use instead if you can, as it is platform independent”.
- **Beri `namespace` yang deskriptif dan unik** untuk setiap permukaan (misalnya `my-shell-bar`, `my-shell-launcher`). Ini akan memudahkan aturan compositor dan debugging.
- **Jangan mengandalkan layer sebagai jaminan keamanan.** Compositor dapat mengabaikan permintaan layer jika ada kebijakan lain (misalnya fullscreen window yang meminta berada di atas `Top`).

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Membuat `WlrLayershell` langsung sebagai tipe root | Properti tidak berfungsi atau tidak portabel | Gunakan `PanelWindow` dan atur `WlrLayershell.*` sebagai attached property. |
| Mengatur `namespace` setelah jendela terkoneksi | Error atau namespace tidak berubah | Dokumentasi menyatakan `namespace` “Cannot be set after `windowConnected`”. Atur sebelum jendela tampil. |
| Mengira `WlrLayer.Top` selalu di atas jendela fullscreen | Panel tertutup fullscreen | Gunakan `Overlay` jika Anda benar-benar perlu di atas fullscreen, tetapi ingat bahwa itu bisa mengganggu. |

---

## 2. Protokol `zwlr_layer_shell_v1` (Materi Tambahan)

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak secara eksplisit** ada di kurikulum sebagai sub-bab, tetapi sangat penting untuk memahami *mengapa* API Quickshell berbentuk seperti sekarang. `zwlr_layer_shell_v1` adalah protokol Wayland yang mendefinisikan bagaimana klien meminta peran layer-surface, mengatur anchor, zona eksklusif, dan fokus keyboard.

**Mengapa ini ditambahkan:** Tanpa memahami protokolnya, Anda akan menganggap `exclusionMode` dan `WlrKeyboardFocus` sebagai “sihir” yang tidak bisa di-debug. Dengan memahami protokolnya, Anda tahu bahwa `exclusionMode: Auto` hanyalah pembungkus dari permintaan `set_exclusive_zone` ke compositor, dan bahwa `WlrKeyboardFocus.Exclusive` adalah permintaan `set_keyboard_interactivity` dengan nilai `exclusive`.

### Konsep Kunci & Filosofi

Protokol layer-shell mendefinisikan beberapa **request** utama dari klien ke compositor:

- `get_layer_surface`: membuat objek `zwlr_layer_surface_v1` dari `wl_surface`.
- `set_layer`: memilih lapisan (`background`, `bottom`, `top`, `overlay`).
- `set_anchor`: menempelkan ke tepi (`top`, `bottom`, `left`, `right`).
- `set_exclusive_zone`: memesan ruang (dalam piksel) agar jendela lain tidak menimpa.
- `set_keyboard_interactivity`: menentukan tingkat fokus keyboard (`none`, `exclusive`, `on_demand`).
- `set_namespace`: memberi nama pada permukaan (digunakan compositor untuk aturan).

Quickshell membungkus request-request ini menjadi properti QML yang nyaman. Memahami pemetaan ini membantu Anda men-debug ketika, misalnya, `exclusionMode: Auto` tidak memesan ruang seperti yang diharapkan—Anda bisa memeriksa apakah anchor sudah tepat tiga.

### Sintaks Dasar / Contoh Implementasi

Contoh permintaan protokol (disederhanakan, bukan kode QML):

```text
zwlr_layer_shell_v1.get_layer_surface(surface, output, layer_top, "my-shell-bar")
  → zwlr_layer_surface_v1
zwlr_layer_surface_v1.set_anchor(TOP | LEFT | RIGHT)
zwlr_layer_surface_v1.set_exclusive_zone(30)
zwlr_layer_surface_v1.set_keyboard_interactivity(NONE)
zwlr_layer_surface_v1.set_size(0, 30)   // 0 = biarkan compositor menentukan lebar
```

**Penjelasan:** Klien meminta permukaan layer dengan nama `my-shell-bar`, menempelkannya ke atas-kiri-kanan, memesan zona eksklusif 30 piksel, dan menyatakan bahwa permukaan ini tidak boleh menerima fokus keyboard. Inilah yang terjadi di balik layar ketika Anda menulis `PanelWindow { anchors { top: true; left: true; right: true }; implicitHeight: 30; WlrLayershell.layer: WlrLayer.Top; WlrLayershell.keyboardFocus: WlrKeyboardFocus.None }`.

### Visualisasi: Alur Permintaan Layer-Surface

```text
Klien (Quickshell)                 Compositor (Hyprland/Sway)
       │                                   │
       │  get_layer_surface(surface,       │
       │    layer=top, namespace="bar")    │
       │──────────────────────────────────>│
       │                                   │  memvalidasi permintaan
       │  set_anchor(TOP|LEFT|RIGHT)       │
       │──────────────────────────────────>│
       │  set_exclusive_zone(30)           │
       │──────────────────────────────────>│
       │  set_keyboard_interactivity(NONE) │
       │──────────────────────────────────>│
       │                                   │
       │  commit()                         │
       │──────────────────────────────────>│
       │                                   │  menempatkan permukaan
       │<──────────────────────────────────│  configure(lebar, tinggi)
       │                                   │
```

**Penjelasan diagram:** Klien mengirim serangkaian request. Compositor memvalidasi dan mengonfigurasi permukaan. Klien kemudian meng-commit permukaan dan menunggu event `configure` yang memberi tahu ukuran final. Proses ini menjelaskan mengapa perubahan properti layer-shell kadang tidak langsung terlihat—perlu siklus commit/configure.

### Terminologi Esensial

- **Request:** pesan dari klien ke compositor dalam protokol Wayland.
- **Event:** pesan dari compositor ke klien.
- **Commit:** tindakan klien mengirimkan perubahan state permukaan ke compositor.
- **Configure:** event dari compositor yang memberi tahu klien ukuran/keadaan final permukaan.
- **`set_exclusive_zone`:** request untuk memesan ruang; nilainya dalam piksel, dan `0` berarti tidak memesan ruang.

### Hubungan dengan Modul Lain

- **Modul 2.2 (IPC Compositor):** Protokol layer-shell adalah “jalur data” dari klien ke compositor. IPC (Hyprland socket) adalah “jalur perintah” dari shell ke compositor. Keduanya melengkapi: layer-shell untuk menempatkan UI, IPC untuk mengendalikan compositor.
- **Modul 2.5 (Fokus Keyboard):** `set_keyboard_interactivity` adalah dasar dari `WlrKeyboardFocus` yang akan Anda gunakan untuk launcher.

### Sumber Referensi

- Spesifikasi `wlr-layer-shell-unstable-v1` (XML): https://code.hyprland.org/hyprwm/hyprland/src/branch/main/protocols/wlr-layer-shell-unstable-v1.xml
- Dokumentasi wlroots: https://wlroots.pages.freedesktop.org/wlr/types/wlr_layer_shell_v1_8h.html

### Tips dan Praktik Terbaik

- **Gunakan `set_size(0, tinggi)` untuk panel yang lebarnya mengikuti layar.** Nilai `0` pada dimensi berarti “biarkan compositor menentukan” berdasarkan anchor.
- **Pesan zona eksklusif hanya jika Anda benar-benar ingin jendela lain menghindari area tersebut.** Overlay yang muncul sementara (seperti launcher) biasanya **tidak** boleh memesan zona eksklusif, karena akan menggeser jendela lain secara tidak perlu.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Memesan zona eksklusif pada overlay sementara | Jendela lain bergeser saat launcher muncul | Gunakan `exclusionMode: ExclusionMode.Ignore` atau jangan set zona eksklusif. |
| Tidak meng-commit setelah mengubah properti | Perubahan tidak terlihat | Pastikan perubahan dilakukan sebelum commit; di Quickshell, ini ditangani oleh framework, tetapi perubahan setelah `windowConnected` bisa bermasalah. |

---

## 3. Layer, Anchor, dan `exclusionMode`

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini adalah inti dari Modul 2.1: bagaimana Anda menempatkan permukaan di lapisan yang benar, menempelkannya ke tepi layar, dan memesan ruang agar tidak bertabrakan dengan jendela lain. `exclusionMode` adalah mekanisme Quickshell untuk mengatur zona eksklusif secara deklaratif.

**Mengapa penting:** Bar yang tidak memesan ruang akan ditimpa oleh jendela fullscreen atau jendela yang di-maximize. Panel yang salah lapisan akan muncul di bawah wallpaper atau di atas notifikasi. Memahami anchor dan `exclusionMode` adalah keterampilan dasar untuk semua shell yang akan Anda bangun.

### Konsep Kunci & Filosofi

**Layer** menentukan “tingkat ketinggian” permukaan relatif terhadap permukaan lain. Ada empat lapisan:

- `Background`: paling bawah, di bawah `Bottom`.
- `Bottom`: di atas background, biasanya di bawah jendela.
- `Top`: biasanya di atas jendela normal dan di bawah fullscreen window.
- `Overlay`: biasanya di atas fullscreen window.

**Anchor** menentukan ke tepi mana permukaan ditempelkan. Anchor adalah kombinasi dari `top`, `bottom`, `left`, `right`. Perilaku dimensi bergantung pada anchor:

- Jika hanya satu anchor vertikal (misalnya `top`), tinggi permukaan adalah `implicitHeight`.
- Jika dua anchor berlawanan (misalnya `top` dan `bottom`), tinggi dipaksa mengikuti tinggi layar (dikurangi margin).
- Jika tiga anchor (misalnya `top`, `left`, `right`), lebar mengikuti layar, tinggi tetap `implicitHeight`.

**`exclusionMode`** adalah properti Quickshell yang mengatur bagaimana zona eksklusif dihitung:

- `ExclusionMode.Normal`: “Respect the exclusion zone of other shell layers and optionally set one”. Anda harus menentukan `exclusiveZone` secara eksplisit.
- `ExclusionMode.Ignore`: “Ignore exclusion zones of other shell layers. You cannot set an exclusion zone in this mode”. Permukaan tidak memesan ruang dan mengabaikan zona eksklusif permukaan lain.
- `ExclusionMode.Auto`: “Decide the exclusion zone based on the window dimensions and anchors. Will attempt to reserve exactly enough space for the window and its margins if exactly 3 anchors are connected”.

**Poin kritis:** `Auto` hanya berfungsi optimal jika **tepat tiga anchor** terhubung. Ini karena dengan tiga anchor, dimensi yang tidak di-anchor sepenuhnya ditentukan oleh `implicitHeight`/`implicitWidth`, sehingga compositor dapat menghitung ruang yang dibutuhkan secara tepat. Jika hanya satu atau dua anchor, `Auto` mungkin tidak dapat menentukan zona eksklusif dengan benar.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Wayland

PanelWindow {
    anchors { top: true; left: true; right: true }   // tepat 3 anchor
    implicitHeight: 30
    exclusionMode: ExclusionMode.Auto                // zona eksklusif dihitung otomatis
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: 'my-shell-bar'
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
}
```

**Penjelasan kata-per-kata:**

- `exclusionMode: ExclusionMode.Auto`: Quickshell akan mencoba menghitung zona eksklusif berdasarkan dimensi (tinggi 30) dan tiga anchor. Karena ketiga anchor (top, left, right) terhubung, lebar mengikuti layar dan tinggi tetap 30, sehingga zona eksklusif 30 piksel dapat dihitung dengan tepat.
- `WlrLayershell.layer: WlrLayer.Top`: lapisan panel.
- `WlrLayershell.namespace`: nama untuk aturan compositor.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | `exclusionMode` | `exclusiveZone` | Catatan |
|---|---|---|---|
| Bar yang memesan ruang otomatis | `Auto` | tidak diatur | Memerlukan tepat 3 anchor. |
| Bar dengan zona eksklusif manual | `Normal` | `30` (piksel) | Anda menentukan sendiri besar ruang. |
| Overlay yang tidak memesan ruang | `Ignore` | tidak diatur | Tidak mengabaikan zona lain? `Ignore` mengabaikan zona lain *dan* tidak memesan. |
| Panel yang mengabaikan zona lain tetapi tetap memesan | `Normal` + `exclusiveZone` | sesuai kebutuhan | Hati-hati: bisa tumpang tindih dengan panel lain. |

### Visualisasi: Anchor dan Dimensi

```text
Kasus 1: anchors { top: true; left: true; right: true }
┌──────────────────────────────────────┐
│████████████ BAR (tinggi=30) █████████│  ← top anchor
│                                      │
│         area layar lainnya           │
│                                      │
└──────────────────────────────────────┘
  ↑ left anchor            right anchor ↑
  Lebar = lebar layar (karena kiri+kanan ter-anchor)
  Tinggi = 30 (karena hanya top yang ter-anchor vertikal)

Kasus 2: anchors { top: true; bottom: true }
┌──────────────────────────────────────┐
│████████████ BAR █████████████████████│  ← top anchor
│                                      │
│         tinggi = tinggi layar        │
│                                      │
│████████████ BAR █████████████████████│  ← bottom anchor
└──────────────────────────────────────┘
  Tinggi dipaksa = tinggi layar (dua anchor berlawanan)
```

**Penjelasan:** Dengan tiga anchor (atas, kiri, kanan), lebar mengikuti layar dan tinggi adalah `implicitHeight`. Dengan dua anchor berlawanan (atas dan bawah), tinggi dipaksa mengikuti tinggi layar. Inilah sebabnya `Auto` membutuhkan tiga anchor: ia dapat menyimpulkan dimensi yang tidak di-anchor secara eksplisit.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **Anchor** | Titik tempel permukaan ke tepi layar. Kombinasi dari `top`, `bottom`, `left`, `right`. |
| **Exclusive zone** | Area layar yang “dipesan” oleh permukaan sehingga jendela lain tidak menimpanya. |
| **`exclusionMode`** | Properti Quickshell yang menentukan bagaimana zona eksklusif dihitung. |
| **`implicitHeight` / `implicitWidth`** | Dimensi yang diinginkan permukaan; digunakan ketika dimensi tersebut tidak dipaksa oleh anchor. |

### Hubungan dengan Modul Lain

- **Modul 2.2:** Zona eksklusif memengaruhi tata letak workspace di compositor. Saat Anda mengirim perintah workspace melalui IPC, compositor akan menghormati zona eksklusif yang telah dipesan.
- **Modul 2.4:** Launcher (overlay) biasanya menggunakan `ExclusionMode.Ignore` atau tidak memesan zona eksklusif, karena ia muncul sementara dan tidak boleh menggeser jendela lain.

### Sumber Referensi

- Quickshell — `ExclusionMode`: https://quickshell.org/docs/v0.3.0/types/Quickshell/ExclusionMode/
- Quickshell — `PanelWindow` (properti `anchors`, `exclusionMode`, `exclusiveZone`): https://quickshell.org/docs/v0.3.0/types/Quickshell/PanelWindow/
- Quickshell — `WlrLayer`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Wayland/WlrLayer/

### Tips dan Praktik Terbaik

- **Gunakan `ExclusionMode.Auto` hanya dengan tepat tiga anchor.** Jika Anda membutuhkan konfigurasi anchor yang berbeda, gunakan `ExclusionMode.Normal` dengan `exclusiveZone` eksplisit.
- **Untuk overlay sementara, jangan memesan zona eksklusif.** Gunakan `ExclusionMode.Ignore` atau `Normal` dengan `exclusiveZone: 0`. Ini mencegah jendela lain “meloncat” saat overlay muncul.
- **Uji dengan `hyprctl layers`** untuk melihat apakah zona eksklusif benar-benar diterapkan oleh compositor.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menggunakan `Auto` dengan kurang dari tiga anchor | Zona eksklusif tidak dihitung atau tidak sesuai | Tambahkan anchor hingga tepat tiga, atau gunakan `Normal` + `exclusiveZone`. |
| Mengatur `exclusiveZone` tetapi `exclusionMode` masih `Auto` | Nilai `exclusiveZone` diabaikan atau konflik | Dokumentasi menyatakan setting `exclusiveZone` “sets `exclusionMode` to `ExclusionMode.Normal`”. Jadi mengatur `exclusiveZone` secara otomatis mengubah mode. |
| Memesan zona eksklusif pada panel yang seharusnya mengambang | Jendela lain terhalang | Gunakan `Ignore` atau `exclusiveZone: 0`. |

---

## 4. Fokus Keyboard Layer-Surface: `None`, `OnDemand`, `Exclusive`

### Deskripsi Konkret & Peran dalam Kurikulum

Mode fokus keyboard menentukan **apakah permukaan layer-shell Anda menerima ketikan**. Ini adalah fondasi untuk shell yang sepenuhnya dikendalikan keyboard: tanpa mode fokus yang benar, launcher Anda tidak akan bisa menerima input, atau sebaliknya, bar Anda akan mencuri fokus dari jendela lain.

**Mengapa penting:** Kurikulum menyebut “mode fokus keyboard” sebagai fondasi shell keyboard-driven. Memahami ketiga mode dan konsekuensinya—terutama mengapa `Exclusive` **bukan** lockscreen yang aman—adalah kunci untuk membangun UI yang tidak mengganggu dan tidak menimbulkan risiko keamanan.

### Konsep Kunci & Filosofi

`WlrKeyboardFocus` memiliki tiga varian:

- **`None`**: “No keyboard input will be accepted”. Permukaan tidak menerima ketikan sama sekali. Ini adalah default untuk `PanelWindow` (dokumentasi `PanelWindow`: `focusable` defaults to `false`, dan pada Wayland ini berkorespondensi dengan `WlrLayershell.keyboardFocus`).
- **`OnDemand`**: “Access to the keyboard as determined by the operating system”. Compositor yang memutuskan kapan permukaan menerima fokus. Ada peringatan: “On some systems, `OnDemand` may cause the shell window to retain focus over another window unexpectedly”. Ini berarti perilakunya tidak selalu deterministik dan bisa berbeda antar compositor.
- **`Exclusive`**: “Exclusive access to the keyboard, locking out all other windows”. Permukaan menerima semua ketikan; jendela lain tidak bisa menerima input. **Peringatan keras:** “You CANNOT use this to make a secure lock screen. If you want to make a lock screen, use `WlSessionLock`”.

**Mengapa `Exclusive` bukan lockscreen yang aman:** Protokol layer-shell tidak memiliki mekanisme autentikasi atau isolasi input tingkat sesi. `Exclusive` hanya berarti “compositor mengarahkan event keyboard ke permukaan ini, bukan ke jendela lain.” Namun, ini bukan batas keamanan: compositor lain, proses dengan hak akses yang cukup, atau甚至 pengguna yang memiliki akses ke sesi Wayland dapat mem-bypass-nya. Lockscreen yang aman memerlukan protokol khusus (`ext-session-lock-v1`) yang dirancang untuk mengunci sesi secara kriptografis dan mencegah input ke permukaan lain bahkan sebelum compositor memprosesnya. Quickshell menyediakan `WlSessionLock` untuk tujuan ini.

**Analogi:** `Exclusive` seperti memegang mikrofon di sebuah ruangan. Orang lain tidak bisa berbicara ke sound system selama Anda memegangnya—tetapi bukan berarti pintu ruangan terkunci. Siapa pun yang cukup kuat bisa merebut mikrofon itu. Lockscreen yang aman adalah pintu berlapis baja, bukan sekadar mikrofon eksklusif.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Wayland

PanelWindow {
    anchors { top: true; left: true; right: true }
    implicitHeight: 30
    exclusionMode: ExclusionMode.Auto
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None   // bar tidak menerima ketikan
}
```

```qml
// Launcher: menerima fokus hanya saat terlihat
PanelWindow {
    id: launcher
    visible: false
    implicitWidth: 480; implicitHeight: 320
    color: 'transparent'
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: launcher.visible = false
        // ... delegate dan logika navigasi
    }
}
```

**Penjelasan kata-per-kata:**

- `WlrLayershell.keyboardFocus: WlrKeyboardFocus.None` pada bar: bar tidak boleh menerima ketikan. Ini adalah pilihan aman untuk panel statis.
- Pada launcher: `keyboardFocus` diatur secara dinamis berdasarkan `visible`. Saat launcher terlihat, mode menjadi `Exclusive` agar pengguna bisa mengetik query. Saat tersembunyi, mode kembali ke `None` agar tidak mencuri fokus dari jendela lain.
- `visible ? ... : ...` adalah ekspresi ternary QML; ini memungkinkan perubahan mode fokus secara reaktif.
- `Keys.onEscapePressed`: handler QML untuk tombol Escape. Ini beroperasi di tingkat QML, **bukan** di tingkat protokol. Mode fokus layer-shell (`Exclusive`) memungkinkan event keyboard mencapai permukaan; setelah itu, QML yang menentukan apa yang dilakukan dengan event tersebut.

**Opsi lain untuk tujuan yang sama:**

| Skenario | Mode fokus | Alasan |
|---|---|---|
| Bar/panel statis | `None` | Tidak perlu menerima ketikan. |
| Launcher sementara | `Exclusive` saat terlihat, `None` saat tersembunyi | Menerima ketikan hanya saat aktif. |
| Widget yang menerima ketikan hanya saat diklik | `OnDemand` | Compositor menentukan; tetapi hati-hati dengan perilaku yang tidak deterministik. |
| Lockscreen | **Jangan gunakan `Exclusive`** | Gunakan `WlSessionLock` (protokol `ext-session-lock-v1`). |

### Visualisasi: Siklus Fokus Launcher

```text
Launcher tersembunyi                    Launcher terlihat
┌─────────────────────┐                ┌─────────────────────┐
│ keyboardFocus: None │                │ keyboardFocus:      │
│                     │  ── trigger ──>│   Exclusive         │
│ (ketikan pergi ke   │                │                     │
│  jendela lain)      │                │ (ketikan masuk ke   │
└─────────────────────┘                │  launcher)          │
                                       └─────────────────────┘
          ▲                                      │
          │            ── Escape ──              │
          └──────────────────────────────────────┘
```

**Penjelasan:** Saat launcher tersembunyi, `keyboardFocus: None` memastikan ketikan tetap mengalir ke jendela aktif. Saat launcher dipanggil, mode berubah menjadi `Exclusive` sehingga ketikan masuk ke launcher. Saat ditutup (misalnya dengan Escape), mode kembali ke `None`. Siklus ini adalah pola dasar untuk semua overlay keyboard-driven.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`WlrKeyboardFocus`** | Enum di Quickshell yang menentukan tingkat fokus keyboard permukaan layer-shell. |
| **`None`** | Tidak ada input keyboard yang diterima. |
| **`OnDemand`** | Compositor yang menentukan kapan fokus diberikan; perilakunya bisa tidak konsisten. |
| **`Exclusive`** | Permukaan menerima semua input keyboard; jendela lain terkunci dari input. **Bukan** mekanisme keamanan sesi. |
| **`WlSessionLock`** | Protokol dan tipe Quickshell untuk lockscreen yang aman. |

### Hubungan dengan Modul Lain

- **Modul 2.5 (Navigasi Keyboard-Driven):** Mode fokus layer-shell adalah **prasyarat** untuk rantai fokus QML. Anda tidak bisa membuat launcher yang menerima ketikan jika `WlrKeyboardFocus` masih `None`. Modul 2.5 akan membahas bagaimana event keyboard diproses setelah mencapai permukaan.
- **Modul 4.2 (Keamanan):** Peringatan tentang `Exclusive` dan lockscreen akan terhubung ke pembahasan keamanan sesi di modul lanjutan.

### Sumber Referensi

- Quickshell — `WlrKeyboardFocus`: https://quickshell.org/docs/v0.3.1/types/Quickshell.Wayland/WlrKeyboardFocus/
- Quickshell — `PanelWindow` (`focusable`): https://quickshell.org/docs/v0.3.0/types/Quickshell/PanelWindow/
- Spesifikasi `ext-session-lock-v1` (untuk lockscreen yang aman): https://wayland.app/protocols/ext-session-lock-v1

### Tips dan Praktik Terbaik

- **Gunakan `None` untuk semua permukaan yang tidak perlu menerima ketikan.** Ini mencegah “fokus hantu” yang membingungkan.
- **Untuk overlay sementara, ubah mode fokus secara dinamis** berdasarkan visibilitas, seperti contoh launcher di atas.
- **Jangan pernah menggunakan `Exclusive` sebagai mekanisme keamanan.** Untuk lockscreen, gunakan `WlSessionLock`.
- **Waspadai `OnDemand`:** dokumentasi memperingatkan bahwa perilakunya bisa tidak terduga. Jika Anda mengalaminya, beralihlah ke `None` atau `Exclusive` yang dikontrol secara eksplisit.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Launcher tetap `Exclusive` setelah ditutup | Ketikan tidak kembali ke jendela lain | Ubah `keyboardFocus` ke `None` saat `visible: false`. |
| Mengandalkan `Exclusive` untuk lockscreen | Sesi tidak benar-benar aman | Gunakan `WlSessionLock` dengan protokol `ext-session-lock-v1`. |
| Bar menerima ketikan yang tidak diinginkan | Tombol tidak berfungsi di jendela lain | Pastikan `keyboardFocus: None` pada bar. |

---

## 5. `PanelWindow` vs `FloatingWindow` vs `PopupWindow`

### Deskripsi Konkret & Peran dalam Kurikulum

Quickshell menyediakan tiga tipe jendela utama, masing-masing dengan peran berbeda:

- **`PanelWindow`**: “Decorationless window attached to screen edges by anchors”. Ini adalah jendela layer-shell yang menempel di tepi layar. Cocok untuk bar, panel, widget desktop, dan overlay.
- **`FloatingWindow`**: “Standard toplevel operating system window that looks like any other application”. Ini adalah jendela biasa yang dikelola compositor seperti jendela aplikasi pada umumnya. Cocok untuk jendela pengaturan, dialog, atau UI yang perlu diperlakukan sebagai jendela normal.
- **`PopupWindow`**: “Popup window that can display in a position relative to a floating or panel window”. Ini adalah popup yang terikat pada jendela induk (panel atau floating). Cocok untuk menu konteks, tooltip, atau dropdown dari bar.

**Mengapa penting:** Memilih tipe jendela yang salah akan membuat UI Anda tidak berperilaku seperti yang diharapkan—misalnya, bar yang seharusnya menempel malah menjadi jendela mengambang, atau menu yang seharusnya muncul di atas bar malah menjadi jendela terpisah.

### Konsep Kunci & Filosofi

**`PanelWindow`** adalah jendela **layer-shell**. Ia tidak memiliki dekorasi (title bar, border) dan ditempelkan ke tepi layar. Ia dapat memesan zona eksklusif. Ia adalah fondasi untuk shell yang terintegrasi dengan desktop.

**`FloatingWindow`** adalah jendela **toplevel** biasa. Ia memiliki dekorasi (tergantung compositor) dan berperilaku seperti aplikasi lain: bisa dipindahkan, di-resize, di-minimize. Ia tidak memesan zona eksklusif dan tidak menempel ke tepi.

**`PopupWindow`** adalah jendela **transien** yang terikat pada jendela induk. Ia muncul di posisi tertentu relatif terhadap induknya (misalnya di bawah bar). Ia biasanya digunakan untuk menu, tooltip, atau dropdown. Dokumentasi `PopupWindow` menyatakan bahwa popup “will not be shown until anchor is valid”, yang berarti Anda harus mengatur `anchor.window` dan `anchor.rect` sebelum popup bisa tampil.

**Analogi:** `PanelWindow` adalah furnitur yang dibaut ke dinding (bar). `FloatingWindow` adalah meja yang bisa dipindahkan (jendela biasa). `PopupWindow` adalah laci yang bisa ditarik keluar dari meja atau dari furnitur dinding (menu dropdown).

### Sintaks Dasar / Contoh Implementasi

**`PanelWindow` (bar):**

```qml
PanelWindow {
    anchors { top: true; left: true; right: true }
    implicitHeight: 30
    exclusionMode: ExclusionMode.Auto
    WlrLayershell.layer: WlrLayer.Top
    Text { anchors.centerIn: parent; text: "Bar" }
}
```

**`FloatingWindow` (jendela pengaturan):**

```qml
FloatingWindow {
    title: "Pengaturan"
    minimumSize: "400x300"
    visible: true
    Text { anchors.centerIn: parent; text: "Jendela biasa" }
}
```

**`PopupWindow` (menu dari bar):**

```qml
PanelWindow {
    id: bar
    anchors { top: true; left: true; right: true }
    implicitHeight: 30

    PopupWindow {
        anchor.window: bar
        anchor.rect.x: 100
        anchor.rect.y: bar.height
        width: 200
        height: 150
        visible: true
        Text { anchors.centerIn: parent; text: "Menu" }
    }
}
```

**Penjelasan kata-per-kata:**

- `PopupWindow { anchor.window: bar }`: popup terikat pada jendela `bar`. Ia akan muncul relatif terhadap bar.
- `anchor.rect.x: 100` dan `anchor.rect.y: bar.height`: posisi popup relatif terhadap bar: 100 piksel dari kiri, tepat di bawah bar (karena `y` sama dengan tinggi bar).
- `width: 200; height: 150`: ukuran popup.
- `visible: true`: popup ditampilkan. Namun, dokumentasi mencatat bahwa popup “will not be shown until anchor is valid”, jadi `anchor` harus sudah benar.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Tipe | Alasan |
|---|---|---|
| Bar/panel yang menempel di tepi | `PanelWindow` | Layer-shell, anchor, zona eksklusif. |
| Jendela pengaturan yang bisa dipindahkan | `FloatingWindow` | Toplevel biasa; compositor mengelolanya. |
| Menu dropdown dari bar | `PopupWindow` | Terikat pada jendela induk; muncul di posisi relatif. |
| Notifikasi yang muncul di pojok | `PanelWindow` (layer `Overlay`) | Perlu berada di atas segalanya dan muncul di posisi tetap. |

### Visualisasi: Hubungan Tiga Tipe Jendela

```text
┌──────────────────────────────────────────────┐
│  PanelWindow (bar)                           │
│  ┌────────────────────────────────────────┐  │
│  │  [Menu] ← PopupWindow                  │  │
│  │  (terikat pada bar, muncul di bawah)   │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  ┌────────────────────────────────────────┐  │
│  │  FloatingWindow                        │  │
│  │  (jendela biasa, bisa dipindah)        │  │
│  └────────────────────────────────────────┘  │
│                                              │
└──────────────────────────────────────────────┘
```

**Penjelasan:** `PanelWindow` adalah jendela layer-shell yang menempel di atas. `PopupWindow` terikat padanya dan muncul di posisi relatif (misalnya menu di bawah bar). `FloatingWindow` adalah jendela independen yang tidak terikat pada panel.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`PanelWindow`** | Jendela layer-shell tanpa dekorasi yang menempel di tepi layar. |
| **`FloatingWindow`** | Jendela toplevel biasa yang dikelola compositor seperti aplikasi. |
| **`PopupWindow`** | Jendela popup yang terikat pada jendela induk (panel atau floating). |
| **`anchor` (pada PopupWindow)** | Objek yang menentukan posisi popup relatif terhadap jendela induk. |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Launcher dan notifikasi biasanya menggunakan `PanelWindow` dengan layer `Overlay` (atau `PopupWindow` untuk menu). Memahami perbedaan tipe jendela sangat penting untuk membangun komponen desktop yang benar.
- **Modul 2.5:** `PanelWindow` dengan `keyboardFocus: Exclusive` adalah dasar dari launcher keyboard-driven. `PopupWindow` mungkin tidak memerlukan fokus keyboard sendiri karena ia bergantung pada induknya.

### Sumber Referensi

- Quickshell — `PanelWindow`: https://quickshell.org/docs/v0.3.0/types/Quickshell/PanelWindow/
- Quickshell — `FloatingWindow`: https://quickshell.org/docs/v0.2.0/types/Quickshell/FloatingWindow/
- Quickshell — `PopupWindow`: https://quickshell.org/docs/v0.2.0/types/Quickshell/PopupWindow
- Quickshell — Introduction (ringkasan tipe jendela): https://quickshell.org/docs/v0.2.0/guide/introduction/

### Tips dan Praktik Terbaik

- **Gunakan `PanelWindow` untuk segala sesuatu yang perlu menempel di tepi layar atau berada di lapisan tertentu.**
- **Gunakan `FloatingWindow` hanya ketika Anda benar-benar membutuhkan jendela yang berperilaku seperti aplikasi biasa** (misalnya jendela pengaturan yang bisa dipindahkan).
- **Untuk popup, pastikan `anchor` valid sebelum menampilkan popup**; jika tidak, popup tidak akan muncul.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menggunakan `FloatingWindow` untuk bar | Bar tidak menempel dan tidak memesan ruang | Gunakan `PanelWindow` dengan anchor. |
| Menggunakan `PanelWindow` untuk jendela pengaturan | Jendela tidak bisa dipindahkan dan selalu menempel | Gunakan `FloatingWindow`. |
| Menampilkan `PopupWindow` tanpa `anchor.window` | Popup tidak muncul | Atur `anchor.window` ke jendela induk. |

---

## 6. Transparansi dan Aturan Layer Compositor (Blur)

### Deskripsi Konkret & Peran dalam Kurikulum

Transparansi dan blur adalah fitur visual yang membuat shell terlihat menyatu dengan wallpaper. Namun, di Wayland, **klien tidak bisa mem-blur dirinya sendiri** dengan cara yang portabel. Blur adalah efek yang diterapkan oleh **compositor** pada permukaan tertentu. Quickshell menyediakan cara untuk memberi tahu compositor “permukaan ini boleh di-blur” melalui `namespace`, dan compositor (misalnya Hyprland) menerapkan aturan `layerrule`.

**Mengapa penting:** Kurikulum menyebut “transparansi dan aturan layer compositor (blur latar)” sebagai bagian dari Modul 2.1. Tanpa memahami hubungan antara `namespace` dan `layerrule`, Anda akan bingung mengapa panel Anda transparan tetapi tidak di-blur, atau mengapa blur diterapkan ke permukaan yang salah.

### Konsep Kunci & Filosofi

**Transparansi** di Wayland dicapai dengan membuat permukaan memiliki alpha channel (misalnya `color: 'transparent'` pada `PanelWindow`). Namun, transparansi saja hanya membuat permukaan tembus pandang; ia tidak mem-blur apa pun di belakangnya.

**Blur** adalah efek yang dihitung oleh compositor. Compositor mengambil konten di belakang permukaan dan mengaplikasikan blur sebelum mencampurnya dengan permukaan transparan. Agar compositor tahu permukaan mana yang harus di-blur, ia mencocokkan **namespace** permukaan dengan aturan yang ditentukan pengguna.

Di Hyprland, aturan ini disebut `layerrule`. Contoh:

```text
layerrule = blur on, match:namespace my-shell-bar
```

**Penjelasan:** Aturan ini memberi tahu Hyprland: “Untuk layer surface dengan namespace `my-shell-bar`, aktifkan blur.” Tanpa aturan ini, permukaan tetap transparan tetapi tidak di-blur.

**Poin kritis:** `namespace` harus diatur **sebelum** jendela terkoneksi. Dokumentasi `WlrLayershell` menyatakan: “Cannot be set after `windowConnected`”. Jika Anda mengubah namespace setelah jendela tampil, aturan blur mungkin tidak berlaku.

### Sintaks Dasar / Contoh Implementasi

**Sisi Quickshell (mengatur namespace dan transparansi):**

```qml
PanelWindow {
    anchors { top: true; left: true; right: true }
    implicitHeight: 30
    color: 'transparent'                         // permukaan transparan
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: 'my-shell-bar'      // namespace untuk aturan compositor
}
```

**Sisi Hyprland (`hyprland.conf`):**

```text
layerrule = blur on, match:namespace my-shell-bar
layerrule = ignorealpha 0.5, match:namespace my-shell-bar
```

**Penjelasan kata-per-kata:**

- `color: 'transparent'`: membuat latar belakang `PanelWindow` transparan. Konten di dalamnya (misalnya `Rectangle` dengan warna semi-transparan) akan terlihat.
- `WlrLayershell.namespace: 'my-shell-bar'`: memberi nama permukaan. Ini adalah kunci yang dicocokkan oleh `layerrule`.
- `layerrule = blur on, match:namespace my-shell-bar`: Hyprland akan mem-blur area di belakang permukaan dengan namespace tersebut.
- `layerrule = ignorealpha 0.5, match:namespace my-shell-bar`: Hyprland akan mengabaikan blur pada piksel yang alpha-nya di bawah 0.5. Ini mencegah blur “bocor” di area yang seharusnya sepenuhnya transparan.

**Opsi lain untuk tujuan yang sama:**

| Compositor | Mekanisme | Contoh |
|---|---|---|
| Hyprland | `layerrule` dengan `match:namespace` | `layerrule = blur on, match:namespace my-shell-bar` |
| Sway | Tidak ada blur bawaan; gunakan compositor effect atau patch | — |
| Niri | Layer rule dengan namespace | Mirip Hyprland, sintaks berbeda |

### Visualisasi: Hubungan Namespace dan Blur

```text
Quickshell                          Hyprland
┌─────────────────────┐            ┌─────────────────────────────┐
│ PanelWindow         │            │ hyprland.conf               │
│   namespace:        │  dicocokkan│ layerrule = blur on,        │
│   "my-shell-bar"    │ ──────────>│   match:namespace           │
│   color: transparent│            │   my-shell-bar              │
└─────────────────────┘            └─────────────────────────────┘
                                              │
                                              ▼
                                   ┌─────────────────────────────┐
                                   │ Permukaan di-blur oleh      │
                                   │ compositor.                 │
                                   └─────────────────────────────┘
```

**Penjelasan:** Namespace adalah “label” yang dipasang Quickshell pada permukaan. Hyprland membaca label itu dan menerapkan aturan blur yang cocok. Tanpa label atau tanpa aturan, blur tidak terjadi.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **Transparansi** | Sifat permukaan yang memiliki alpha channel; memungkinkan konten di belakangnya terlihat. |
| **Blur** | Efek yang dihitung compositor untuk mengaburkan konten di belakang permukaan transparan. |
| **`namespace`** | Nama yang diberikan pada layer surface; digunakan compositor untuk mencocokkan aturan. |
| **`layerrule`** | Aturan di Hyprland yang menentukan perilaku layer surface berdasarkan namespace. |

### Hubungan dengan Modul Lain

- **Modul 2.2:** `namespace` juga dapat digunakan untuk mengidentifikasi permukaan Anda saat mengirim perintah IPC atau saat compositor menerapkan aturan lain (misalnya animasi).
- **Modul 2.4:** Launcher dan notifikasi mungkin memerlukan blur yang berbeda; Anda dapat menggunakan namespace yang berbeda untuk setiap komponen dan aturan `layerrule` yang berbeda.

### Sumber Referensi

- Hyprland — Layer Rules (contoh `layerrule` dengan namespace): https://wiki.hyprland.org/Configuring/Window-Rules/#layer-rules
- Quickshell — `WlrLayershell.namespace`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Wayland/WlrLayershell/
- Diskusi Hyprland tentang blur dan namespace: https://github.com/hyprwm/Hyprland/discussions/12798

### Tips dan Praktik Terbaik

- **Atur `namespace` sebelum jendela terkoneksi.** Dokumentasi menyatakan namespace tidak dapat diubah setelah `windowConnected`.
- **Gunakan `ignorealpha` untuk mencegah blur pada area yang sepenuhnya transparan.** Ini meningkatkan performa dan tampilan.
- **Uji dengan `hyprctl layers`** untuk memastikan namespace terdaftar dan aturan blur diterapkan.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Lupa mengatur `namespace` | Blur tidak diterapkan meskipun `color: 'transparent'` | Atur `WlrLayershell.namespace` dan cocokkan dengan `layerrule`. |
| Mengubah `namespace` setelah jendela tampil | Blur tidak berubah atau error | Atur namespace sebelum `windowConnected`. |
| Blur “bocor” di area transparan | Area yang seharusnya jernih menjadi buram | Gunakan `ignorealpha` dengan nilai yang sesuai. |

---

## 7. Debugging dengan `wayland-info` dan `hyprctl layers`

### Deskripsi Konkret & Peran dalam Kurikulum

Debugging adalah keterampilan penting yang sering diabaikan. Dua alat utama untuk Modul 2.1 adalah:

- **`wayland-info`**: memeriksa protokol Wayland apa yang didukung oleh compositor. Apakah `zwlr_layer_shell_v1` tersedia? Versi berapa?
- **`hyprctl layers`**: (khusus Hyprland) menampilkan daftar layer surface yang aktif, termasuk namespace dan propertinya.

**Mengapa penting:** Ketika panel tidak muncul, tidak memesan ruang, atau blur tidak bekerja, alat-alat ini memberi Anda informasi dari sisi compositor—sesuatu yang tidak bisa dilihat dari kode Quickshell saja.

### Konsep Kunci & Filosofi

**Debugging berlapis:** Masalah layer-shell bisa terjadi di beberapa lapisan:

1. **Protokol:** Apakah compositor mendukung `zwlr_layer_shell_v1`?
2. **Klien (Quickshell):** Apakah properti diatur dengan benar? Apakah namespace diatur sebelum `windowConnected`?
3. **Compositor:** Apakah compositor menerima permintaan? Apakah aturan (seperti `layerrule`) cocok?
4. **QML:** Apakah logika visibilitas dan fokus sudah benar?

`wayland-info` menjawab pertanyaan lapisan 1. `hyprctl layers` menjawab pertanyaan lapisan 3. Debugging QML (misalnya `console.log`) menjawab lapisan 2 dan 4.

### Sintaks Dasar / Contoh Implementasi

**Memeriksa dukungan layer-shell:**

```bash
wayland-info | grep layer_shell
```

**Penjelasan:** `wayland-info` mencetak daftar protokol yang didukung compositor. `grep layer_shell` memfilter baris yang mengandung `layer_shell`. Jika muncul `zwlr_layer_shell_v1`, compositor mendukung protokol tersebut. Jika tidak, layer-shell tidak akan berfungsi.

**Melihat layer surface yang aktif di Hyprland:**

```bash
hyprctl layers
```

**Penjelasan:** Perintah ini “lists all the layers” di Hyprland. Output-nya menunjukkan layer surface yang sedang aktif, termasuk namespace dan propertinya. Anda dapat memverifikasi apakah permukaan Anda terdaftar dan apakah zona eksklusifnya sesuai.

**Contoh output `wayland-info` (disederhanakan):**

```text
interface: 'zwlr_layer_shell_v1', version: 4, name: 32
```

**Penjelasan:** Baris ini berarti compositor mendukung `zwlr_layer_shell_v1` versi 4. Jika versi yang didukung lebih rendah dari yang diharapkan Quickshell, beberapa fitur mungkin tidak tersedia.

### Visualisasi: Alur Debugging

```text
Masalah: Panel tidak muncul
        │
        ▼
┌───────────────────────────────┐
│ 1. wayland-info | grep        │
│    layer_shell                │
│    → Apakah protokol ada?     │
└───────────────────────────────┘
        │ Ya
        ▼
┌───────────────────────────────┐
│ 2. Periksa properti Quickshell│
│    - anchors? layer?          │
│    - namespace?               │
│    - windowConnected?         │
└───────────────────────────────┘
        │ Properti benar
        ▼
┌───────────────────────────────┐
│ 3. hyprctl layers             │
│   → Apakah permukaan terdaftar│
│   → Apakah zona eksklusif     │
│     sesuai?                   │
└───────────────────────────────┘
        │ Terdaftar tetapi tidak tampil
        ▼
┌───────────────────────────────┐
│ 4. Periksa aturan compositor  │
│    (layerrule, blur, opacity) │
└───────────────────────────────┘
```

**Penjelasan:** Debugging dimulai dari lapisan paling bawah (protokol), lalu naik ke properti Quickshell, lalu ke state compositor, dan akhirnya ke aturan visual.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`wayland-info`** | Utilitas untuk menampilkan protokol Wayland yang didukung compositor. |
| **`hyprctl`** | Utilitas kontrol Hyprland; `layers` adalah subperintah untuk melihat layer surface. |
| **Namespace** | Nama yang terdaftar di compositor; muncul di output `hyprctl layers`. |

### Hubungan dengan Modul Lain

- **Modul 2.2 (IPC):** `hyprctl` adalah bagian dari IPC Hyprland. Keterampilan debugging ini akan berguna saat Anda mengirim perintah ke compositor.
- **Modul 2.4:** Debugging notifikasi dan tray juga akan menggunakan alat serupa (`busctl` untuk D-Bus).

### Sumber Referensi

- `wayland-info` man page: https://www.mankier.com/1/wayland-info
- Hyprland Wiki — Using `hyprctl` (termasuk `layers`): https://wiki.hyprland.org/Configuring/Using-hyprctl/
- Spesifikasi `zwlr_layer_shell_v1`: https://wayland.app/protocols/wlr-layer-shell-unstable-v1

### Tips dan Praktik Terbaik

- **Jalankan `wayland-info | grep layer_shell` sebelum memulai proyek** untuk memastikan compositor Anda mendukung layer-shell.
- **Gunakan `hyprctl layers` setelah setiap perubahan besar** untuk memverifikasi bahwa permukaan terdaftar dengan namespace dan zona eksklusif yang benar.
- **Jika blur tidak bekerja, periksa apakah `namespace` di output `hyprctl layers` cocok dengan `layerrule` Anda.**

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak memeriksa dukungan protokol | `WlrLayershell` tidak berfungsi | Pastikan `wayland-info | grep layer_shell` menunjukkan `zwlr_layer_shell_v1`. |
| Namespace tidak cocok dengan `layerrule` | Blur tidak diterapkan | Periksa output `hyprctl layers` dan sesuaikan `match:namespace`. |
| Zona eksklusif tidak terlihat di `hyprctl layers` | Jendela lain menimpa panel | Periksa `exclusionMode` dan anchor; pastikan tepat tiga anchor untuk `Auto`. |

---

## 8. Latihan dan Checkpoint

### Latihan (sesuai kurikulum)

**Buat overlay yang muncul di layer `Overlay` dan menerima ketikan hanya saat dipanggil.**

**Langkah-langkah:**

1. Buat `PanelWindow` dengan `WlrLayershell.layer: WlrLayer.Overlay`.
2. Atur `visible: false` secara default.
3. Atur `WlrLayershell.keyboardFocus` secara dinamis: `None` saat tersembunyi, `Exclusive` saat terlihat.
4. Tambahkan `Keys.onEscapePressed` untuk menyembunyikan overlay.
5. Tambahkan logika untuk memanggil overlay (misalnya melalui `IpcHandler` atau keybind, yang akan Anda pelajari di Modul 2.2).
6. Uji dengan `hyprctl layers` untuk memastikan overlay terdaftar di layer `Overlay` saat terlihat.
7. Uji dengan `notify-send` atau input keyboard untuk memastikan fokus keyboard berpindah dengan benar.

**Checkpoint:** Jelaskan mengapa `Exclusive` tidak boleh dipakai sebagai lockscreen.

**Jawaban singkat:** `Exclusive` hanya mengarahkan event keyboard ke permukaan layer-shell; ia tidak menyediakan isolasi keamanan tingkat sesi. Compositor atau proses lain dengan hak akses yang cukup dapat mem-bypass-nya, dan tidak ada mekanisme autentikasi. Lockscreen yang aman memerlukan protokol `ext-session-lock-v1` (di Quickshell: `WlSessionLock`), yang dirancang untuk mengunci sesi secara aman dan mencegah input ke permukaan lain bahkan sebelum compositor memprosesnya.

---

## Motivasi

Layer-shell adalah salah satu fondasi paling penting dari shell Wayland yang serius. Menguasainya berarti Anda bisa menempatkan UI Anda tepat di tempat yang Anda inginkan, dengan fokus keyboard yang tepat, tanpa mengganggu jendela lain. Ini adalah keterampilan yang akan Anda gunakan terus-menerus di modul-modul berikutnya. Teruslah bereksperimen—setiap panel yang berhasil Anda tempatkan adalah satu langkah lebih dekat ke shell yang sepenuhnya Anda kendalikan.

---

Sebelum masuk ke materi berikutnya, ada beberapa catatan audit untuk modul ini.

---

## Audit Singkat Modul 2.2

**Temuan audit:**

1. **Kurikulum menyebut “`Quickshell.I3` untuk i3 dan Sway”** — ini benar, tetapi ada satu detail penting yang perlu ditambahkan: protokol i3/Sway menggunakan *magic string* `i3-ipc` dan *header* 14-byte (6 byte magic + 4 byte panjang payload + 4 byte tipe pesan). Quickshell menangani ini secara internal, tetapi memahaminya krusial untuk debugging ketika koneksi gagal.

2. **Kurikulum menyebut “`GlobalShortcut` pada Hyprland”** — perlu penekanan bahwa `GlobalShortcut` **hanya berfungsi di Hyprland** dan tidak menggunakan protokol `xdg-desktop-portal`. Ini berbeda dari pintasan global di lingkungan desktop lain. Dokumentasi Quickshell menyatakan: “It will only work with Hyprland” dan “does not use the xdg-desktop-portal global shortcuts protocol”.

3. **Kurikulum belum secara eksplisit membahas perbedaan mendasar antara `IpcHandler` dan `GlobalShortcut`** sebagai dua jalur berbeda dari keyboard ke shell. `IpcHandler` adalah jalur *pull/push* melalui CLI (`qs ipc call`), sedangkan `GlobalShortcut` adalah jalur *event* langsung melalui protokol Hyprland. Keduanya memiliki trade-off yang perlu dijelaskan.

4. **Kurikulum menyebut “Socket IPC Hyprland: event dan dispatcher”** — ini perlu dijabarkan lebih konkret: Hyprland memiliki **dua socket** (`.socket.sock` untuk request/response dan `.socket2.sock` untuk event streaming), dan Quickshell membungkus keduanya melalui `requestSocketPath` dan `eventSocketPath`.

5. **Tidak ada pembahasan tentang keamanan lingkungan sesi** yang disebutkan di Modul 2.4, tetapi relevan di sini: `qs ipc call` dan peluncuran aplikasi mewarisi environment shell. Materi ini akan menambahkan catatan keamanan sebagai **materi tambahan** yang tetap mengacu pada kurikulum.

Dengan catatan ini, saya akan membangun Modul 2.2 selengkap mungkin.

---

# Modul 2.2 — IPC Compositor: Hyprland, Sway/i3, `IpcHandler`, dan Pintasan Global

> *“Shell yang baik tidak hanya menggambar; ia berbicara dengan compositor, dan membiarkan keyboard berbicara kepadanya.”*

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Mengapa IPC ada: filosofi kontrol dari luar** — mengapa shell tidak boleh menjadi monolit yang buta terhadap state compositor.
2. **Socket IPC Hyprland** — dua socket (request/event), `HYPRLAND_INSTANCE_SIGNATURE`, format pesan.
3. **`Quickshell.Hyprland` singleton** — properti reaktif (`focusedWorkspace`, `monitors`, `toplevels`) dan `dispatch()`.
4. **`Quickshell.I3` untuk Sway/i3** — protokol `i3-ipc`, `SWAYSOCK`, `dispatch()`, dan keterbatasan dibanding Hyprland.
5. **`IpcHandler` dan `qs ipc`** — mengekspos fungsi QML ke CLI/keybind; mengapa tipe eksplisit wajib.
6. **`GlobalShortcut`** — pintasan global native Hyprland; perbedaan dengan `IpcHandler`; batasan dan collision.
7. **Perbandingan dan pemilihan mekanisme** — kapan memakai `IpcHandler`, kapan `GlobalShortcut`, kapan `hyprctl`/`swaymsg` langsung.
8. **Keamanan dan lingkungan sesi (materi tambahan)** — apa yang diwariskan saat `qs ipc call` atau peluncuran aplikasi.
9. **Debugging** — `qs ipc show`, `hyprctl`, `socat`, `busctl` (untuk D-Bus di modul berikutnya).
10. **Latihan dan checkpoint**.

---

## 1. Mengapa IPC Ada: Filosofi Kontrol dari Luar

### Deskripsi Konkret & Peran dalam Kurikulum

Compositor seperti Hyprland dan Sway adalah **otoritas tunggal** atas tata letak jendela, workspace, monitor, dan input. Shell Anda (Quickshell) berjalan sebagai klien Wayland; ia tidak memiliki akses langsung ke state internal compositor. IPC adalah **jembatan** yang memungkinkan shell:

- **Membaca** state compositor (workspace aktif, monitor fokus, daftar jendela).
- **Menulis** perintah ke compositor (pindah workspace, fullscreen, exec).
- **Mengekspos** aksi shell ke keyboard/CLI sehingga pengguna dapat mengendalikan shell tanpa mouse.

**Mengapa penting dalam kurikulum:** Modul 2.1 mengajarkan cara menempatkan UI. Modul 2.2 mengajarkan cara membuat UI itu **reaktif terhadap compositor** dan **dapat dikendalikan dari keyboard**. Inilah jantung “super kontrol berbasis keyboard” yang menjadi tema kurikulum.

### Konsep Kunci & Filosofi

**Filosofi Unix: proses kecil yang berbicara melalui socket.** Hyprland dan Sway tidak menanamkan shell ke dalam compositor. Sebaliknya, mereka menyediakan socket Unix yang stabil; siapa pun—shell, skrip, atau utilitas—dapat terhubung dan bertukar pesan. Quickshell membungkus socket ini menjadi tipe QML yang reaktif, sehingga Anda dapat menulis `Hyprland.focusedWorkspace?.name` dan UI Anda otomatis diperbarui ketika workspace berubah.

**Analogi:** Compositor adalah kantor pusat yang memiliki dua loket: loket **permintaan** (Anda menyerahkan formulir, petugas memproses) dan loket **pengumuman** (petugas membacakan perubahan state ke semua yang mendengarkan). IPC adalah sistem antrean di kedua loket. `Quickshell.Hyprland` adalah resepsionis pribadi Anda yang berdiri di depan kedua loket dan menerjemahkan formulir serta pengumuman ke bahasa QML.

**Prinsip monolitik-modular:** Shell Anda tetap **monolitik dalam fungsi** (satu proses Quickshell mengelola bar, launcher, notifikasi), tetapi **modular dalam kode** (setiap integrasi compositor adalah modul terpisah: `Quickshell.Hyprland`, `Quickshell.I3`). IPC adalah lapisan abstraksi yang memungkinkan modularitas ini tanpa mengorbankan kontrol.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell.Hyprland

Text {
    text: Hyprland.focusedWorkspace?.name ?? '?'
    color: 'white'
}
```

**Penjelasan kata-per-kata:**

- `import Quickshell.Hyprland`: mengimpor modul Hyprland. Modul ini mendaftarkan singleton `Hyprland` dan tipe terkait (`HyprlandWorkspace`, `HyprlandMonitor`, dll.).
- `Hyprland.focusedWorkspace`: properti readonly yang mengembalikan `HyprlandWorkspace` dari workspace yang sedang fokus, atau `null` jika belum ada.
- `?.name`: operator *optional chaining* QML/JavaScript. Jika `focusedWorkspace` adalah `null`, ekspresi berhenti dan menghasilkan `undefined`, bukan error.
- `?? '?'`: operator *nullish coalescing*. Jika hasil sebelumnya `null` atau `undefined`, gunakan string `'?'` sebagai fallback.
- `Text { ... }`: elemen QML yang menampilkan teks; properti `text` diperbarui secara reaktif ketika `Hyprland.focusedWorkspace` berubah.

**Opsi lain untuk tujuan yang sama (membaca workspace aktif):**

| Pendekatan | Contoh | Catatan |
|---|---|---|
| Quickshell.Hyprland | `Hyprland.focusedWorkspace?.name` | Reaktif, terintegrasi dengan QML. |
| `hyprctl activeworkspace -j` | Output JSON | Untuk skrip eksternal; tidak reaktif di QML. |
| Socket event `.socket2.sock` | `workspace>>2` | Untuk listener kustom; Quickshell sudah menanganinya. |

### Visualisasi: Dua Jalur IPC

```text
┌─────────────────────┐        ┌─────────────────────────────┐
│  Quickshell (QML)   │        │  Hyprland / Sway            │
│                     │        │                             │
│  Hyprland.focused   │◄───────│  Event socket (.socket2)    │
│  Workspace          │  event │  mengirim perubahan state   │
│                     │        │                             │
│  Hyprland.dispatch  │───────>│  Request socket (.socket)   │
│  ("workspace 2")    │ request│  menerima perintah          │
│                     │        │                             │
└─────────────────────┘        └─────────────────────────────┘
```

**Penjelasan diagram:** Ada dua arah komunikasi. Arah **event** (kiri ke kanan) membawa state dari compositor ke shell. Arah **request** (kanan ke kiri) membawa perintah dari shell ke compositor. Quickshell membungkus keduanya dalam satu singleton.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **IPC (Inter-Process Communication)** | Pertukaran data antar proses; di Hyprland/Sway menggunakan socket Unix. |
| **Socket Unix** | Titik komunikasi berbasis file di sistem file; proses menulis/membaca melalui file descriptor. |
| **Request/response** | Pola di mana klien mengirim permintaan dan menerima balasan. |
| **Event stream** | Aliran pesan satu arah dari server ke klien; klien hanya mendengarkan. |
| **Dispatcher** | Perintah yang dijalankan oleh compositor (misalnya `workspace 2`, `exec kitty`). |

### Hubungan dengan Modul Lain

- **Modul 2.1:** Layer-shell menempatkan UI; IPC memberi tahu UI tentang state compositor yang memengaruhi tata letak (misalnya workspace berubah → bar harus memperbarui).
- **Modul 2.4:** Launcher dan notifikasi sering kali dipicu melalui IPC atau `GlobalShortcut`; peluncuran aplikasi mewarisi lingkungan sesi yang sama.
- **Modul 2.5:** `IpcHandler` dan `GlobalShortcut` adalah dua jalur “dari keyboard ke shell” yang akan Anda kombinasikan dengan rantai fokus QML.

### Sumber Referensi

- Hyprland Wiki — IPC: https://wiki.hypr.land/ipc/
- Quickshell — `Quickshell.Hyprland`: https://quickshell.org/docs/v0.3.0/types/Quickshell.Hyprland/Hyprland/
- Quickshell — `Quickshell.I3`: https://quickshell.org/docs/v0.2.1/types/Quickshell.I3/I3

### Tips dan Praktik Terbaik

- **Jangan menulis listener socket sendiri kecuali perlu.** Quickshell sudah menyediakan properti reaktif; menggunakan `socat` atau skrip eksternal menambah latensi dan duplikasi logika.
- **Gunakan `??` dan `?.` untuk menangani state yang belum siap.** Saat Quickshell baru dimulai, `focusedWorkspace` bisa `null`; UI tidak boleh crash.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Mengakses `Hyprland.focusedWorkspace.name` tanpa `?.` | Error saat workspace belum ada | Gunakan `?.name ?? '?'`. |
| Menganggap IPC instan | UI terlambat diperbarui | IPC adalah asinkron; gunakan properti reaktif, bukan polling. |

---

## 2. Socket IPC Hyprland: Dua Socket, Satu Instance Signature

### Deskripsi Konkret & Peran dalam Kurikulum

Hyprland mengekspos **dua socket Unix** di direktori runtime:

- **`.socket.sock`**: untuk **request/response** (seperti `hyprctl`). Anda menulis perintah, Hyprland membalas dengan JSON atau teks.
- **`.socket2.sock`**: untuk **event streaming**. Hyprland menulis event ke setiap klien yang terhubung, dalam format `EVENT>>DATA\n`.

Keduanya berada di `$XDG_RUNTIME_DIR/hypr/[HIS]/`, di mana `HIS` adalah **Hyprland Instance Signature** (`$HYPRLAND_INSTANCE_SIGNATURE`). Ini memungkinkan beberapa instance Hyprland berjalan bersamaan tanpa saling bertabrakan.

**Mengapa penting:** Memahami dua socket ini menjelaskan mengapa `Quickshell.Hyprland` memiliki `requestSocketPath` dan `eventSocketPath` sebagai properti terpisah. Ini juga penting untuk debugging: jika event tidak masuk, periksa `.socket2.sock`; jika perintah gagal, periksa `.socket.sock`.

### Konsep Kunci & Filosofi

**Pemisahan concerns:** Socket request bersifat *sinkron dan transaksional*—Hyprland mengevaluasi koneksi sepenuhnya secara sinkron, dan koneksi yang tidak ditutup dapat menyebabkan freeze hingga timeout lima detik. Socket event bersifat *asinkron dan streaming*—Hyprland menulis event ke semua klien yang terhubung tanpa menunggu balasan.

**Instance Signature:** `$HYPRLAND_INSTANCE_SIGNATURE` adalah kunci isolasi. Jika Anda menjalankan dua instance Hyprland (misalnya untuk testing), masing-masing memiliki socket sendiri. Quickshell membaca environment ini untuk menemukan socket yang benar.

### Sintaks Dasar / Contoh Implementasi

**Memeriksa socket yang tersedia:**

```bash
echo $HYPRLAND_INSTANCE_SIGNATURE
ls $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/
```

**Penjelasan:**

- `echo $HYPRLAND_INSTANCE_SIGNATURE`: mencetak instance signature. Jika kosong, Anda mungkin tidak berada di sesi Hyprland.
- `ls $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/`: menampilkan isi direktori socket. Anda akan melihat `.socket.sock` dan `.socket2.sock` (dan mungkin file lain).

**Mengirim perintah melalui request socket (menggunakan `socat`):**

```bash
echo -n 'workspace 2' | socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock
```

**Penjelasan kata-per-kata:**

- `echo -n 'workspace 2'`: mengirim string `workspace 2` tanpa newline. Perintah ini adalah *dispatcher* Hyprland: pindah ke workspace 2.
- `|`: pipe, menghubungkan output `echo` ke input `socat`.
- `socat - UNIX-CONNECT:...`: `socat` membuka koneksi Unix socket ke path yang ditentukan. Tanda `-` berarti menggunakan stdin/stdout sebagai endpoint.
- Path socket: `$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock`.

**Mendengarkan event melalui event socket:**

```bash
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
```

**Penjelasan:** `socat -U` berarti komunikasi satu arah (unidirectional) dari socket ke stdout. Setiap baris yang diterima akan dicetak, misalnya `workspace>>2` atau `focusedmon>>eDP-1,1`.

**Opsi lain untuk tujuan yang sama:**

| Tujuan | Alat | Contoh |
|---|---|---|
| Mengirim perintah | `hyprctl` | `hyprctl dispatch workspace 2` |
| Mengirim perintah | `socat` ke `.socket.sock` | `echo -n 'workspace 2' \| socat - UNIX-CONNECT:...` |
| Mendengarkan event | `socat -U` ke `.socket2.sock` | Lihat contoh di atas |
| Mendengarkan event | Quickshell | Properti reaktif `Hyprland.*` |

### Visualisasi: Struktur Direktori Socket

```text
$XDG_RUNTIME_DIR/hypr/
└── $HYPRLAND_INSTANCE_SIGNATURE/
    ├── .socket.sock      ← request/response (hyprctl)
    └── .socket2.sock     ← event stream (workspace>>2, focusedmon>>...)
```

**Penjelasan:** Setiap instance Hyprland memiliki direktori sendiri yang dinamai berdasarkan signature. Di dalamnya, dua socket memisahkan jalur request dan event.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`HYPRLAND_INSTANCE_SIGNATURE`** | String unik yang mengidentifikasi instance Hyprland; digunakan untuk menemukan socket. |
| **`.socket.sock`** | Socket request/response; sinkron, transaksional. |
| **`.socket2.sock`** | Socket event; asinkron, streaming. |
| **`socat`** | Utilitas serbaguna untuk menghubungkan dua endpoint (termasuk Unix socket). |

### Hubungan dengan Modul Lain

- **Modul 2.1:** `namespace` layer-shell muncul di event `openlayer` dan `closelayer` di `.socket2.sock`. Ini menghubungkan layer-shell dengan IPC.
- **Modul 2.4:** `busctl` untuk D-Bus adalah “sepupu” dari `socat` untuk socket Unix; keterampilan debugging yang sama berlaku.

### Sumber Referensi

- Hyprland Wiki — IPC: https://wiki.hypr.land/ipc/
- Hyprland Wiki — Using `hyprctl`: https://wiki.hypr.land/Configuring/Using-hyprctl/
- `socat` man page: https://linux.die.net/man/1/socat

### Tips dan Praktik Terbaik

- **Selalu tutup koneksi request setelah menulis.** Hyprland mengevaluasi koneksi secara sinkron; koneksi yang menggantung dapat menyebabkan freeze hingga timeout.
- **Jangan melakukan polling ke `.socket.sock` untuk memantau state.** Gunakan `.socket2.sock` atau properti reaktif Quickshell.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Membiarkan koneksi request terbuka | Hyprland freeze hingga 5 detik | Tutup koneksi segera setelah menulis. |
| Menggunakan path socket hardcoded | Gagal jika instance signature berubah | Baca `$HYPRLAND_INSTANCE_SIGNATURE` secara dinamis. |

---

## 3. `Quickshell.Hyprland`: State Reaktif dan `dispatch()`

### Deskripsi Konkret & Peran dalam Kurikulum

`Quickshell.Hyprland` adalah singleton QML yang membungkus kedua socket Hyprland menjadi properti reaktif dan fungsi `dispatch()`. Ini adalah cara **utama** bagi shell Quickshell untuk berinteraksi dengan Hyprland.

**Mengapa penting:** Alih-alih menulis listener socket sendiri, Anda cukup mengakses properti seperti `Hyprland.workspaces`, `Hyprland.monitors`, `Hyprland.toplevels`, dan `Hyprland.focusedWorkspace`. Ketika state berubah, UI diperbarui secara otomatis.

### Konsep Kunci & Filosofi

**Reaktivitas deklaratif:** Dalam QML, Anda tidak “mengambil” state; Anda **mendeklarasikan ketergantungan**. Ketika `Hyprland.focusedWorkspace` berubah, semua binding yang bergantung padanya dievaluasi ulang. Ini adalah pola yang sama dengan reaktivitas QML pada umumnya, tetapi diterapkan pada state compositor.

**`dispatch()`:** Fungsi ini mengirim perintah ke Hyprland melalui request socket. Perintahnya adalah **dispatcher Hyprland**, bukan perintah shell. Contoh dispatcher: `workspace 2`, `exec kitty`, `fullscreen 0`, `movetoworkspace 3`. Dokumentasi Quickshell menyatakan: “Execute a hyprland dispatcher”.

**Peringatan `usingLua`:** Hyprland 0.55+ mendukung mode Lua, dan sintaks dispatcher berubah ketika mode ini aktif. Properti `Hyprland.usingLua` memberi tahu Anda apakah mode Lua aktif; jika ya, sesuaikan sintaks dispatcher Anda.

### Sintaks Dasar / Contoh Implementasi

**Membaca state:**

```qml
import Quickshell.Hyprland

Column {
    Text { text: "Workspace: " + (Hyprland.focusedWorkspace?.name ?? '?'); color: 'white' }
    Text { text: "Monitor: " + (Hyprland.focusedMonitor?.name ?? '?'); color: 'white' }
    Text { text: "Windows: " + Hyprland.toplevels.values.length; color: 'white' }
}
```

**Penjelasan kata-per-kata:**

- `Hyprland.focusedWorkspace`: `HyprlandWorkspace` yang sedang fokus, atau `null`.
- `?.name`: optional chaining; jika `null`, hasilnya `undefined`.
- `?? '?'`: fallback string.
- `Hyprland.focusedMonitor`: `HyprlandMonitor` yang sedang fokus, atau `null`.
- `Hyprland.toplevels.values.length`: `toplevels` adalah `ObjectModel<HyprlandToplevel>`; `.values` mengembalikan array; `.length` menghitung jumlah jendela.

**Mengirim perintah:**

```qml
Hyprland.dispatch('workspace 2')
Hyprland.dispatch('exec kitty')
Hyprland.dispatch('fullscreen 0')
```

**Penjelasan:**

- `Hyprland.dispatch(request)`: mengirim string dispatcher ke Hyprland.
- `'workspace 2'`: pindah ke workspace 2.
- `'exec kitty'`: menjalankan `kitty` (terminal) sebagai proses baru.
- `'fullscreen 0'`: toggle fullscreen mode 0 (full screen penuh; mode 1 adalah maximize yang mempertahankan gap/bar).

**Opsi lain untuk tujuan yang sama:**

| Tujuan | Quickshell | `hyprctl` | Catatan |
|---|---|---|---|
| Pindah workspace | `Hyprland.dispatch('workspace 2')` | `hyprctl dispatch workspace 2` | Quickshell lebih reaktif di QML. |
| Fullscreen | `Hyprland.dispatch('fullscreen 0')` | `hyprctl dispatch fullscreen 0` | Mode 0 vs 1 berbeda. |
| Exec | `Hyprland.dispatch('exec kitty')` | `hyprctl dispatch exec kitty` | Environment diwariskan dari shell. |

### Visualisasi: Aliran `dispatch()` ke Compositor

```text
QML: Hyprland.dispatch('workspace 2')
        │
        ▼
┌───────────────────────────────┐
│ Quickshell.Hyprland           │
│  membuka .socket.sock         │
│  menulis "workspace 2"        │
│  menunggu balasan (sinkron)   │
│  menutup koneksi              │
└───────────────────────────────┘
        │
        ▼
┌───────────────────────────────┐
│ Hyprland                      │
│  mengeksekusi dispatcher      │
│  mengubah workspace fokus     │
│  mengirim event ke .socket2   │
└───────────────────────────────┘
        │
        ▼
QML: Hyprland.focusedWorkspace diperbarui secara reaktif
```

**Penjelasan:** `dispatch()` bersifat sinkron pada tingkat socket (menunggu balasan), tetapi efeknya pada state compositor dipropagasikan secara asinkron melalui event socket. UI Anda akan diperbarui ketika event `workspace` diterima.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`Hyprland` (singleton)** | Objek QML yang menyediakan state dan dispatcher Hyprland. |
| **`dispatch()`** | Fungsi untuk menjalankan dispatcher Hyprland. |
| **`usingLua`** | Properti yang menandakan mode Lua Hyprland (0.55+); sintaks dispatcher berubah. |
| **`ObjectModel<T>`** | Model QML yang berisi daftar objek bertipe; mendukung `.values`. |

### Hubungan dengan Modul Lain

- **Modul 2.1:** `Hyprland.dispatch()` dapat memengaruhi layer surface (misalnya menutup overlay) melalui dispatcher yang sesuai.
- **Modul 2.4:** Launcher dapat memanggil `Hyprland.dispatch('exec ...')` untuk meluncurkan aplikasi yang dipilih.
- **Modul 2.5:** `Hyprland.dispatch()` dapat dipanggil dari handler keyboard setelah fokus QML tercapai.

### Sumber Referensi

- Quickshell — `Hyprland`: https://quickshell.org/docs/v0.3.0/types/Quickshell.Hyprland/Hyprland/
- Hyprland Wiki — Dispatchers: https://wiki.hypr.land/Configuring/Dispatchers/
- Hyprland Wiki — Using `hyprctl`: https://wiki.hypr.land/Configuring/Using-hyprctl/

### Tips dan Praktik Terbaik

- **Periksa `Hyprland.usingLua` sebelum mengirim dispatcher.** Jika `true`, sintaks dispatcher mungkin berbeda.
- **Gunakan `dispatch()` untuk perintah yang memengaruhi compositor; gunakan `IpcHandler` untuk mengekspos aksi shell ke luar.** Keduanya berbeda arah.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Memanggil `dispatch()` sebelum Hyprland siap | Error atau perintah diabaikan | Periksa `Hyprland` sudah terinisialisasi (misalnya `usingLua` bukan `false` default). |
| Mengira `dispatch()` memperbarui state secara instan | UI terlambat | State diperbarui melalui event; gunakan properti reaktif. |

---

## 4. `Quickshell.I3` untuk Sway/i3: Protokol `i3-ipc`

### Deskripsi Konkret & Peran dalam Kurikulum

`Quickshell.I3` adalah modul untuk **i3 dan Sway** (tidak ada modul `Quickshell.Sway`). Ia membungkus protokol IPC yang sama yang digunakan oleh i3 dan Sway, yang menggunakan **magic string `i3-ipc`** dan **header 14-byte**:

- 6 byte: `i3-ipc` (magic string)
- 4 byte: panjang payload (32-bit, native byte order)
- 4 byte: tipe pesan (32-bit, native byte order)
- Payload: JSON (untuk sebagian besar pesan).

Socket path disimpan di `$SWAYSOCK` (Sway) atau `$I3SOCK` (i3, untuk kompatibilitas). Quickshell membaca environment ini secara internal.

**Mengapa penting:** Tidak semua pengguna Hyprland. Sway dan i3 adalah compositor/window manager populer yang menggunakan protokol IPC yang sama. Shell yang mendukung keduanya memiliki jangkauan lebih luas.

### Konsep Kunci & Filosofi

**Protokol yang sama, dua implementasi:** Sway adalah implementasi Wayland dari i3 (X11). Keduanya berbagi protokol IPC yang sama: `i3-ipc`. Ini berarti kode shell Anda dapat bekerja di kedua lingkungan tanpa perubahan berarti, asalkan Anda menggunakan `Quickshell.I3`.

**Keterbatasan dibanding Hyprland:** Sway/i3 IPC tidak memiliki padanan langsung untuk `GlobalShortcut` Hyprland. Untuk pintasan global di Sway, Anda harus menggunakan `IpcHandler` + keybind di konfigurasi Sway (`bindsym $mod+b exec qs ipc call ...`). Ini adalah perbedaan arsitektural yang penting.

**Tipe yang tersedia:** `I3Workspace`, `I3Monitor`, `I3Event`, dan `I3IpcListener`. Properti utama: `workspaces`, `focusedWorkspace`, `monitors`, `focusedMonitor`, `socketPath`.

### Sintaks Dasar / Contoh Implementasi

**Membaca state:**

```qml
import Quickshell.I3

Text { text: I3.focusedWorkspace?.name ?? '?'; color: 'white' }
Text { text: I3.monitors.values.length + ' monitor'; color: 'white' }
```

**Penjelasan:**

- `I3.focusedWorkspace`: `I3Workspace` yang sedang fokus, atau `null`.
- `I3.monitors`: `ObjectModel<I3Monitor>`; `.values.length` menghitung jumlah monitor.

**Mengirim perintah:**

```qml
I3.dispatch('workspace 2')
I3.dispatch('exec kitty')
I3.dispatch('fullscreen toggle')
```

**Penjelasan:**

- `I3.dispatch(request)`: menjalankan perintah i3/Sway melalui socket IPC.
- `'workspace 2'`: pindah workspace.
- `'exec kitty'`: jalankan terminal.
- `'fullscreen toggle'`: toggle fullscreen (perintah Sway/i3).

**Opsi lain untuk tujuan yang sama:**

| Tujuan | Quickshell | `swaymsg` | `i3-msg` |
|---|---|---|---|
| Pindah workspace | `I3.dispatch('workspace 2')` | `swaymsg workspace 2` | `i3-msg workspace 2` |
| Exec | `I3.dispatch('exec kitty')` | `swaymsg exec kitty` | `i3-msg exec kitty` |
| Fullscreen | `I3.dispatch('fullscreen toggle')` | `swaymsg fullscreen toggle` | `i3-msg fullscreen toggle` |

### Visualisasi: Header Protokol `i3-ipc`

```text
┌────────────┬────────────────┬────────────────┬─────────────────┐
│ "i3-ipc"   │ payload length │ message type   │ payload (JSON)  │
│ 6 byte     │ 4 byte (LE)    │ 4 byte (LE)    │ variabel        │
└────────────┴────────────────┴────────────────┴─────────────────┘
Total header: 14 byte
```

**Penjelasan:** Setiap pesan diawali dengan magic string `i3-ipc` untuk kompatibilitas. Panjang payload dan tipe pesan adalah integer 32-bit dalam *native byte order*. Payload adalah JSON (kecuali untuk `RUN_COMMAND` yang mengembalikan array objek, dan beberapa tipe lain). Quickshell menangani serialisasi/deserialisasi ini secara internal, tetapi memahami struktur ini membantu Anda men-debug jika koneksi gagal.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`i3-ipc`** | Magic string yang menandai awal setiap pesan IPC i3/Sway. |
| **`SWAYSOCK` / `I3SOCK`** | Environment variable yang menyimpan path socket. |
| **`RUN_COMMAND`** | Tipe pesan (0) untuk menjalankan perintah; mengembalikan array objek hasil. |
| **`SUBSCRIBE`** | Tipe pesan (2) untuk berlangganan event; payload adalah array JSON berisi nama event. |

### Hubungan dengan Modul Lain

- **Modul 2.1:** Layer-shell bekerja sama di Sway; `Quickshell.I3` memberi state yang diperlukan untuk UI layer-shell di Sway.
- **Modul 2.4:** Launcher yang mendukung Sway harus menggunakan `Quickshell.I3` untuk meluncurkan aplikasi dan membaca workspace.
- **Modul 2.5:** Untuk pintasan global di Sway, gunakan `IpcHandler` + `bindsym`.

### Sumber Referensi

- Quickshell — `I3`: https://quickshell.org/docs/v0.2.1/types/Quickshell.I3/I3
- `sway-ipc(7)` — Debian manpages: https://manpages.debian.org/trixie/sway/sway-ipc.7.en.html
- i3 IPC documentation: https://i3wm.org/docs/ipc.html

### Tips dan Praktik Terbaik

- **Jangan meng-hardcode path socket.** Gunakan `I3.socketPath` atau biarkan Quickshell membacanya dari environment.
- **Untuk Sway, `fullscreen toggle` adalah perintah yang valid; untuk Hyprland, gunakan `fullscreen 0` atau `fullscreen 1`.** Jangan mencampur sintaks.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Mengimpor `Quickshell.Sway` | Modul tidak ditemukan | Gunakan `Quickshell.I3`. |
| Menggunakan sintaks dispatcher Hyprland di Sway | Perintah gagal | Gunakan perintah Sway (`fullscreen toggle`, bukan `fullscreen 0`). |
| Tidak memeriksa `SWAYSOCK` | Koneksi gagal | Pastikan berada di sesi Sway; `echo $SWAYSOCK`. |

---

## 5. `IpcHandler` dan `qs ipc`: Mengekspos Aksi Shell ke CLI/Keyboard

### Deskripsi Konkret & Peran dalam Kurikulum

`IpcHandler` adalah tipe QML yang **mengekspos fungsi dan properti** ke dunia luar melalui perintah `qs ipc`. Ini adalah kebalikan dari `Quickshell.Hyprland`/`I3`: jika modul compositor memungkinkan shell **membaca/mengirim** ke compositor, `IpcHandler` memungkinkan **keybind atau skrip eksternal** memanggil fungsi **di dalam shell Anda**.

**Mengapa penting:** Inilah mekanisme yang memungkinkan Anda mengikat tombol keyboard (misalnya `SUPER+B`) untuk memanggil `qs ipc call bar toggle`, yang kemudian menjalankan fungsi QML di shell Anda. Tanpa `IpcHandler`, shell Anda hanya bisa bereaksi terhadap state compositor, tetapi tidak bisa dipicu dari luar.

### Konsep Kunci & Filosofi

**Tipe eksplisit wajib:** Dokumentasi Quickshell menyatakan: “Argument and return types must be explicitly specified or they will not be registered”. Ini karena IPC adalah batas proses: QML harus mengetahui tipe data yang akan diserialisasi/deserialisasi. Tipe yang didukung: `string`, `int`, `bool`, `real`, `color`.

**Target unik:** Setiap `IpcHandler` memiliki `target` yang harus unik dalam satu instance Quickshell. Ini mencegah tabrakan nama saat beberapa handler diekspos.

**Fungsi vs properti:** Fungsi diekspos melalui `qs ipc call`; properti diekspos melalui `qs ipc prop get` (dan dapat diubah dengan `qs ipc prop set` jika tipenya kompatibel).

**Batas 10 argumen:** Fungsi IPC dapat memiliki paling banyak 10 argumen. Ini adalah batasan praktis untuk menjaga antarmuka tetap sederhana.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Io

PanelWindow {
    id: bar
    // ... properti bar ...

    IpcHandler {
        target: 'bar'

        function toggle(): void {
            bar.visible = !bar.visible
        }

        function show(): void {
            bar.visible = true
        }

        function hide(): void {
            bar.visible = false
        }

        function isVisible(): bool {
            return bar.visible
        }
    }
}
```

**Penjelasan kata-per-kata:**

- `import Quickshell.Io`: mengimpor modul IO yang berisi `IpcHandler`.
- `IpcHandler { ... }`: objek yang mendaftarkan fungsi ke sistem IPC Quickshell.
- `target: 'bar'`: nama target yang akan digunakan di CLI: `qs ipc call bar toggle`.
- `function toggle(): void { ... }`: fungsi dengan **parameter kosong** dan **return type `void`**. Tipe eksplisit (`: void`) wajib agar terdaftar.
- `bar.visible = !bar.visible`: membalik visibilitas `PanelWindow` dengan `id: bar`.
- `function isVisible(): bool { ... }`: fungsi dengan return type `bool`. Hasilnya akan dikembalikan sebagai `"true"` atau `"false"` di CLI.

**Memanggil dari terminal:**

```bash
qs ipc show
qs ipc call bar toggle
qs ipc call bar isVisible
```

**Penjelasan:**

- `qs ipc show`: menampilkan daftar target dan fungsi yang terdaftar.
- `qs ipc call bar toggle`: memanggil fungsi `toggle` pada target `bar`.
- `qs ipc call bar isVisible`: memanggil fungsi `isVisible` dan mencetak hasilnya (`true`/`false`).

**Memasang keybind Hyprland:**

```text
bind = SUPER, B, exec, qs ipc call bar toggle
```

**Penjelasan:** `bind = SUPER, B, exec, ...` adalah sintaks keybind Hyprland: tombol `SUPER` + `B` menjalankan perintah shell `qs ipc call bar toggle`. Ini adalah **jalur CLI**, bukan `GlobalShortcut` native.

**Memasang keybind Sway:**

```text
bindsym $mod+b exec qs ipc call bar toggle
```

**Penjelasan:** `bindsym` adalah sintaks Sway/i3; `$mod+b` adalah kombinasi tombol; `exec` menjalankan perintah shell.

**Opsi lain untuk tujuan yang sama:**

| Skenario | Mekanisme | Contoh |
|---|---|---|
| Keybind Hyprland → shell | `IpcHandler` + `exec` | `bind = SUPER, B, exec, qs ipc call bar toggle` |
| Keybind Sway → shell | `IpcHandler` + `exec` | `bindsym $mod+b exec qs ipc call bar toggle` |
| Keybind Hyprland → shell (native) | `GlobalShortcut` | `bind = SUPER, B, global, quickshell:barToggle` |
| Skrip eksternal → shell | `IpcHandler` | `qs ipc call bar show` |

### Visualisasi: Alur `IpcHandler`

```text
Keyboard (SUPER+B)
        │
        ▼
Hyprland keybind: exec qs ipc call bar toggle
        │
        ▼
┌───────────────────────────────┐
│ Proses baru: qs ipc call      │
│  → menghubungi instance       │
│    Quickshell yang berjalan   │
│  → mencari target "bar"       │
│  → memanggil fungsi toggle()  │
└───────────────────────────────┘
        │
        ▼
QML: bar.visible = !bar.visible
```

**Penjelasan:** `exec` di keybind melahirkan proses `qs` baru. Proses ini berbicara dengan instance Quickshell yang sudah berjalan melalui mekanisme IPC internal Quickshell, menemukan `IpcHandler` dengan target `bar`, dan memanggil fungsinya. Ini adalah **round-trip melalui proses baru**, yang menambah latensi kecil tetapi sangat fleksibel.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`IpcHandler`** | Tipe QML yang mengekspos fungsi/properti ke `qs ipc`. |
| **`target`** | Nama unik handler; digunakan di `qs ipc call <target>`. |
| **`qs ipc`** | Perintah CLI untuk berinteraksi dengan instance Quickshell. |
| **Tipe IPC-compatible** | `string`, `int`, `bool`, `real`, `color`; tipe eksplisit wajib. |

### Hubungan dengan Modul Lain

- **Modul 2.1:** `IpcHandler` dapat memanggil `toggle` pada launcher overlay, yang mengubah `keyboardFocus` antara `None` dan `Exclusive`.
- **Modul 2.4:** Launcher dan notifikasi dapat diekspos melalui `IpcHandler` untuk keybind.
- **Modul 2.5:** `IpcHandler` adalah salah satu dari dua jalur keyboard-to-shell; jalur lainnya adalah `GlobalShortcut`.

### Sumber Referensi

- Quickshell — `IpcHandler`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Io/IpcHandler/
- Quickshell — IPC guide (jika tersedia): https://quickshell.org/docs/

### Tips dan Praktik Terbaik

- **Selalu tentukan tipe parameter dan return type.** Tanpa tipe eksplisit, fungsi tidak akan terdaftar.
- **Gunakan `target` yang deskriptif dan unik** (misalnya `bar`, `launcher`, `notificationCenter`).
- **Batasi jumlah argumen.** Batas 10 argumen sudah lebih dari cukup; jika Anda membutuhkan lebih, pertimbangkan untuk memecah fungsi.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak menentukan tipe return | Fungsi tidak muncul di `qs ipc show` | Tambahkan `: void`, `: bool`, dll. |
| Target duplikat | Handler saling menimpa | Gunakan target unik. |
| Memanggil fungsi dengan argumen yang salah tipe | Error parsing | Pastikan tipe argumen sesuai (`int`, `string`, dll.). |

---

## 6. `GlobalShortcut`: Pintasan Global Native Hyprland

### Deskripsi Konkret & Peran dalam Kurikulum

`GlobalShortcut` adalah tipe QML yang mendaftarkan pintasan global melalui protokol **`hyprland_global_shortcuts_v1`**. Berbeda dari `IpcHandler` yang melalui CLI, `GlobalShortcut` bekerja **langsung di dalam proses Quickshell**: Hyprland mengirim event tombol ke Quickshell, dan handler QML dipanggil tanpa melahirkan proses baru.

**Mengapa penting:** Untuk pintasan yang sering digunakan (misalnya toggle launcher dengan `SUPER+Space`), `GlobalShortcut` lebih efisien karena tidak ada *spawn process* setiap kali tombol ditekan. Dokumentasi DeepWiki menyatakan: “This is more efficient than IPC as it avoids spawning new processes for frequent UI toggles”.

### Konsep Kunci & Filosofi

**Protokol khusus Hyprland:** `GlobalShortcut` **hanya berfungsi di Hyprland**. Ia tidak menggunakan `xdg-desktop-portal` karena portal tersebut “not fully functional without flatpak”. Ini adalah trade-off: Anda mendapatkan efisiensi dan integrasi langsung, tetapi kehilangan portabilitas ke compositor lain.

**Pasangan `appid` + `name`:** Setiap pintasan diidentifikasi oleh pasangan `appid` dan `name`. Pasangan ini **tidak boleh duplikat**; jika dua klien mencoba mendaftarkan pasangan yang sama, klien terakhir akan crash. Dalam satu instance Quickshell, konflik internal ditangani, tetapi konflik dengan instance Quickshell lain atau XDPH dapat terjadi.

**Tidak dapat diubah saat runtime:** `name`, `appid`, dan `description` tidak dapat diubah setelah registrasi. Ini karena protokol mendaftarkan pintasan sekali dan tidak menyediakan mekanisme perubahan.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell.Hyprland

GlobalShortcut {
    appid: 'quickshell'
    name: 'launcher'
    description: 'Toggle application launcher'
    onPressed: launcher.visible = !launcher.visible
}
```

**Penjelasan kata-per-kata:**

- `import Quickshell.Hyprland`: mengimpor modul Hyprland yang berisi `GlobalShortcut`.
- `GlobalShortcut { ... }`: objek yang mendaftarkan pintasan global.
- `appid: 'quickshell'`: ID aplikasi. Defaultnya adalah `quickshell`. Anda dapat menggantinya, tetapi tidak saat runtime.
- `name: 'launcher'`: nama pintasan. Pasangan `appid:name` harus unik.
- `description: 'Toggle application launcher'`: deskripsi yang muncul di `hyprctl globalshortcuts`.
- `onPressed: ...`: handler yang dipanggil ketika pintasan ditekan. Di sini, membalik visibilitas `launcher` (misalnya `PanelWindow` dengan `id: launcher`).

**Mendaftarkan keybind di Hyprland:**

```text
bind = SUPER, space, global, quickshell:launcher
```

**Penjelasan:**

- `bind = SUPER, space, global, ...`: sintaks keybind Hyprland untuk pintasan global.
- `quickshell:launcher`: pasangan `appid:name` yang cocok dengan `GlobalShortcut` di atas. Hyprland akan mengirim event ke Quickshell ketika tombol ditekan.

**Memeriksa pintasan yang terdaftar:**

```bash
hyprctl globalshortcuts
```

**Penjelasan:** Perintah ini menampilkan daftar pintasan global yang terdaftar, termasuk `appid`, `name`, dan `description`. Ini berguna untuk debugging collision atau memverifikasi registrasi.

**Opsi lain untuk tujuan yang sama:**

| Skenario | Mekanisme | Efisiensi | Portabilitas |
|---|---|---|---|
| Toggle launcher sering | `GlobalShortcut` | Tinggi (tanpa spawn) | Hanya Hyprland |
| Toggle bar jarang | `IpcHandler` + `exec` | Sedang (spawn process) | Hyprland, Sway, i3 |
| Aksi yang perlu argumen kompleks | `IpcHandler` | Sedang | Luas |
| Aksi yang perlu state `pressed`/`released` | `GlobalShortcut` | Tinggi | Hanya Hyprland |

### Visualisasi: Perbedaan `GlobalShortcut` vs `IpcHandler`

```text
GlobalShortcut:
Keyboard → Hyprland → (protokol global shortcuts) → Quickshell.onPressed
  Tidak ada proses baru; latensi rendah.

IpcHandler:
Keyboard → Hyprland keybind (exec) → proses `qs` baru → IPC internal → Quickshell.fungsi
  Ada spawn process; lebih fleksibel tetapi lebih berat.
```

**Penjelasan:** `GlobalShortcut` adalah jalur langsung di dalam proses; `IpcHandler` adalah jalur melalui proses CLI. Untuk toggle UI yang sering, `GlobalShortcut` lebih baik. Untuk aksi yang jarang atau membutuhkan argumen dari CLI, `IpcHandler` lebih fleksibel.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`hyprland_global_shortcuts_v1`** | Protokol Hyprland untuk pintasan global. |
| **`appid`** | ID aplikasi pendaftar pintasan; default `quickshell`. |
| **`name`** | Nama pintasan; pasangan `appid:name` harus unik. |
| **`onPressed`** | Handler QML yang dipanggil saat pintasan ditekan. |
| **`hyprctl globalshortcuts`** | Perintah untuk melihat pintasan yang terdaftar. |

### Hubungan dengan Modul Lain

- **Modul 2.1:** `GlobalShortcut` dapat memanggil launcher, yang mengubah `keyboardFocus` layer-shell.
- **Modul 2.5:** `GlobalShortcut` adalah alternatif dari rantai fokus QML untuk memicu aksi tanpa harus fokus ke jendela tertentu.
- **Modul 4.2 (Keamanan):** `GlobalShortcut` tidak memerlukan autentikasi; siapa pun dengan akses ke sesi dapat memicunya. Ini adalah pertimbangan keamanan.

### Sumber Referensi

- Quickshell — `GlobalShortcut`: https://quickshell.org/docs/v0.3.0/types/Quickshell.Hyprland/GlobalShortcut/
- Hyprland Wiki — Binds (DBus global shortcuts): https://wiki.hyprland.org/Configuring/Binds/#dbus-global-shortcuts
- Protokol `hyprland-global-shortcuts-v1`: https://github.com/hyprwm/hyprland-protocols/blob/main/protocols/hyprland-global-shortcuts-v1.xml

### Tips dan Praktik Terbaik

- **Gunakan `GlobalShortcut` untuk pintasan yang sering dan sederhana** (toggle launcher, toggle bar).
- **Gunakan `IpcHandler` untuk aksi yang jarang, membutuhkan argumen, atau harus portabel ke Sway/i3.**
- **Hindari duplikasi `appid:name`**; jika Anda memiliki beberapa pintasan, subklas `GlobalShortcut` atau gunakan `appid` yang berbeda.
- **Periksa `hyprctl globalshortcuts` setelah registrasi** untuk memastikan tidak ada collision.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Dua `GlobalShortcut` dengan `appid:name` sama | Klien terakhir crash | Pastikan pasangan unik; gunakan `name` berbeda. |
| Mengubah `name` saat runtime | Tidak berpengaruh | Atur sekali saat deklarasi. |
| Menggunakan `GlobalShortcut` di Sway | Tidak berfungsi | Gunakan `IpcHandler` + `bindsym` untuk Sway. |

---

## 7. Perbandingan dan Pemilihan Mekanisme

### Tabel Perbandingan

| Kriteria | `Quickshell.Hyprland` / `I3` | `IpcHandler` | `GlobalShortcut` | `hyprctl` / `swaymsg` langsung |
|---|---|---|---|---|
| **Arah** | Shell → compositor (baca/tulis) | Luar → shell | Keyboard → shell (native) | Shell/CLI → compositor |
| **Portabilitas** | Hyprland / i3-Sway | Semua (selama ada `qs`) | Hanya Hyprland | Hyprland / Sway |
| **Efisiensi** | Tinggi (socket persisten) | Sedang (spawn process) | Tinggi (tanpa spawn) | Sedang (spawn process) |
| **Reaktif di QML** | Ya | Tidak (kecuali dipanggil) | Ya (`onPressed`) | Tidak |
| **Argumen kompleks** | Ya (string dispatcher) | Ya (hingga 10 argumen) | Tidak (hanya event) | Ya (string perintah) |
| **Keamanan** | Tergantung environment | Tergantung environment | Tidak ada autentikasi | Tergantung environment |

**Panduan pemilihan:**

- **Gunakan `Quickshell.Hyprland`/`I3`** untuk membaca state dan mengirim perintah compositor dari dalam QML.
- **Gunakan `IpcHandler`** untuk mengekspos aksi shell ke keybind atau skrip eksternal, terutama jika Anda membutuhkan portabilitas ke Sway/i3 atau argumen dari CLI.
- **Gunakan `GlobalShortcut`** untuk pintasan Hyprland yang sering dan sederhana, di mana efisiensi lebih penting daripada portabilitas.
- **Gunakan `hyprctl`/`swaymsg` langsung** hanya untuk skrip di luar Quickshell; di dalam QML, gunakan modul Quickshell.

---

## 8. Keamanan dan Lingkungan Sesi (Materi Tambahan)

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini tidak secara eksplisit ada di kurikulum, tetapi penting untuk prinsip keamanan yang Anda tekankan. Ketika `qs ipc call` dijalankan dari keybind, atau ketika shell meluncurkan aplikasi melalui `Hyprland.dispatch('exec ...')`, proses baru **mewarisi environment shell**. Ini berarti variabel seperti `SSH_AUTH_SOCK`, `GPG_AGENT_INFO`, atau token rahasia lainnya dapat tersedia bagi proses yang diluncurkan.

**Mengapa penting:** Shell yang “tidak menyimpan rahasia di environment-nya” adalah prinsip yang disebutkan di Modul 2.4, tetapi relevan di sini karena IPC dan peluncuran aplikasi adalah titik di mana environment diwariskan.

### Konsep Kunci & Filosofi

**Prinsip least privilege:** Jangan menaruh rahasia di environment shell. Jika Anda harus menggunakan rahasia, gunakan agen (ssh-agent, gpg-agent) yang membatasi akses, atau mekanisme yang tidak mewarisi environment secara penuh.

**Isolasi proses:** `qs ipc call` melahirkan proses baru yang mewarisi environment. Jika shell Anda berjalan dengan environment yang “kaya”, proses `qs` juga akan mewarisinya. Ini bukan celah keamanan langsung, tetapi memperluas permukaan serangan.

### Tips dan Praktik Terbaik

- **Jangan menyimpan rahasia di environment shell.** Gunakan file dengan izin ketat atau agen.
- **Untuk peluncuran aplikasi, pertimbangkan untuk membersihkan environment** jika aplikasi tidak memerlukannya. Namun, ini dapat memutus akses ke display/DBus; lakukan dengan hati-hati.
- **`qs ipc call` adalah proses lokal; pastikan hanya pengguna yang sama dapat mengakses socket IPC Quickshell.** Quickshell menggunakan mekanisme IPC internal; pastikan izin file socket sesuai.

---

## 9. Debugging

### Alat dan Perintah

| Alat | Tujuan | Contoh |
|---|---|---|
| `qs ipc show` | Daftar target dan fungsi IPC | `qs ipc show` |
| `qs ipc call` | Memanggil fungsi | `qs ipc call bar toggle` |
| `hyprctl globalshortcuts` | Daftar pintasan global Hyprland | `hyprctl globalshortcuts` |
| `hyprctl dispatch` | Mengirim dispatcher dari CLI | `hyprctl dispatch workspace 2` |
| `socat` ke `.socket2.sock` | Mendengarkan event Hyprland | `socat -U - UNIX-CONNECT:...` |
| `swaymsg -t get_workspaces` | Mendapatkan workspace Sway (JSON) | `swaymsg -t get_workspaces` |
| `echo $SWAYSOCK` | Memeriksa path socket Sway | `echo $SWAYSOCK` |

### Alur Debugging

```text
Masalah: Keybind tidak memicu shell
        │
        ▼
1. Apakah keybind terdaftar? (hyprctl binds / config Sway)
        │
        ▼
2. Apakah perintah di keybind berjalan? (jalankan manual di terminal)
        │
        ▼
3. Apakah target IpcHandler terdaftar? (qs ipc show)
        │
        ▼
4. Apakah fungsi dipanggil? (tambahkan console.log di QML)
        │
        ▼
5. Jika GlobalShortcut: apakah terdaftar? (hyprctl globalshortcuts)
```

---

## 10. Latihan dan Checkpoint

### Latihan (sesuai kurikulum)

**Ekspos tiga aksi (`toggle`, `show`, `hide`) lewat `IpcHandler` dan pasang keybind untuk masing-masing.**

**Langkah-langkah:**

1. Buat `PanelWindow` dengan `id: bar`.
2. Tambahkan `IpcHandler` dengan `target: 'bar'` dan tiga fungsi: `toggle(): void`, `show(): void`, `hide(): void`.
3. Jalankan `qs ipc show` untuk memverifikasi target dan fungsi terdaftar.
4. Uji manual: `qs ipc call bar toggle`, `qs ipc call bar show`, `qs ipc call bar hide`.
5. Pasang keybind Hyprland:
   ```text
   bind = SUPER, B, exec, qs ipc call bar toggle
   bind = SUPER SHIFT, B, exec, qs ipc call bar show
   bind = SUPER ALT, B, exec, qs ipc call bar hide
   ```
6. Pasang keybind Sway (jika menggunakan Sway):
   ```text
   bindsym $mod+b exec qs ipc call bar toggle
   bindsym $mod+Shift+b exec qs ipc call bar show
   bindsym $mod+Alt+b exec qs ipc call bar hide
   ```
7. Uji setiap keybind dan pastikan bar merespons.

**Checkpoint:** Jelaskan mengapa fungsi `IpcHandler` wajib memiliki tipe parameter dan tipe kembalian yang eksplisit.

**Jawaban singkat:** IPC adalah batas proses. Quickshell harus mengetahui tipe data yang akan diserialisasi/dideserialisasi untuk mengirimkan argumen dari CLI dan mengembalikan hasil. Tanpa tipe eksplisit, fungsi tidak dapat didaftarkan karena sistem IPC tidak dapat menentukan bagaimana menangani data.

---

## Motivasi

IPC adalah yang membuat shell Anda “hidup” di dalam ekosistem compositor. Anda tidak hanya menggambar di atas layar; Anda membaca detak jantung compositor dan meresponsnya. Kuasai dua arah komunikasi ini—dari compositor ke shell, dan dari keyboard ke shell—maka Anda memiliki kendali penuh atas lingkungan desktop Anda. Teruslah bereksperimen; setiap keybind yang berhasil adalah satu langkah lebih dekat ke desktop yang sepenuhnya Anda kendalikan.

---

Kita lanjutkan ke **Modul 2.3 — Layanan Desktop: PipeWire, MPRIS, UPower, dan Bluetooth**.

---

## Audit Singkat Modul 2.3

**Temuan audit:**

1. **Kurikulum menyebut “tiga jebakan akurasi”** — (1) properti PipeWire tidak valid sebelum di-bind, (2) skala nilai harus diverifikasi, (3) properti MPRIS bernama `trackTitle`, bukan `track.title`. Ini sudah tepat, tetapi perlu penjabaran teknis *mengapa* masing-masing terjadi, bukan sekadar *apa*.

2. **`PwObjectTracker` disebut “WAJIB”** — dokumentasi Quickshell mengonfirmasi: “By default, pipewire objects are unbound. Unbound objects only have a subset of information available for use or modification.” Namun, tidak semua properti memerlukan binding; hanya properti yang “clearly marked” sebagai requiring binding. Materi ini akan mengklarifikasi nuansa tersebut agar tidak terjadi over-binding yang tidak perlu.

3. **Skala UPower** — dokumentasi `UPowerDevice.percentage` menyatakan: “Current charge level as a percentage. This would be equivalent to `energy / energyCapacity`.” Ini berarti nilainya adalah **fraksi 0.0–1.0**, bukan 0–100. Kurikulum sudah menyinggung “verifikasi skala 0–1”, dan materi ini akan menegaskan bahwa `Math.round(percentage * 100)` adalah pola yang benar.

4. **Bluetooth** — kurikulum menyebut “modul terpisah dari `Services.*`; periksa referensi versi Anda.” Ini akurat: `Quickshell.Bluetooth` berada di namespace `Quickshell.Bluetooth`, bukan `Quickshell.Services.Bluetooth`. Materi ini akan menegaskan perbedaan tersebut.

5. **Tidak ada pembahasan tentang D-Bus sebagai fondasi** — MPRIS, UPower, dan BlueZ semuanya berbicara melalui D-Bus. Kurikulum menyebut D-Bus sebagai terminologi, tetapi belum menjelaskan *bagaimana* Quickshell menjembatani D-Bus ke QML. Materi ini akan menambahkan lapisan penjelasan D-Bus sebagai **materi tambahan** yang tetap mengacu pada kurikulum.

Dengan catatan ini, saya akan membangun Modul 2.3 selengkap mungkin.

---

# Modul 2.3 — Layanan Desktop: PipeWire, MPRIS, UPower, dan Bluetooth

> *“Shell yang hebat bukan yang menggambar paling indah, tetapi yang tahu apa yang sedang terjadi di mesinnya—dan bertindak atas pengetahuan itu.”*

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Mengapa layanan desktop penting: filosofi shell sebagai pusat informasi** — shell tidak boleh buta terhadap state sistem.
2. **D-Bus sebagai fondasi (materi tambahan)** — bagaimana MPRIS, UPower, dan BlueZ berbicara; bagaimana Quickshell menjembatani.
3. **PipeWire: node, `PwObjectTracker`, volume, routing** — mengapa binding wajib, bagaimana skala bekerja.
4. **MPRIS: `players`, `trackTitle`, kontrol pemutaran** — properti yang benar, keterbatasan per-player.
5. **UPower: baterai, `displayDevice`, skala persentase, profil daya** — membaca state daya dengan akurat.
6. **Bluetooth: adapter, perangkat, `enabled`, discovery** — mengelola radio nirkabel dari QML.
7. **Verifikasi skala dan nilai kosong** — pola `?.`, `??`, dan `Math.min/max`.
8. **Praktik terbaik, kesalahan umum, latihan, dan checkpoint**.

---

## 1. Mengapa Layanan Desktop Penting: Filosofi Shell sebagai Pusat Informasi

### Deskripsi Konkret & Peran dalam Kurikulum

Modul 2.1 mengajarkan **di mana** menempatkan UI. Modul 2.2 mengajarkan **bagaimana** berbicara dengan compositor. Modul 2.3 mengajarkan **apa** yang harus ditampilkan: state audio, media, daya, dan Bluetooth. Tanpa integrasi ini, shell Anda hanyalah panel kosong yang cantik—tidak memiliki informasi yang membuatnya berguna.

**Mengapa penting:** Inilah titik di mana shell Anda menjadi **monolitik dalam fungsi** (satu proses mengelola semua informasi desktop) tetapi **modular dalam kode** (setiap layanan adalah modul QML terpisah). Anda tidak perlu menulis boilerplate D-Bus; Quickshell menyediakan tipe QML yang sudah reaktif.

### Konsep Kunci & Filosofi

**Filosofi “loket informasi”:** Setiap layanan desktop (PipeWire, MPRIS, UPower, BlueZ) sudah berjalan sebagai daemon di sistem Anda. Mereka adalah **sumber kebenaran** tentang state masing-masing. Quickshell tidak menggantikan mereka; ia menjadi **loket** yang menerjemahkan jawaban mereka ke bahasa QML. Anda tidak perlu peduli apakah jawaban itu datang melalui D-Bus, socket, atau protokol lain—Anda cukup mengakses properti QML.

**Analogi:** Bayangkan gedung dengan empat loket: loket audio (PipeWire), loket media (MPRIS), loket daya (UPower), dan loket nirkabel (BlueZ). Shell Anda adalah resepsionis yang berdiri di depan keempat loket, menanyakan pertanyaan yang tepat, dan menyajikan jawabannya kepada pengguna. Resepsionis tidak perlu tahu bagaimana loket bekerja secara internal; ia hanya perlu tahu **apa yang ditanyakan** dan **bagaimana membaca jawabannya**.

### Visualisasi: Shell sebagai Pusat Layanan

```text
┌──────────────────────────────────────────────────────┐
│                  QUICKSHELL (QML)                    │
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌────────┐  ┌─────────┐ │
│  │ Pipewire │  │  Mpris   │  │ UPower │  │Bluetooth│ │
│  │  Module  │  │  Module  │  │ Module │  │ Module  │ │
│  └────┬─────┘  └─────┬────┘  └────┬───┘  └────┬────┘ │
└───────┼──────────────┼────────────┼───────────┼──────┘
        │              │            │           │
        ▼              ▼            ▼           ▼
   ┌─────────┐   ┌──────────┐  ┌────────┐  ┌────────┐
   │PipeWire │   │  MPRIS   │  │ UPower │  │ BlueZ  │
   │ daemon  │   │ players  │  │ daemon │  │ daemon │
   └─────────┘   └──────────┘  └────────┘  └────────┘
        ▲              ▲            ▲           ▲
        │              │            │           │
        └──────────────┴────────────┴───────────┘
                    D-Bus / PipeWire API
```

**Penjelasan:** Setiap modul Quickshell berbicara dengan daemon yang sesuai. PipeWire menggunakan API PipeWire-nya sendiri (bukan D-Bus), sedangkan MPRIS, UPower, dan BlueZ menggunakan D-Bus. Quickshell menyembunyikan perbedaan protokol ini di balik antarmuka QML yang seragam.

### Hubungan dengan Modul Lain

- **Modul 2.4:** Notifikasi dan system tray juga merupakan layanan desktop; pola yang sama (D-Bus → QML) berlaku.
- **Modul 2.5:** Widget volume dan media yang Anda buat di sini akan memerlukan navigasi keyboard dan persistensi state.

### Sumber Referensi

- Quickshell — About (daftar integrasi bawaan): https://quickshell.org/docs/v0.3.0/guide/about/
- Quickshell — Module Listing: https://quickshell.org/docs/v0.3.1/types

---

## 2. D-Bus sebagai Fondasi (Materi Tambahan)

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini **tidak secara eksplisit** ada di kurikulum sebagai sub-bab, tetapi sangat penting. MPRIS, UPower, dan BlueZ semuanya berbicara melalui **D-Bus**, sistem pesan antar-proses di Linux. Memahami D-Bus pada tingkat konseptual membantu Anda men-debug ketika properti QML tidak diperbarui atau ketika layanan tidak terdeteksi.

**Mengapa ditambahkan:** Tanpa memahami D-Bus, Anda akan menganggap `Mpris.players` dan `UPower.displayDevice` sebagai “sihir.” Dengan memahami D-Bus, Anda tahu bahwa di balik layar Quickshell berlangganan sinyal (`PropertiesChanged`, `NameOwnerChanged`) dan memetakannya ke properti QML yang reaktif.

### Konsep Kunci & Filosofi

**D-Bus sebagai bus pesan:** D-Bus adalah **message bus**—bukan database, bukan API. Layanan mendaftarkan nama (misalnya `org.mpris.MediaPlayer2.spotify`), mengekspos objek dengan path (misalnya `/org/mpris/MediaPlayer2`), dan menyediakan **method**, **property**, serta **signal**. Klien (seperti Quickshell) memanggil method, membaca properti, dan berlangganan sinyal.

**Tiga lapisan D-Bus:**

1. **Bus:** System bus (layanan sistem seperti BlueZ, UPower) vs. Session bus (layanan pengguna seperti MPRIS player).
2. **Nama:** Setiap layanan memiliki nama unik (misalnya `:1.42`) dan nama well-known (misalnya `org.freedesktop.UPower`). Quickshell mencari nama well-known.
3. **Object path & interface:** Objek di path tertentu mengekspos interface (misalnya `org.freedesktop.DBus.Properties` untuk membaca properti).

**Mengapa ini penting untuk Quickshell:** Ketika Anda menulis `Mpris.players`, Quickshell telah:
- Berlangganan sinyal `NameOwnerChanged` di session bus untuk mendeteksi player baru.
- Membaca properti `org.mpris.MediaPlayer2.Player` dari setiap player.
- Memetakan hasilnya ke `ObjectModel<MprisPlayer>`.

### Sintaks Dasar / Contoh Implementasi

**Memeriksa layanan D-Bus yang aktif (terminal):**

```bash
busctl --user list | grep -i mpris
busctl --system list | grep -i upower
busctl --system list | grep -i bluez
```

**Penjelasan kata-per-kata:**

- `busctl --user list`: menampilkan layanan di **session bus** (pengguna). MPRIS player biasanya ada di sini.
- `grep -i mpris`: memfilter baris yang mengandung `mpris` (case-insensitive). Jika ada player aktif, Anda akan melihat nama seperti `org.mpris.MediaPlayer2.spotify`.
- `busctl --system list`: menampilkan layanan di **system bus**. UPower dan BlueZ ada di sini.
- `grep -i upower`: memfilter layanan UPower (`org.freedesktop.UPower`).
- `grep -i bluez`: memfilter layanan BlueZ (`org.bluez`).

**Membaca properti D-Bus secara langsung (untuk debugging):**

```bash
busctl --system get-property org.freedesktop.UPower /org/freedesktop/UPower/devices/DisplayDevice org.freedesktop.UPower.Device Percentage
```

**Penjelasan:** Perintah ini membaca properti `Percentage` dari objek `DisplayDevice` di layanan UPower. Hasilnya adalah nilai D-Bus (biasanya `d` untuk double). Ini adalah “nilai mentah” yang nantinya dipetakan Quickshell ke `UPower.displayDevice.percentage`.

**Opsi lain untuk tujuan yang sama:**

| Tujuan | Alat | Contoh |
|---|---|---|
| Daftar layanan session bus | `busctl --user list` | Melihat MPRIS player |
| Daftar layanan system bus | `busctl --system list` | Melihat UPower/BlueZ |
| Baca properti | `busctl get-property` | Debugging nilai mentah |
| Pantau sinyal | `dbus-monitor` | Melihat `PropertiesChanged` secara real-time |

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **D-Bus** | Sistem pesan antar-proses di Linux; digunakan oleh MPRIS, UPower, BlueZ, dan banyak layanan desktop. |
| **Session bus** | Bus untuk layanan pengguna (MPRIS player, notifikasi). |
| **System bus** | Bus untuk layanan sistem (UPower, BlueZ). |
| **Well-known name** | Nama layanan yang stabil (misalnya `org.freedesktop.UPower`). |
| **Object path** | Lokasi objek di dalam layanan (misalnya `/org/freedesktop/UPower/devices/DisplayDevice`). |
| **Interface** | Kumpulan method/property/signal pada objek (misalnya `org.freedesktop.UPower.Device`). |
| **`PropertiesChanged`** | Sinyal D-Bus yang memberi tahu klien bahwa properti berubah. |

### Tips dan Praktik Terbaik

- **Gunakan `busctl` untuk debugging, bukan untuk produksi.** Quickshell sudah menangani D-Bus; `busctl` hanya untuk memverifikasi bahwa layanan berjalan dan nilai mentahnya sesuai.
- **Jangan berasumsi semua layanan ada di bus yang sama.** MPRIS di session bus; UPower dan BlueZ di system bus. Quickshell menangani ini secara internal, tetapi penting untuk debugging.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Mencari MPRIS di system bus | Player tidak terdeteksi | MPRIS ada di session bus (`busctl --user`). |
| Mencari UPower di session bus | Layanan tidak ditemukan | UPower ada di system bus (`busctl --system`). |
| Tidak menjalankan daemon | Modul QML kosong | Pastikan `upowerd` dan `bluetoothd` berjalan. |

---

## 3. PipeWire: Node, `PwObjectTracker`, Volume, dan Routing

### Deskripsi Konkret & Peran dalam Kurikulum

PipeWire adalah server multimedia modern yang mengelola audio (dan video) di Linux. Quickshell mengeksposnya melalui `Quickshell.Services.Pipewire`, dengan tipe utama `Pipewire` (singleton), `PwNode` (node audio), dan `PwObjectTracker` (pengikat).

**Mengapa penting:** Widget volume adalah salah satu komponen shell paling umum. Namun, PipeWire memiliki jebakan: **properti audio tidak valid sampai node di-bind**. Tanpa `PwObjectTracker`, Anda akan melihat nilai `undefined` atau `0` yang tidak berubah.

### Konsep Kunci & Filosofi

**Node sebagai unit dasar:** Di PipeWire, segala sesuatu adalah **node**—sink (output), source (input), stream aplikasi, dan bahkan virtual device. `Pipewire.defaultAudioSink` mengembalikan `PwNode` untuk output default. Namun, `PwNode` hanyalah **referensi**; ia belum tentu “terhubung” ke data audio sampai di-bind.

**Mengapa binding diperlukan:** Dokumentasi Quickshell menyatakan: “By default, pipewire objects are unbound. Unbound objects only have a subset of information available for use or modification.” Binding memungkinkan Quickshell berlangganan perubahan properti audio (volume, mute) dan menyediakannya secara reaktif. Tanpa binding, properti seperti `audio.volume` mungkin tidak tersedia atau tidak diperbarui.

**Skala volume:** `audio.volume` adalah **float 0.0–1.0**, di mana `1.0` berarti 100%. Ini adalah skala PipeWire, bukan persentase 0–100. Anda harus mengalikan dengan 100 untuk tampilan, dan membagi dengan 100 untuk input.

### Sintaks Dasar / Contoh Implementasi

```qml
import QtQuick.Controls
import Quickshell.Services.Pipewire

Item {
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: [sink] }

    Slider {
        from: 0
        to: 1.0
        value: sink?.audio?.volume ?? 0
        onMoved: if (sink?.audio) sink.audio.volume = Math.min(value, 1.0)
    }
}
```

**Penjelasan kata-per-kata:**

- `readonly property var sink: Pipewire.defaultAudioSink`: menyimpan referensi ke sink audio default. Tipe `var` digunakan karena `PwNode` bisa `null`.
- `PwObjectTracker { objects: [sink] }`: **mengikat** sink sehingga properti `audio.volume` dan `audio.muted` tersedia dan reaktif. Tanpa ini, `sink.audio` mungkin tidak memiliki data yang valid.
- `from: 0; to: 1.0`: Slider menggunakan skala float 0–1, sesuai dengan skala PipeWire.
- `value: sink?.audio?.volume ?? 0`: binding reaktif. `?.` melindungi dari `null`; `??` memberi fallback `0` jika volume tidak tersedia.
- `onMoved: if (sink?.audio) sink.audio.volume = Math.min(value, 1.0)`: saat slider digerakkan, set volume. `Math.min(value, 1.0)` membatasi volume maksimum pada 1.0 (100%) untuk mencegah amplifikasi berlebihan.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Volume default sink | `Pipewire.defaultAudioSink` + `PwObjectTracker` | Pola standar. |
| Mute toggle | `sink.audio.muted = !sink.audio.muted` | Setelah binding. |
| Semua sink | `Pipewire.nodes.values.filter(n => n.isSink)` | Untuk routing lanjutan. |
| Volume aplikasi tertentu | Cari node dengan `isStream: true` | Perlu filter lebih lanjut. |

### Visualisasi: Binding dan Reaktivitas

```text
Sebelum binding:
┌─────────────────┐        ┌─────────────────┐
│ PwNode (sink)   │        │ Data audio      │
│ referensi ada   │  ─X─>  │ tidak tersedia  │
└─────────────────┘        └─────────────────┘

Setelah PwObjectTracker:
┌─────────────────┐        ┌─────────────────┐
│ PwNode (sink)   │        │ Data audio      │
│ referensi ada   │  ───>  │ volume, muted   │
└─────────────────┘        │ reaktif         │
                           └─────────────────┘
```

**Penjelasan:** Tanpa `PwObjectTracker`, `PwNode` hanya “kartu nama” tanpa data. Setelah binding, Quickshell berlangganan perubahan pada node tersebut dan menyediakan properti audio secara reaktif.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **PipeWire** | Server multimedia modern; mengelola audio/video dan routing. |
| **Node** | Unit dasar di PipeWire: sink, source, stream, atau virtual device. |
| **Sink** | Node output audio (speaker, headphone). |
| **Source** | Node input audio (mikrofon). |
| **`PwObjectTracker`** | Tipe QML yang mengikat node PipeWire agar propertinya valid. |
| **`audio.volume`** | Volume sebagai float 0.0–1.0. |
| **`audio.muted`** | Status mute sebagai boolean. |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Widget volume dapat menjadi bagian dari system tray atau panel kontrol.
- **Modul 2.5:** Slider volume harus dapat dikendalikan dengan keyboard (fokus QML, tombol panah).

### Sumber Referensi

- Quickshell — `PwObjectTracker`: https://quickshell.org/docs/v0.3.1/types/Quickshell.Services.Pipewire/PwObjectTracker
- Quickshell — `Pipewire`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.Pipewire/Pipewire
- Quickshell — `PwNode` (termasuk `audio`): https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.Pipewire/PwNode

### Tips dan Praktik Terbaik

- **Selalu gunakan `PwObjectTracker` untuk node yang properti audionya Anda akses.** Ini adalah persyaratan, bukan opsional.
- **Batasi volume maksimum dengan `Math.min(value, 1.0)`** untuk mencegah amplifikasi yang tidak diinginkan.
- **Gunakan `?.` dan `??` untuk menangani node yang belum siap.**

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak memakai `PwObjectTracker` | `sink.audio` null atau tidak reaktif | Tambahkan `PwObjectTracker { objects: [sink] }`. |
| Mengira volume adalah 0–100 | Slider tidak berfungsi | Gunakan skala 0.0–1.0; kalikan 100 hanya untuk tampilan. |
| Tidak membatasi volume | Audio terdistorsi | Gunakan `Math.min(value, 1.0)`. |

---

## 4. MPRIS: `players`, `trackTitle`, dan Kontrol Pemutaran

### Deskripsi Konkret & Peran dalam Kurikulum

MPRIS (Media Player Remote Interfacing Specification) adalah standar D-Bus untuk mengontrol pemutar media. Quickshell mengeksposnya melalui `Quickshell.Services.Mpris`, dengan tipe `Mpris` (singleton) dan `MprisPlayer`.

**Mengapa penting:** Widget media adalah komponen shell yang sangat umum. Namun, MPRIS memiliki jebakan: **properti bernama `trackTitle`, bukan `track.title`**. Selain itu, dukungan fitur **bervariasi liar antar-player**; Anda harus memeriksa `canXyz` sebelum memanggil method.

### Konsep Kunci & Filosofi

**`players` sebagai model dinamis:** `Mpris.players` adalah `ObjectModel<MprisPlayer>` yang diperbarui secara otomatis saat player muncul atau hilang. Anda dapat mengakses `Mpris.players.values` untuk mendapatkan array semua player.

**Properti yang “datar”:** Berbeda dari API berorientasi objek yang mungkin Anda harapkan, `MprisPlayer` mengekspos metadata sebagai properti datar: `trackTitle`, `trackArtist`, `trackAlbum`, `trackArtUrl`. Ini bukan `track.title`; ini adalah `trackTitle`. Kesalahan menggunakan `track.title` akan menghasilkan `undefined`.

**Keterbatasan per-player:** Dokumentasi Quickshell memperingatkan: “Support for various functionality and general compliance to the MPRIS specification varies wildly by player. Always check the associated `canXyz` and `xyzSupported` properties.” Artinya, Anda tidak boleh berasumsi bahwa `canGoNext` selalu `true` atau `canTogglePlaying` selalu tersedia.

**`position` tidak reaktif secara default:** Dokumentasi menyatakan bahwa `position` “usually will not update reactively” untuk menghemat CPU. Jika Anda memerlukan progress bar real-time, Anda harus secara manual memicu `positionChanged()` atau menggunakan `FrameAnimation`.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell.Services.Mpris

Text {
    readonly property var player: Mpris.players.values[0]
    text: player?.trackTitle || 'Tidak ada media'
    color: 'white'
}
```

**Penjelasan kata-per-kata:**

- `Mpris.players.values[0]`: mengambil player pertama. `.values` mengubah `ObjectModel` menjadi array.
- `player?.trackTitle`: mengakses properti `trackTitle` dengan optional chaining. Jika `player` null, hasilnya `undefined`.
- `|| 'Tidak ada media'`: fallback jika `trackTitle` kosong (`""`) atau `undefined`. Dokumentasi menyarankan pola `player.trackTitle || "Unknown Title"`.

**Kontrol pemutaran:**

```qml
Button {
    text: player?.isPlaying ? "Pause" : "Play"
    enabled: player?.canTogglePlaying ?? false
    onClicked: {
        if (player?.canTogglePlaying)
            player.togglePlaying()
    }
}
```

**Penjelasan:**

- `player?.isPlaying`: properti boolean yang menunjukkan apakah player sedang memutar. Dokumentasi: “True if `playbackState == MprisPlaybackState.Playing`.”
- `player?.canTogglePlaying`: memeriksa apakah player mendukung toggle play/pause. Jika `false`, tombol dinonaktifkan.
- `player.togglePlaying()`: method untuk toggle play/pause. Dokumentasi: “Equivalent to calling `play()` if not playing or `pause()` if playing.”

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Player pertama | `Mpris.players.values[0]` | Tidak selalu player yang sedang memutar. |
| Player yang sedang memutar | `Mpris.players.values.find(p => p.isPlaying)` | Lebih baik untuk widget “now playing”. |
| Play/pause | `player.togglePlaying()` | Periksa `canTogglePlaying`. |
| Next/previous | `player.next()` / `player.previous()` | Periksa `canGoNext` / `canGoPrevious`. |
| Progress bar | `player.position` + `positionChanged` | Tidak reaktif secara default; perlu trigger manual. |

### Visualisasi: Struktur Properti MPRIS

```text
Mpris (singleton)
  └── players: ObjectModel<MprisPlayer>
        ├── [0] MprisPlayer
        │     ├── trackTitle: string
        │     ├── trackArtist: string
        │     ├── isPlaying: bool
        │     ├── canTogglePlaying: bool
        │     ├── togglePlaying(): void
        │     └── position: real (tidak reaktif default)
        └── [1] MprisPlayer ...
```

**Penjelasan:** Setiap player adalah objek datar dengan properti metadata dan method kontrol. Tidak ada nested `track` object; semuanya datar.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **MPRIS** | Spesifikasi D-Bus untuk mengontrol pemutar media. |
| **`Mpris.players`** | `ObjectModel<MprisPlayer>` berisi semua player yang terhubung. |
| **`trackTitle`** | Judul track saat ini; **bukan** `track.title`. |
| **`canTogglePlaying`** | Boolean yang menunjukkan apakah play/pause didukung. |
| **`position`** | Posisi track dalam detik; tidak reaktif secara default. |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Widget media dapat ditempatkan di panel atau system tray.
- **Modul 2.5:** Kontrol media harus dapat dioperasikan dengan keyboard (tombol media, fokus QML).

### Sumber Referensi

- Quickshell — `MprisPlayer`: https://quickshell.org/docs/v0.1.0/types/Quickshell.Services.Mpris/MprisPlayer/
- Quickshell — `Mpris`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.Mpris/Mpris
- Spesifikasi MPRIS: https://specifications.freedesktop.org/mpris-spec/latest/

### Tips dan Praktik Terbaik

- **Gunakan `trackTitle`, bukan `track.title`.** Ini adalah kesalahan paling umum.
- **Selalu periksa `canXyz` sebelum memanggil method.** Tidak semua player mendukung semua fitur.
- **Untuk progress bar, jangan mengandalkan `position` secara reaktif**; picu pembaruan secara manual atau gunakan timer.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menggunakan `player.track.title` | `undefined` | Gunakan `player.trackTitle`. |
| Memanggil `togglePlaying()` tanpa cek | Error pada player yang tidak mendukung | Periksa `canTogglePlaying`. |
| Mengharapkan `position` diperbarui otomatis | Progress bar diam | Picu `positionChanged` secara manual atau gunakan `FrameAnimation`. |

---

## 5. UPower: Baterai, `displayDevice`, Skala Persentase, dan Profil Daya

### Deskripsi Konkret & Peran dalam Kurikulum

UPower adalah daemon yang menyediakan informasi daya dan baterai. Quickshell mengeksposnya melalui `Quickshell.Services.UPower`, dengan tipe `UPower` (singleton) dan `UPowerDevice`.

**Mengapa penting:** Widget baterai adalah komponen penting untuk laptop. Namun, UPower memiliki jebakan skala: `percentage` adalah **fraksi 0.0–1.0**, bukan 0–100. Kesalahan mengalikan atau tidak mengalikan dapat menghasilkan tampilan yang salah.

### Konsep Kunci & Filosofi

**`displayDevice` sebagai perangkat agregat:** `UPower.displayDevice` adalah “aggregate device” yang mewakili sistem secara keseluruhan, bukan baterai fisik tertentu. Dokumentasi: “This is an aggregate device and not a physical one, meaning you will not find it in `devices`.” Ini adalah perangkat yang tepat untuk menampilkan status daya di shell.

**Skala persentase:** `UPowerDevice.percentage` didefinisikan sebagai “Current charge level as a percentage. This would be equivalent to `energy / energyCapacity`.” Karena `energy` dan `energyCapacity` adalah nilai fisik, rasio mereka adalah **fraksi 0.0–1.0**. Untuk tampilan persen, kalikan dengan 100.

**Properti lain yang berguna:** `isLaptopBattery` (untuk memeriksa apakah perangkat adalah baterai laptop), `healthPercentage` (kesehatan baterai), `timeToEmpty`/`timeToFull` (estimasi waktu), `onBattery` (apakah sistem berjalan di baterai).

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell.Services.UPower

Text {
    readonly property var bat: UPower.displayDevice
    text: bat ? Math.round(bat.percentage * 100) + '%' : '—'
    color: 'white'
}
```

**Penjelasan kata-per-kata:**

- `UPower.displayDevice`: perangkat agregat untuk tampilan daya.
- `bat ? ... : '—'`: jika `bat` null (misalnya desktop tanpa baterai), tampilkan `—`.
- `Math.round(bat.percentage * 100)`: `percentage` adalah 0.0–1.0; kalikan 100 untuk mendapatkan persentase, lalu bulatkan.
- `+ '%'`: menambahkan simbol persen.

**Memeriksa apakah perangkat valid:**

```qml
readonly property bool hasBattery: UPower.displayDevice?.isLaptopBattery ?? false
```

**Penjelasan:** `isLaptopBattery` adalah `true` hanya jika perangkat adalah baterai laptop. Ini berguna untuk menyembunyikan widget baterai di desktop.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Properti | Catatan |
|---|---|---|
| Persentase tampilan | `Math.round(percentage * 100)` | Skala 0–1. |
| Status pengisian | `state` (enum `UPowerDeviceState`) | Charging, discharging, full, dll. |
| Kesehatan baterai | `healthPercentage` | Persentase kesehatan asli. |
| Sisa waktu | `timeToEmpty` / `timeToFull` | Dalam detik; 0 jika tidak berlaku. |
| Mode baterai | `UPower.onBattery` | Boolean; apakah sistem berjalan di baterai. |

### Visualisasi: Skala UPower

```text
Nilai mentah UPower:
percentage = 0.73   ← fraksi 0.0–1.0

Tampilan yang benar:
Math.round(0.73 * 100) + '%' = '73%'

Kesalahan umum:
Math.round(0.73) + '%' = '1%'   ← salah!
```

**Penjelasan:** `percentage` adalah fraksi, bukan persentase. Selalu kalikan dengan 100 untuk tampilan.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **UPower** | Daemon informasi daya dan baterai. |
| **`displayDevice`** | Perangkat agregat untuk tampilan daya sistem. |
| **`percentage`** | Fraksi 0.0–1.0 dari kapasitas baterai. |
| **`isLaptopBattery`** | Boolean; apakah perangkat adalah baterai laptop. |
| **`onBattery`** | Boolean; apakah sistem berjalan di baterai. |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Widget baterai dapat menjadi bagian dari panel atau system tray.
- **Modul 4.2 (Keamanan):** Profil daya dapat memengaruhi kebijakan keamanan (misalnya lock screen saat baterai kritis).

### Sumber Referensi

- Quickshell — `UPowerDevice`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.UPower/UPowerDevice
- Quickshell — `UPower`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.UPower/UPower
- UPower documentation: https://upower.freedesktop.org/docs/

### Tips dan Praktik Terbaik

- **Selalu kalikan `percentage` dengan 100 untuk tampilan.** Dokumentasi dengan jelas menyatakan itu adalah fraksi.
- **Gunakan `isLaptopBattery` untuk memeriksa validitas.** Jangan berasumsi `displayDevice` selalu ada atau selalu baterai.
- **Untuk `timeToEmpty`/`timeToFull`, periksa apakah nilainya 0** (tidak berlaku) sebelum menampilkan.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak mengalikan dengan 100 | Menampilkan “1%” bukan “73%” | Kalikan `percentage * 100`. |
| Menganggap `displayDevice` selalu ada | Error di desktop | Gunakan optional chaining dan fallback. |
| Menampilkan `timeToEmpty` saat charging | Nilai 0 atau tidak masuk akal | Periksa `state` sebelum menampilkan. |

---

## 6. Bluetooth: Adapter, Perangkat, dan Discovery

### Deskripsi Konkret & Peran dalam Kurikulum

Bluetooth di Quickshell berada di modul **`Quickshell.Bluetooth`** (bukan `Quickshell.Services.Bluetooth`). Ini adalah pembungkus BlueZ (stack Bluetooth Linux) melalui D-Bus.

**Mengapa penting:** Bluetooth mengelola keyboard, mouse, headphone, dan perangkat lain. Shell yang baik harus dapat menampilkan status adapter, daftar perangkat terhubung, dan mungkin mengaktifkan/menonaktifkan Bluetooth.

### Konsep Kunci & Filosofi

**Adapter sebagai radio:** `Bluetooth.defaultAdapter` mengembalikan `BluetoothAdapter`—radio Bluetooth fisik atau virtual (misalnya `hci0`). Properti `enabled` menunjukkan apakah adapter aktif. `devices` adalah `ObjectModel<BluetoothDevice>` berisi perangkat yang terhubung ke adapter tersebut.

**Discovery memerlukan adapter aktif:** Proses discovery (scanning) hanya berjalan saat adapter `enabled` dan `discovering`. Namun, mengaktifkan adapter bersifat asinkron; `StartDiscovery` akan gagal sampai adapter benar-benar aktif. Ini adalah jebakan yang perlu diwaspadai.

**Perangkat terhubung vs. semua perangkat:** `Bluetooth.devices` berisi “all connected bluetooth devices across all adapters”, sedangkan `adapter.devices` berisi perangkat untuk adapter tertentu. Untuk widget status, Anda biasanya ingin yang terhubung.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell.Bluetooth

Text {
    readonly property var adapter: Bluetooth.defaultAdapter
    text: adapter?.enabled ? 'BT aktif' : 'BT mati'
    color: 'white'
}
```

**Penjelasan kata-per-kata:**

- `Bluetooth.defaultAdapter`: adapter default (biasanya hanya satu).
- `adapter?.enabled`: properti boolean; `true` jika adapter aktif.
- `adapter?.enabled ? 'BT aktif' : 'BT mati'`: ternary untuk status.

**Menghitung perangkat terhubung:**

```qml
readonly property int connectedCount:
    Bluetooth.devices.values.filter(d => d.connected).length
```

**Penjelasan:** `Bluetooth.devices` adalah semua perangkat terhubung; `.values` menjadi array; `.filter(d => d.connected)` menyaring yang benar-benar terhubung; `.length` menghitungnya. Pola ini umum di shell Quickshell.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Properti/Method | Catatan |
|---|---|---|
| Status adapter | `adapter.enabled` | Boolean. |
| Nama adapter | `adapter.name` | System-provided name. |
| Perangkat terhubung | `Bluetooth.devices.values.filter(d => d.connected)` | Semua adapter. |
| Perangkat adapter tertentu | `adapter.devices.values` | Hanya adapter tersebut. |
| Memulai discovery | `adapter.discovering = true` | Perlu adapter aktif; async. |

### Visualisasi: Struktur Bluetooth

```text
Bluetooth (singleton)
  ├── defaultAdapter: BluetoothAdapter
  │     ├── enabled: bool
  │     ├── name: string
  │     ├── discovering: bool
  │     └── devices: ObjectModel<BluetoothDevice>
  │           ├── [0] BluetoothDevice (connected: true)
  │           └── [1] BluetoothDevice (connected: false)
  └── devices: ObjectModel<BluetoothDevice>  (semua adapter)
```

**Penjelasan:** `defaultAdapter` adalah pintu masuk utama. `adapter.devices` memberi perangkat untuk adapter itu; `Bluetooth.devices` memberi semua perangkat terhubung di semua adapter.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **BlueZ** | Stack Bluetooth Linux; daemon `bluetoothd`. |
| **Adapter** | Radio Bluetooth fisik/virtual (misalnya `hci0`). |
| **`enabled`** | Boolean; apakah adapter aktif. |
| **`discovering`** | Boolean; apakah adapter sedang scanning. |
| **`connected`** | Properti `BluetoothDevice`; apakah perangkat terhubung. |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Status Bluetooth dapat ditampilkan di panel atau system tray.
- **Modul 2.5:** Toggle Bluetooth harus dapat dioperasikan dengan keyboard.

### Sumber Referensi

- Quickshell — `Bluetooth`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Bluetooth/Bluetooth
- Quickshell — `BluetoothAdapter`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Bluetooth/BluetoothAdapter
- Quickshell — `BluetoothDevice`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Bluetooth/BluetoothDevice

### Tips dan Praktik Terbaik

- **Gunakan `Quickshell.Bluetooth`, bukan `Quickshell.Services.Bluetooth`.** Namespace-nya berbeda.
- **Periksa `adapter` null sebelum mengakses properti.** Di sistem tanpa Bluetooth, `defaultAdapter` bisa null.
- **Untuk discovery, tunggu adapter benar-benar aktif** sebelum memulai scanning; operasi ini asinkron.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Mengimpor `Quickshell.Services.Bluetooth` | Modul tidak ditemukan | Gunakan `Quickshell.Bluetooth`. |
| Mengakses `adapter.enabled` tanpa cek null | Error di sistem tanpa BT | Gunakan `adapter?.enabled ?? false`. |
| Memulai discovery saat adapter mati | `StartDiscovery` gagal | Aktifkan adapter dulu, tunggu state `Enabled`. |

---

## 7. Verifikasi Skala dan Nilai Kosong: Pola `?.`, `??`, dan `Math.min/max`

### Deskripsi Konkret & Peran dalam Kurikulum

Kurikulum menekankan “memverifikasi skala dan nilai kosong (`?.`, `??`)” sebagai bagian dari Daftar Isi. Ini adalah keterampilan defensif yang mencegah crash dan tampilan yang salah.

**Mengapa penting:** Layanan desktop bisa tidak tersedia (desktop tanpa baterai, tanpa Bluetooth, tanpa player media). Properti bisa `null` saat startup. Skala bisa berbeda (volume 0–1, persentase 0–1, waktu dalam detik). Menangani semua ini dengan benar adalah tanda shell yang matang.

### Konsep Kunci & Filosofi

**Optional chaining (`?.`):** Mengakses properti hanya jika objek tidak `null`/`undefined`. Jika objek null, seluruh ekspresi menghasilkan `undefined` tanpa error.

**Nullish coalescing (`??`):** Memberikan nilai fallback hanya jika sisi kiri adalah `null` atau `undefined`. Berbeda dari `||`, yang juga mengganti nilai “falsy” seperti `0` atau `""`. Untuk volume `0`, `||` akan menggantinya dengan fallback—yang salah. Gunakan `??` untuk angka.

**Membatasi nilai (`Math.min`/`Math.max`):** Mencegah volume melebihi 1.0 atau nilai negatif.

### Sintaks Dasar / Contoh Implementasi

```qml
// Volume: gunakan ??, bukan ||
value: sink?.audio?.volume ?? 0.5

// Batasi volume
sink.audio.volume = Math.min(newValue, 1.0)

// Persentase baterai
text: Math.round((bat?.percentage ?? 0) * 100) + '%'

// Nama workspace
text: Hyprland.focusedWorkspace?.name ?? '?'
```

**Penjelasan:**

- `sink?.audio?.volume ?? 0.5`: jika `sink` atau `audio` null, gunakan `0.5`. Jika volume adalah `0`, tetap `0` (bukan `0.5`), karena `??` hanya mengganti null/undefined.
- `Math.min(newValue, 1.0)`: membatasi volume pada 1.0.
- `Math.round((bat?.percentage ?? 0) * 100)`: jika `bat` null, gunakan `0`, lalu kalikan 100.
- `Hyprland.focusedWorkspace?.name ?? '?'`: fallback `'?'` jika workspace belum ada.

### Visualisasi: Perbedaan `||` dan `??`

```text
Ekspresi: value || fallback
  value = 0    → fallback   (0 dianggap falsy)
  value = ""   → fallback
  value = null → fallback

Ekspresi: value ?? fallback
  value = 0    → 0          (0 bukan null/undefined)
  value = ""   → ""         (" " bukan null/undefined)
  value = null → fallback
```

**Penjelasan:** Untuk volume, `0` adalah nilai yang valid (mute). Menggunakan `||` akan menggantinya dengan fallback—yang salah. Gunakan `??`.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **Optional chaining (`?.`)** | Mengakses properti dengan aman dari null. |
| **Nullish coalescing (`??`)** | Fallback hanya untuk null/undefined. |
| **Falsy** | Nilai yang dianggap false dalam konteks boolean: `0`, `""`, `null`, `undefined`, `NaN`. |

### Hubungan dengan Modul Lain

- **Modul 2.5:** Pola yang sama digunakan saat mengakses state persistensi yang mungkin belum dimuat.

### Tips dan Praktik Terbaik

- **Gunakan `??` untuk nilai numerik** (volume, persentase) karena `0` adalah nilai valid.
- **Gunakan `||` untuk string** jika string kosong dianggap tidak valid (misalnya `trackTitle || 'Unknown'`).
- **Selalu batasi nilai yang dapat ditulis ke layanan** (volume, brightness) dengan `Math.min`/`Math.max`.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menggunakan `||` untuk volume | Volume 0 menjadi 0.5 | Gunakan `??`. |
| Tidak membatasi volume | Audio terdistorsi | Gunakan `Math.min`. |
| Mengakses properti tanpa `?.` | Crash saat layanan belum siap | Gunakan `?.`. |

---

## 8. Latihan dan Checkpoint

### Latihan (sesuai kurikulum)

**Buat widget volume dengan tombol mute dan batas maksimum, serta widget media yang menampilkan judul dan tombol putar/jeda.**

**Langkah-langkah:**

1. **Widget volume:**
   - Impor `Quickshell.Services.Pipewire`.
   - Dapatkan `Pipewire.defaultAudioSink`.
   - Tambahkan `PwObjectTracker { objects: [sink] }`.
   - Buat `Slider` dengan `from: 0; to: 1.0`, `value: sink?.audio?.volume ?? 0`.
   - Pada `onMoved`, set `sink.audio.volume = Math.min(value, 1.0)`.
   - Tambahkan tombol mute: `onClicked: if (sink?.audio) sink.audio.muted = !sink.audio.muted`.

2. **Widget media:**
   - Impor `Quickshell.Services.Mpris`.
   - Dapatkan player: `Mpris.players.values[0]` atau cari yang `isPlaying`.
   - Tampilkan `player?.trackTitle || 'Tidak ada media'`.
   - Tambahkan tombol play/pause: `enabled: player?.canTogglePlaying ?? false`, `onClicked: player.togglePlaying()`.
   - Tambahkan tombol next/previous dengan pengecekan `canGoNext`/`canGoPrevious`.

3. **Uji:**
   - Jalankan `wpctl status` atau `pavucontrol` untuk memverifikasi volume.
   - Putar musik di player MPRIS dan pastikan judul muncul.
   - Uji mute dan batas volume.

**Checkpoint:** Jelaskan apa yang terjadi bila `PwObjectTracker` dihilangkan, dan bagaimana Anda memastikan skala volume.

**Jawaban singkat:** Tanpa `PwObjectTracker`, node PipeWire tetap “unbound” dan hanya menyediakan subset informasi. Properti seperti `audio.volume` mungkin tidak tersedia atau tidak reaktif; slider tidak akan menampilkan nilai yang benar dan perubahan tidak akan tercermin. Untuk memastikan skala volume, saya memverifikasi bahwa `audio.volume` adalah float 0.0–1.0 (bukan 0–100) dengan `console.log(sink.audio.volume)` dan membandingkannya dengan `wpctl get-volume`. Saya juga membatasi nilai dengan `Math.min(value, 1.0)` untuk mencegah amplifikasi.

---

## Motivasi

Layanan desktop adalah yang membuat shell Anda “hidup” — bukan sekadar menggambar, tetapi mengetahui denyut nadi mesin: volume yang berubah, lagu yang berganti, baterai yang menurun, headphone yang terhubung. Kuasai integrasi ini, dan shell Anda akan menjadi pusat kendali yang sesungguhnya. Teruslah bereksplorasi; setiap widget yang berfungsi adalah satu lapisan lagi dari desktop yang sepenuhnya Anda pahami.

---

Kita akan melanjutkan ke **Modul 2.4 — Notifikasi, System Tray, dan Launcher**.

---

## Audit Singkat Modul 2.4

**Temuan audit:**

1. **Kurikulum menyebut “hentikan daemon lama (dunst, mako) sebelum menjalankan milik Anda.”** Ini benar, tetapi perlu dijelaskan mekanismenya: D-Bus tidak memilih notification daemon secara deterministik jika ada beberapa service file `org.freedesktop.Notifications.service`. Jika `dunst` dan `mako` sama-sama terpasang, D-Bus dapat memilih salah satunya secara arbitrer; solusinya adalah menghentikan daemon lain atau membuat override service file yang menunjuk ke daemon pilihan Anda. Materi ini akan menambahkan langkah verifikasi `busctl`.

2. **`NotificationServer` tidak melacak notifikasi secara otomatis.** Dokumentasi menyatakan sinyal `notification(notification)` dikirim saat notifikasi diterima, dan “If this notification should not be discarded, set its `tracked` property to true”. Artinya, tanpa `notif.tracked = true` di `onNotification`, notifikasi akan dibuang. Ini adalah jebakan paling umum dan harus ditekankan.

3. **Kapabilitas notifikasi tidak diiklankan secara default.** `imageSupported`, `actionsSupported`, dan beberapa properti lain default `false`; `bodySupported` default `true`. Jika Anda tidak menyalakan `actionsSupported`, aplikasi pengirim tidak akan mengirim aksi, sehingga tombol aksi tidak muncul. Materi ini akan menjelaskan mana yang perlu dinyalakan dan konsekuensinya.

4. **`SystemTray` baru mulai melacak saat singleton direferensikan.** Dokumentasi: “Referencing the SystemTray singleton will make quickshell start tracking system tray contents”. Ini berarti Anda tidak perlu “mengaktifkan” tray secara eksplisit; cukup mengakses `SystemTray.items`.

5. **`DesktopEntries.applications` bersifat asinkron dan dapat kosong saat startup.** Ada laporan bahwa `DesktopEntries.applications.values.length` bisa `0` pada `Component.onCompleted`, lalu bertambah secara bertahap. Launcher harus menangani keadaan kosong dan pembaruan model, bukan mengasumsikan daftar langsung penuh.

6. **`ScriptModel` hanya bekerja dengan daftar nilai unik.** Dokumentasi memperingatkan: “There must not be any duplicates in the given list, or behavior of the model is undefined”. Ini penting untuk launcher: gunakan `DesktopEntries.applications.values` yang memang unik, dan jangan menggabungkan daftar yang berpotensi duplikat tanpa deduplikasi.

7. **Kurikulum belum membahas `keepOnReload` dan `lastGeneration`.** Ini relevan untuk pengalaman pengguna saat Quickshell di-reload: notifikasi lama dapat dipancarkan ulang, dan Anda perlu memfilter agar tidak menampilkan duplikat. Materi ini akan menambahkannya sebagai **materi tambahan** yang tetap mengacu pada kurikulum.

Dengan catatan ini, saya akan membangun Modul 2.4 selengkap mungkin.

---

# Modul 2.4 — Notifikasi, System Tray, dan Launcher

> *“Tiga komponen ini adalah indra shell Anda: telinga yang mendengar notifikasi, mata yang melihat aplikasi latar belakang, dan tangan yang meraih aplikasi saat Anda mengetik.”*

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Filosofi tiga komponen: resepsionis, papan ikon, mesin pencari** — mengapa ketiganya berbicara melalui protokol desktop yang berbeda.
2. **NotificationServer: menjadi daemon notifikasi** — D-Bus `org.freedesktop.Notifications`, kapabilitas, `tracked`, siklus hidup notifikasi.
3. **Menampilkan notifikasi: delegate, urgensi, timeout, aksi** — dari `trackedNotifications` ke UI yang dapat ditindaklanjuti.
4. **SystemTray: StatusNotifierItem** — `items`, `SystemTrayItem`, `activate`, `display`, menu platform, dan keterbatasan.
5. **Launcher: `DesktopEntries`, `ScriptModel`, dan pencarian** — desk entry, `execute()`, filter, navigasi, dan penanganan startup asinkron.
6. **Integrasi dan keamanan** — lingkungan sesi, rahasia, dan izin.
7. **Praktik terbaik, kesalahan umum, latihan, dan checkpoint**.

---

## 1. Filosofi Tiga Komponen: Resepsionis, Papan Ikon, Mesin Pencari

### Deskripsi Konkret & Peran dalam Kurikulum

Modul 2.4 membangun tiga komponen desktop yang paling sering digunakan:

- **Notification daemon**: menerima dan menampilkan notifikasi dari aplikasi lain.
- **System tray**: menampilkan ikon aplikasi latar belakang dan menyediakan akses ke menu mereka.
- **Launcher**: mencari dan meluncurkan aplikasi terpasang.

**Mengapa penting:** Ketiganya adalah “wajah” shell Anda dalam interaksi sehari-hari. Tanpa notification daemon, notifikasi dari aplikasi tidak muncul sama sekali—atau muncul di daemon lain yang tidak Anda kendalikan. Tanpa tray, aplikasi seperti NetworkManager, clipboard manager, atau chat client kehilangan titik aksesnya. Tanpa launcher, Anda bergantung pada terminal atau menu aplikasi yang tidak terintegrasi.

### Konsep Kunci & Filosofi

**Tiga protokol, satu pola:** Ketiganya berbicara melalui protokol desktop yang sudah mapan:

- Notifikasi: D-Bus `org.freedesktop.Notifications`.
- Tray: StatusNotifierItem (D-Bus) — “roughly conforming to the kde/freedesktop spec; there is no real spec, we just implemented whatever seemed to actually be used”.
- Launcher: berkas `.desktop` sesuai Desktop Entry Specification.

Quickshell membungkus ketiganya menjadi tipe QML: `NotificationServer`, `SystemTray`, `DesktopEntries`. Anda tidak perlu menulis boilerplate D-Bus atau parser `.desktop`.

**Filosofi “monolitik dalam fungsi, modular dalam kode”:** Satu proses Quickshell dapat menjadi daemon notifikasi, host tray, dan launcher sekaligus. Namun setiap integrasi adalah modul QML terpisah. Ini memungkinkan Anda menyalakan atau mematikan komponen tanpa mengganggu yang lain.

**Analogi:** Notification daemon adalah **resepsionis** yang menerima semua pesan masuk. System tray adalah **papan ikon** tempat program latar belakang menempelkan statusnya. Launcher adalah **mesin pencari** yang hanya mengenal aplikasi terpasang—bukan mesin pencari web.

### Visualisasi: Tiga Protokol, Satu Shell

```text
┌─────────────────────────────────────────────────────┐
│                  QUICKSHELL (QML)                   │
│                                                     │
│  ┌────────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │ Notification   │  │ SystemTray   │  │Desktop   │ │
│  │ Server         │  │ singleton    │  │Entries   │ │
│  └───────┬────────┘  └──────┬───────┘  └────┬─────┘ │
└──────────┼──────────────────┼───────────────┼───────┘
           │                  │               │
           ▼                  ▼               ▼
   org.freedesktop.      StatusNotifierItem   .desktop files
   Notifications         (D-Bus)              (filesystem)
```

**Penjelasan:** Notifikasi dan tray menggunakan D-Bus; launcher membaca berkas `.desktop` dari `XDG_DATA_DIRS`. Quickshell menyembunyikan perbedaan ini di balik API QML yang seragam.

### Hubungan dengan Modul Lain

- **Modul 2.1:** Notifikasi dan launcher biasanya berupa `PanelWindow` di layer `Overlay`; tray berada di bar layer `Top`.
- **Modul 2.2:** Launcher sering dipicu melalui `IpcHandler` atau `GlobalShortcut`.
- **Modul 2.5:** Launcher harus dapat dioperasikan penuh dengan keyboard (fokus QML, mode modal).

### Sumber Referensi

- Quickshell — Module Listing: https://quickshell.org/docs/v0.3.1/types
- Spesifikasi Desktop Notifications: https://specifications.freedesktop.org/notification-spec/latest/
- Spesifikasi StatusNotifierItem: https://www.freedesktop.org/wiki/Specifications/StatusNotifierItem/
- Desktop Entry Specification: https://specifications.freedesktop.org/desktop-entry-spec/latest/

---

## 2. `NotificationServer`: Menjadi Daemon Notifikasi

### Deskripsi Konkret & Peran dalam Kurikulum

`NotificationServer` adalah implementasi Desktop Notifications Specification di Quickshell. Ia **mengklaim nama D-Bus** `org.freedesktop.Notifications` pada session bus, sehingga aplikasi lain mengirim notifikasi ke shell Anda, bukan ke `dunst` atau `mako`.

**Mengapa penting:** Inilah yang membuat notifikasi muncul di shell Anda. Namun, ada dua jebakan besar: (1) Anda harus **menghentikan daemon lain** agar tidak berebut nama D-Bus, dan (2) Anda harus **menandai notifikasi sebagai `tracked`** agar tidak dibuang.

### Konsep Kunci & Filosofi

**D-Bus well-known name sebagai “hak siar”.** Hanya satu proses yang dapat memiliki nama `org.freedesktop.Notifications` pada satu waktu. Jika `dunst` sudah memilikinya, `NotificationServer` Anda tidak akan menerima notifikasi. D-Bus tidak selalu memilih daemon yang “benar”; jika beberapa service file terpasang, ia dapat memilih secara arbitrer. Karena itu, langkah pertama adalah memastikan tidak ada daemon lain yang berjalan.

**`tracked` sebagai “simpan atau buang”.** Saat notifikasi masuk, `NotificationServer` memancarkan sinyal `notification`. Jika Anda tidak menyetel `notification.tracked = true`, notifikasi itu **dibuang** dan tidak muncul di `trackedNotifications`. Ini adalah desain yang disengaja: shell harus secara eksplisit mengatakan “saya ingin menyimpan notifikasi ini.”

**Kapabilitas sebagai iklan.** `NotificationServer` “does not advertise most capabilities by default”. Jika Anda tidak menyalakan `actionsSupported`, aplikasi pengirim tidak akan mengirim aksi, sehingga tombol aksi tidak akan pernah muncul. Anda harus **mengiklankan** kapabilitas yang benar-benar Anda tangani.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Services.Notifications

NotificationServer {
    id: server
    keepOnReload: true
    bodySupported: true
    bodyMarkupSupported: true
    actionsSupported: true
    imageSupported: true

    onNotification: notif => {
        notif.tracked = true
    }
}
```

**Penjelasan kata-per-kata:**

- `import Quickshell.Services.Notifications`: mengimpor tipe `NotificationServer`, `Notification`, `NotificationAction`, dan `NotificationUrgency`.
- `NotificationServer { ... }`: objek yang mengklaim nama D-Bus `org.freedesktop.Notifications` dan menerima notifikasi.
- `keepOnReload: true`: notifikasi dari generasi sebelumnya akan dipancarkan ulang saat Quickshell di-reload. Dokumentasi: “If notifications should be re-emitted when quickshell reloads. Defaults to true”.
- `bodySupported: true`: mengiklankan dukungan teks body. Ini default `true`.
- `bodyMarkupSupported: true`: mengiklankan dukungan markup di body. Default `false`; jika Anda menyalakannya, Anda harus menangani markup dengan aman (misalnya `Text.textFormat`).
- `actionsSupported: true`: mengiklankan dukungan aksi/tombol. Default `false`. Tanpa ini, `Notification.actions` kemungkinan kosong.
- `imageSupported: true`: mengiklankan dukungan gambar. Default `false`.
- `onNotification: notif => { notif.tracked = true }`: **wajib** agar notifikasi tidak dibuang. `notif` adalah objek `Notification`.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Properti | Catatan |
|---|---|---|
| Notifikasi teks sederhana | `bodySupported: true` (default) | Cukup untuk `notify-send`. |
| Notifikasi dengan tombol aksi | `actionsSupported: true` | Aplikasi pengirim baru mengirim aksi jika diiklankan. |
| Notifikasi dengan gambar | `imageSupported: true` | Termasuk `appIcon` dan gambar body. |
| Notifikasi dengan markup | `bodyMarkupSupported: true` | Hati-hati XSS/format injection; gunakan `Text.PlainText` jika tidak perlu. |
| Tidak mempertahankan notifikasi saat reload | `keepOnReload: false` | Notifikasi lama tidak dipancarkan ulang. |

**Menghentikan daemon lain (opsi):**

```bash
# Opsi 1: hentikan service user (jika menggunakan systemd user unit)
systemctl --user stop dunst.service
systemctl --user stop mako.service

# Opsi 2: hentikan proses langsung
pkill -x dunst
pkill -x mako

# Verifikasi siapa yang memegang nama notifikasi
busctl --user list | grep -i Notifications
```

**Penjelasan:** `systemctl --user stop` menghentikan unit user jika daemon dikelola systemd. `pkill -x` mencocokkan nama proses secara persis. `busctl --user list | grep -i Notifications` memverifikasi apakah nama `org.freedesktop.Notifications` masih dipegang proses lain. Jika masih muncul, hentikan proses tersebut sebelum menjalankan Quickshell.

### Visualisasi: Siklus Hidup Notifikasi

```text
Aplikasi (notify-send)
        │
        ▼
D-Bus: org.freedesktop.Notifications
        │
        ▼
NotificationServer
        │
        ├── sinyal onNotification(notif)
        │        │
        │        ├── notif.tracked = true  → masuk trackedNotifications
        │        └── tidak diset          → dibuang
        │
        ▼
trackedNotifications: ObjectModel<Notification>
        │
        ▼
Delegate UI (popup/riwayat)
        │
        ├── notif.dismiss()  → ditutup oleh pengguna
        ├── notif.expire()   → timeout
        └── action.invoke()  → aksi dijalankan
```

**Penjelasan:** Notifikasi masuk melalui D-Bus, dipancarkan sebagai sinyal, dan hanya dipertahankan jika `tracked` diset. Setelah berada di `trackedNotifications`, UI dapat menampilkannya dan memanggil `dismiss()`, `expire()`, atau `action.invoke()`.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`NotificationServer`** | Implementasi server notifikasi D-Bus di Quickshell. |
| **`trackedNotifications`** | `ObjectModel<Notification>` berisi notifikasi yang dilacak. |
| **`tracked`** | Properti `Notification`; jika `false`, notifikasi dibuang. Menyetel `false` setara dengan `dismiss()`. |
| **`keepOnReload`** | Jika `true`, notifikasi dari generasi sebelumnya dipancarkan ulang saat reload. |
| **`lastGeneration`** | Menandai notifikasi yang berasal dari reload sebelumnya. |
| **`expireTimeout`** | Waktu valid notifikasi dalam detik. |
| **`urgency`** | Tingkat urgensi: `Low`, `Normal`, `Critical`. |
| **`resident`** | Jika `true`, notifikasi tidak dihancurkan setelah aksi dijalankan. |
| **`transient`** | Jika `true`, notifikasi tidak boleh dipersistenkan (misalnya tidak masuk riwayat). |

### Hubungan dengan Modul Lain

- **Modul 2.1:** Popup notifikasi biasanya `PanelWindow` di layer `Overlay` dengan `keyboardFocus: None` (kecuali memiliki inline reply).
- **Modul 2.5:** Jika Anda mendukung inline reply, Anda perlu fokus keyboard sementara pada popup.

### Sumber Referensi

- Quickshell — `NotificationServer`: https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Notifications/NotificationServer
- Quickshell — `Notification`: https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Notifications/Notification
- Spesifikasi Desktop Notifications: https://specifications.freedesktop.org/notification-spec/latest/

### Tips dan Praktik Terbaik

- **Selalu set `notif.tracked = true` di `onNotification`.** Tanpa ini, notifikasi tidak akan muncul.
- **Hanya iklankan kapabilitas yang Anda tangani.** Jika Anda menyalakan `actionsSupported` tetapi tidak merender tombol aksi, aplikasi pengirim akan mengira aksinya tersedia padahal tidak.
- **Gunakan `keepOnReload` dengan sadar.** Jika `true`, Anda harus memfilter `lastGeneration` agar tidak menampilkan duplikat saat reload.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak set `tracked = true` | Notifikasi tidak muncul | Set di `onNotification`. |
| Daemon lain masih berjalan | Notifikasi muncul di dunst/mako | Hentikan daemon lain; verifikasi dengan `busctl`. |
| Tidak menyalakan `actionsSupported` | Tombol aksi tidak muncul | Set `actionsSupported: true`. |
| Menampilkan semua `trackedNotifications` termasuk `lastGeneration` | Duplikat setelah reload | Filter `!notif.lastGeneration` jika perlu. |

---

## 3. Menampilkan Notifikasi: Delegate, Urgensi, Timeout, dan Aksi

### Deskripsi Konkret & Peran dalam Kurikulum

Setelah notifikasi masuk ke `trackedNotifications`, Anda perlu menampilkannya. Bagian ini membahas delegate notifikasi, properti yang berguna, timeout otomatis, dan aksi.

**Mengapa penting:** Notifikasi yang hanya tersimpan tetapi tidak terlihat tidak berguna. Anda perlu merender `summary`, `body`, `appName`, `appIcon`, dan `actions`, serta menangani timeout dan dismiss.

### Konsep Kunci & Filosofi

**Notifikasi sebagai objek yang dapat ditindaklanjuti.** `Notification` bukan sekadar teks; ia membawa aksi (`actions`), urgensi, timeout, dan metadata pengirim. Delegate Anda harus menghormati properti ini: notifikasi `Critical` mungkin tidak boleh hilang otomatis; notifikasi `transient` tidak boleh masuk riwayat; notifikasi `resident` tetap ada setelah aksi dijalankan.

**Timeout bukan satu ukuran untuk semua.** `expireTimeout` adalah waktu valid dalam detik. Nilai `0` atau negatif biasanya berarti “tidak kedaluwarsa otomatis” (tergantung pengirim); notifikasi `Critical` sering kali dimaksudkan untuk tetap tampil sampai ditutup. Jangan memaksa semua notifikasi hilang setelah 5 detik.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Controls

Column {
    Repeater {
        model: server.trackedNotifications
        delegate: Rectangle {
            required property var modelData
            width: 360
            height: content.implicitHeight + 16
            color: '#1e1e2e'
            radius: 8

            Column {
                id: content
                anchors { fill: parent; margins: 8 }
                spacing: 4

                Text {
                    text: modelData.summary
                    color: 'white'
                    font.bold: true
                    width: parent.width
                    wrapMode: Text.Wrap
                }

                Text {
                    text: modelData.body
                    color: '#cdd6f4'
                    width: parent.width
                    wrapMode: Text.Wrap
                    textFormat: Text.PlainText
                    visible: text.length > 0
                }

                Row {
                    spacing: 8
                    Repeater {
                        model: modelData.actions
                        delegate: Button {
                            required property var modelData
                            text: modelData.text
                            onClicked: modelData.invoke()
                        }
                    }
                }
            }

            Timer {
                interval: Math.max(1, modelData.expireTimeout) * 1000
                running: modelData.expireTimeout > 0 && !modelData.resident
                onTriggered: modelData.expire()
            }
        }
    }
}
```

**Penjelasan kata-per-kata:**

- `model: server.trackedNotifications`: `ObjectModel<Notification>`; setiap item adalah `Notification`.
- `required property var modelData`: mendeklarasikan item model sebagai `modelData`. `required` memastikan delegate tidak dibuat tanpa data.
- `modelData.summary`: ringkasan notifikasi.
- `modelData.body`: isi notifikasi. `Text.PlainText` mencegah markup dirender jika Anda tidak mengiklankan `bodyMarkupSupported`.
- `modelData.actions`: daftar `NotificationAction`. Setiap aksi memiliki `text` (label) dan `invoke()`.
- `modelData.expireTimeout`: waktu valid dalam detik. Timer hanya berjalan jika `> 0` dan tidak `resident`.
- `modelData.expire()`: menghancurkan notifikasi dan memberi tahu pengirim bahwa notifikasi kedaluwarsa.
- `modelData.dismiss()`: alternatif untuk menutup notifikasi karena tindakan pengguna.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Notifikasi sederhana | `Text { text: modelData.summary }` | Tidak perlu aksi/gambar. |
| Notifikasi dengan ikon | `Image { source: modelData.appIcon }` | `appIcon` bisa `""`. |
| Notifikasi dengan aksi | `Repeater { model: modelData.actions }` | Perlu `actionsSupported: true`. |
| Notifikasi persisten | Jangan jalankan Timer untuk `resident` | Hormati `resident` dan `transient`. |
| Riwayat notifikasi | Tampilkan `trackedNotifications` di panel terpisah | Filter `transient` jika perlu. |

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`summary`** | Judul/ringkasan notifikasi. |
| **`body`** | Isi notifikasi. |
| **`appName` / `appIcon`** | Nama dan ikon aplikasi pengirim. |
| **`actions`** | Daftar `NotificationAction`; setiap aksi punya `text` dan `invoke()`. |
| **`expire()`** | Menghancurkan notifikasi dan memberi sinyal timeout ke pengirim. |
| **`dismiss()`** | Menghancurkan notifikasi karena ditutup pengguna. |

### Hubungan dengan Modul Lain

- **Modul 2.5:** Jika notifikasi memiliki inline reply, Anda perlu mengambil fokus keyboard sementara; ini terkait dengan `WlrKeyboardFocus` dan rantai fokus QML.
- **Modul 2.2:** Anda dapat mengekspos “dismiss all” melalui `IpcHandler` untuk keybind.

### Sumber Referensi

- Quickshell — `Notification`: https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Notifications/Notification
- Quickshell — `NotificationAction`: https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Notifications/NotificationAction

### Tips dan Praktik Terbaik

- **Hormati `resident` dan `transient`.** Jangan memaksa semua notifikasi masuk riwayat atau hilang otomatis.
- **Gunakan `Text.PlainText` untuk body kecuali Anda benar-benar menangani markup dengan aman.**
- **Jangan mengandalkan `expireTimeout` selalu ada.** Periksa `> 0` sebelum memulai timer.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Timer berjalan untuk `resident` | Notifikasi hilang setelah aksi | Periksa `!modelData.resident`. |
| Body dirender sebagai markup | Teks aneh/format tidak diinginkan | Set `textFormat: Text.PlainText`. |
| Aksi tidak muncul | `actionsSupported` false | Set `actionsSupported: true` di server. |

---

## 4. `SystemTray`: StatusNotifierItem dan Menu Platform

### Deskripsi Konkret & Peran dalam Kurikulum

`SystemTray` adalah singleton yang melacak ikon tray melalui protokol StatusNotifierItem. Referensi ke singleton memulai pelacakan; item tersedia melalui `SystemTray.items` sebagai `ObjectModel<SystemTrayItem>`.

**Mengapa penting:** Banyak aplikasi latar belakang (NetworkManager, clipboard manager, chat client) hanya dapat diakses melalui tray. Tanpa tray, aplikasi-aplikasi ini “hilang” dari pandangan pengguna.

### Konsep Kunci & Filosofi

**StatusNotifierItem bukan spesifikasi tunggal yang ketat.** Dokumentasi Quickshell menyatakan: “roughly conforming to the kde/freedesktop spec (there is no real spec, we just implemented whatever seemed to actually be used)”. Artinya, perilaku tray bervariasi antar-aplikasi. Anda harus menangani kasus di mana item hanya memiliki menu (`onlyMenu`), tidak memiliki menu (`hasMenu: false`), atau activation tidak melakukan apa-apa.

**Menu platform vs menu QML.** `SystemTrayItem.display(parentWindow, x, y)` menampilkan **menu platform** (native) yang disediakan aplikasi, bukan menu QML yang Anda gambar sendiri. Ini penting: untuk aplikasi seperti NetworkManager, menu yang benar adalah menu platform mereka. Jika Anda mencoba menggambar menu sendiri, Anda mungkin kehilangan item menu yang kompleks.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Row {
    spacing: 4

    Repeater {
        model: SystemTray.items
        delegate: IconImage {
            required property var modelData
            source: modelData.icon
            implicitSize: 18

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        if (modelData.onlyMenu && modelData.hasMenu)
                            modelData.display(parent, mouse.x, mouse.y)
                        else
                            modelData.activate()
                    } else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate()
                    }
                }
            }
        }
    }
}
```

**Penjelasan kata-per-kata:**

- `model: SystemTray.items`: `ObjectModel<SystemTrayItem>` berisi semua ikon tray.
- `modelData.icon`: string ikon yang dapat digunakan sebagai `Image.source`.
- `modelData.onlyMenu`: jika `true`, item hanya menawarkan menu dan `activate()` tidak melakukan apa-apa. Dalam kasus ini, gunakan `display()`.
- `modelData.hasMenu`: jika `true`, item memiliki menu yang dapat ditampilkan.
- `modelData.display(parent, x, y)`: menampilkan menu platform relatif terhadap jendela induk.
- `modelData.activate()`: aksi aktivasi utama, biasanya klik kiri.
- `modelData.secondaryActivate()`: aksi aktivasi sekunder, biasanya klik tengah.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Ikon tray sederhana | `Image { source: modelData.icon }` | Gunakan `IconImage` untuk penanganan tema. |
| Klik kiri = menu | `modelData.display(...)` | Untuk item `onlyMenu`. |
| Klik kiri = activate | `modelData.activate()` | Untuk item yang mendukung activation. |
| Klik tengah | `modelData.secondaryActivate()` | Perilaku tergantung aplikasi. |
| Scroll (misalnya volume) | `modelData.scroll(delta, horizontal)` | Berguna untuk mixer. |

### Visualisasi: Keputusan Interaksi Tray

```text
Klik kiri pada ikon tray
        │
        ▼
Apakah onlyMenu == true?
   │ Ya                    │ Tidak
   ▼                       ▼
hasMenu?                 activate()
   │ Ya                    │
   ▼                       ▼
display(menu platform)   (aksi aplikasi)
```

**Penjelasan:** Jika item hanya menawarkan menu, jangan panggil `activate()`; panggil `display()` untuk membuka menu platform. Jika tidak, panggil `activate()`.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **StatusNotifierItem** | Protokol D-Bus untuk ikon tray. |
| **`SystemTray.items`** | `ObjectModel<SystemTrayItem>` berisi semua ikon tray. |
| **`onlyMenu`** | Jika `true`, item hanya memiliki menu; `activate()` tidak berguna. |
| **`hasMenu`** | Jika `true`, item memiliki menu yang dapat ditampilkan. |
| **`display()`** | Menampilkan menu platform di posisi relatif. |

### Hubungan dengan Modul Lain

- **Modul 2.1:** Tray biasanya ditempatkan di `PanelWindow` layer `Top` sebagai bagian dari bar.
- **Modul 2.5:** Navigasi keyboard untuk tray memerlukan fokus QML dan mungkin popup; ini akan dibahas di modul berikutnya.

### Sumber Referensi

- Quickshell — `SystemTray`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.SystemTray/SystemTray/
- Quickshell — `SystemTrayItem`: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.SystemTray/SystemTrayItem/
- StatusNotifierItem spec: https://www.freedesktop.org/wiki/Specifications/StatusNotifierItem/

### Tips dan Praktik Terbaik

- **Selalu periksa `onlyMenu` sebelum memanggil `activate()`.** Banyak aplikasi (misalnya NetworkManager) hanya menyediakan menu.
- **Gunakan `display()` untuk menu platform.** Jangan mencoba menggambar ulang menu aplikasi; Anda akan kehilangan fungsionalitas.
- **Tangani `icon` kosong.** Beberapa item mungkin tidak memiliki ikon; sediakan fallback.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Memanggil `activate()` pada `onlyMenu` | Tidak terjadi apa-apa | Gunakan `display()`. |
| Menggambar menu QML sendiri | Item menu hilang | Gunakan `display()` untuk menu platform. |
| Tidak menangani `icon` kosong | Ikon rusak | Sediakan fallback atau sembunyikan item. |

---

## 5. Launcher: `DesktopEntries`, `ScriptModel`, dan Pencarian

### Deskripsi Konkret & Peran dalam Kurikulum

Launcher adalah komponen yang mencari dan meluncurkan aplikasi terpasang. Quickshell menyediakan `DesktopEntries.applications` sebagai `ObjectModel<DesktopEntry>` yang berisi semua aplikasi bertipe `Application` yang tidak `Hidden` atau `NoDisplay`.

**Mengapa penting:** Launcher adalah antarmuka utama untuk meluncurkan aplikasi tanpa mouse. Namun, ada tiga jebakan: (1) `DesktopEntries` dimuat secara asinkron, (2) `ScriptModel` hanya menerima nilai unik, dan (3) `execute()` berbeda dari `command`.

### Konsep Kunci & Filosofi

**Desktop entry sebagai metadata, bukan perintah.** `DesktopEntry` menyimpan `name`, `icon`, `genericName`, `comment`, `keywords`, `categories`, `id`, dan `command`. `execString` adalah string mentah yang **tidak dapat diandalkan sebagai perintah**; gunakan `execute()` atau `command`.

**`execute()` vs `command`:** `execute()` menjalankan aplikasi dengan `workingDirectory` yang benar. `command` adalah array argumen yang dapat digunakan dengan `Quickshell.execDetached()` atau `Process`, tetapi **tidak memanggil terminal** meskipun `runInTerminal` bernilai `true`. Untuk launcher sederhana, gunakan `execute()`.

**`ScriptModel` untuk filter yang efisien.** Jika Anda menggunakan ekspresi JavaScript langsung sebagai model, `ListView` akan menghancurkan dan membuat ulang semua delegate setiap kali filter berubah, sehingga animasi rusak. `ScriptModel` hanya membuat/menghapus delegate yang diperlukan.

**Pemuatan asinkron.** `DesktopEntries.applications` dapat kosong saat `Component.onCompleted` dan bertambah secara bertahap. Launcher harus menangani keadaan kosong dan pembaruan model.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import QtQuick

Item {
    id: launcher
    property string query: ''

    ScriptModel {
        id: results
        values: {
            const q = launcher.query.trim().toLowerCase()
            const apps = DesktopEntries.applications.values
            if (q.length === 0)
                return apps.slice(0, 8)

            return apps.filter(entry => {
                const haystack = [
                    entry.name,
                    entry.genericName,
                    entry.comment,
                    entry.id,
                    ...(entry.keywords ?? [])
                ].join(' ').toLowerCase()
                return haystack.includes(q)
            }).slice(0, 8)
        }
    }

    ListView {
        anchors.fill: parent
        model: results
        delegate: Text {
            required property var modelData
            text: modelData.name
            color: 'white'
        }
    }

    Keys.onReturnPressed: {
        const first = results.values[0]
        if (first)
            first.execute()
    }
}
```

**Penjelasan kata-per-kata:**

- `property string query: ''`: query pencarian yang diperbarui oleh input keyboard.
- `ScriptModel { values: ... }`: model yang dihitung dari ekspresi JavaScript. Ketika `query` berubah, model diperbarui secara efisien.
- `DesktopEntries.applications.values`: array semua `DesktopEntry` yang tidak `Hidden`/`NoDisplay`.
- `entry.name`, `entry.genericName`, `entry.comment`, `entry.id`, `entry.keywords`: bidang yang digunakan untuk pencarian. `keywords` dapat kosong; `?? []` melindungi dari null.
- `.join(' ').toLowerCase()`: menggabungkan semua bidang menjadi satu string untuk pencarian case-insensitive.
- `.slice(0, 8)`: membatasi hasil menjadi 8 item.
- `results.values[0]`: item pertama dari model. `execute()` menjalankan aplikasi dengan `workingDirectory` yang benar.
- `Keys.onReturnPressed`: handler keyboard untuk Enter. Ini adalah bagian dari Modul 2.5, tetapi sudah digunakan di sini untuk melengkapi launcher.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Pencarian substring sederhana | `name.toLowerCase().includes(q)` | Cepat, tetapi tidak cocok untuk typo. |
| Pencarian multikolom | Gabungkan `name`, `genericName`, `comment`, `keywords` | Seperti contoh di atas. |
| Pencarian fuzzy | Implementasikan algoritma Levenshtein/skor | Di luar cakupan modul ini; tambahkan sebagai pengembangan. |
| Peluncuran aplikasi | `entry.execute()` | Menggunakan `workingDirectory`. |
| Peluncuran dengan terminal | Periksa `entry.runInTerminal` | `command` tidak memanggil terminal secara otomatis. |
| Peluncuran dengan `execDetached` | `Quickshell.execDetached(entry.command)` | Harus meneruskan `workingDirectory` juga. |

### Visualisasi: Alur Launcher

```text
Keyboard query
      │
      ▼
ScriptModel.values
      │
      ├── DesktopEntries.applications.values
      │        │
      │        ├── name, genericName, comment, keywords
      │        └── filter → slice(0, 8)
      │
      ▼
ListView (delegate per hasil)
      │
      ▼
Enter → results.values[0].execute()
```

**Penjelasan:** Query mengalir ke `ScriptModel`, yang memfilter `DesktopEntries.applications.values`. Hasilnya ditampilkan di `ListView`; Enter menjalankan item pertama.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`DesktopEntries`** | Singleton indeks desktop entry. |
| **`DesktopEntry`** | Satu aplikasi; memiliki `name`, `icon`, `command`, `execute()`, dll. |
| **`applications`** | `ObjectModel<DesktopEntry>` semua aplikasi yang tidak `Hidden`/`NoDisplay`. |
| **`execute()`** | Menjalankan aplikasi dengan `workingDirectory` yang benar. |
| **`command`** | Array argumen yang dapat digunakan dengan `Process`/`execDetached`. |
| **`ScriptModel`** | Model QML yang dihitung dari ekspresi JavaScript. |

### Hubungan dengan Modul Lain

- **Modul 2.5:** Launcher adalah contoh utama UI keyboard-driven; modul berikutnya akan menambahkan mode `normal`/`insert`, navigasi `j`/`k`, dan persistensi.
- **Modul 2.2:** Launcher dapat dipicu melalui `GlobalShortcut` atau `IpcHandler`.

### Sumber Referensi

- Quickshell — `DesktopEntries`: https://quickshell.org/docs/v0.3.0/types/Quickshell/DesktopEntries/
- Quickshell — `DesktopEntry`: https://quickshell.org/docs/v0.3.0/types/Quickshell/DesktopEntry/
- Quickshell — `ScriptModel`: https://quickshell.org/docs/v0.3.0/types/Quickshell/ScriptModel/
- Desktop Entry Specification: https://specifications.freedesktop.org/desktop-entry-spec/latest/

### Tips dan Praktik Terbaik

- **Gunakan `execute()`, bukan `execString`.** `execString` tidak dapat diandalkan sebagai perintah.
- **Gunakan `DesktopEntries.applications.values` di dalam `ScriptModel.values`** agar model menerima pembaruan saat daftar berubah.
- **Tangani daftar kosong saat startup.** Tampilkan “Mencari aplikasi…” atau spinner, bukan “Tidak ada hasil” secara permanen.
- **Batasi hasil** (misalnya 8–10) agar UI tetap responsif.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menganggap `applications` langsung penuh | “Tidak ada aplikasi” saat startup | Tangani keadaan kosong; model akan terisi. |
| Menggunakan `ScriptModel` dengan daftar duplikat | Perilaku tidak terdefinisi | Pastikan daftar unik; `DesktopEntries.applications.values` sudah unik. |
| Memanggil `execString` sebagai perintah | Aplikasi tidak berjalan | Gunakan `execute()` atau `command`. |
| `sort()` langsung pada `applications.values` | Error karena list read-only | Gunakan spread: `[...values].sort(...)`. |

---

## 6. Integrasi dan Keamanan

### Deskripsi Konkret & Peran dalam Kurikulum

Notifikasi, tray, dan launcher semuanya berjalan di dalam proses shell. Launcher yang meluncurkan aplikasi **mewarisi environment shell**. Ini relevan dengan prinsip keamanan yang Anda tekankan.

### Konsep Kunci & Filosofi

**Environment adalah warisan.** Ketika `execute()` atau `Quickshell.execDetached()` dipanggil, proses baru mewarisi environment shell, termasuk variabel seperti `SSH_AUTH_SOCK`, `GPG_AGENT_INFO`, atau token yang tidak seharusnya tersedia. Shell sebaiknya **tidak menyimpan rahasia di environment-nya**.

**Notifikasi membawa data dari pihak ketiga.** `body` dan `summary` berasal dari aplikasi lain. Jangan merender markup mentah kecuali Anda memahaminya; gunakan `Text.PlainText` untuk body jika Anda tidak mengiklankan `bodyMarkupSupported`.

**Izin file.** Quickshell dan `qs ipc` berkomunikasi melalui mekanisme IPC lokal; pastikan hanya pengguna yang sama dapat mengaksesnya. Ini adalah pertimbangan yang sama seperti Modul 2.2.

### Tips dan Praktik Terbaik

- **Jangan menyimpan rahasia di environment shell.**
- **Gunakan `Text.PlainText` untuk body notifikasi kecuali Anda sengaja mendukung markup.**
- **Untuk launcher, pertimbangkan untuk tidak mewariskan environment yang kaya** jika aplikasi tidak memerlukannya, tetapi hati-hati: banyak aplikasi memerlukan `DISPLAY`, `WAYLAND_DISPLAY`, dan `DBUS_SESSION_BUS_ADDRESS`.

---

## 7. Latihan dan Checkpoint

### Latihan (sesuai kurikulum)

**Buat popup notifikasi yang hilang otomatis dan launcher yang meluncurkan aplikasi dengan Enter.**

**Langkah-langkah notifikasi:**

1. Buat `NotificationServer` dengan `actionsSupported: true`, `imageSupported: true`, `bodySupported: true`.
2. Di `onNotification`, set `notif.tracked = true`.
3. Tampilkan `server.trackedNotifications` di `Column`/`ListView`.
4. Untuk setiap notifikasi, tampilkan `summary`, `body`, `appIcon`.
5. Tambahkan `Timer` dengan `interval: expireTimeout * 1000` jika `expireTimeout > 0 && !resident`.
6. Pada timeout, panggil `modelData.expire()`.
7. Tambahkan tombol dismiss yang memanggil `modelData.dismiss()`.
8. Jika `actions` ada, render tombol dan panggil `action.invoke()`.

**Langkah-langkah launcher:**

1. Buat `ScriptModel` dengan `values` yang memfilter `DesktopEntries.applications.values`.
2. Tampilkan hasil di `ListView`.
3. Pada `Keys.onReturnPressed`, panggil `results.values[0]?.execute()`.
4. Tangani keadaan kosong saat `DesktopEntries` belum selesai dimuat.

**Uji:**

```bash
notify-send "Halo" "Ini notifikasi dari shell saya"
busctl --user list | grep -i Notifications
```

Pastikan notifikasi muncul di shell Anda, bukan di daemon lain. Jika tidak muncul, periksa `busctl` dan `tracked`.

**Checkpoint:** Kirim `notify-send halo` dan tunjukkan notifikasinya tampil di shell Anda, bukan di daemon lain.

**Jawaban singkat:** Saya menghentikan `dunst`/`mako`, memverifikasi dengan `busctl --user list | grep -i Notifications` bahwa nama `org.freedesktop.Notifications` tidak dipegang proses lain, menjalankan `NotificationServer` dengan `onNotification: notif => notif.tracked = true`, lalu mengirim `notify-send halo`. Notifikasi muncul di `trackedNotifications` dan dirender oleh delegate saya.

---

## Motivasi

Notifikasi, tray, dan launcher adalah tiga komponen yang membuat shell Anda terasa **hidup**. Mereka menghubungkan Anda dengan aplikasi lain, dengan status sistem, dan dengan aplikasi yang ingin Anda jalankan. Kuasai ketiganya, dan shell Anda bukan lagi sekadar panel—ia menjadi pusat interaksi yang lengkap. Teruslah membangun; setiap notifikasi yang muncul dan setiap aplikasi yang diluncurkan adalah bukti bahwa shell Anda benar-benar bekerja.

---

Kita akan melanjutkan ke **Modul 2.5 — Navigasi Keyboard-Driven dan Persistensi State**, modul penutup Fase 2.

---

## Audit Singkat Modul 2.5

**Temuan audit:**

1. **Kurikulum menyebut “fokus eksklusif hanya selama launcher terbuka, lepaskan saat ditutup.”** Ini benar, tetapi ada jebakan teknis yang belum disebut: mengubah `WlrLayershell.keyboardFocus` dari `Exclusive` ke `None` saat jendela masih terlihat dapat menyebabkan race condition di mana permukaan segera merebut fokus kembali. Solusi yang digunakan di praktik nyata adalah menunda pelepasan fokus dengan `Qt.callLater` setelah visibilitas benar-benar berubah, atau mengatur `visible: false` terlebih dahulu lalu melepas fokus. Materi ini akan menambahkan detail tersebut sebagai **materi tambahan** yang tetap mengacu pada kurikulum.

2. **`Keys.onPressed` vs `Keys.onReturnPressed` vs `Keys.onEscapePressed`** — kurikulum hanya menyebut `Keys.onPressed`. Padahal QML menyediakan handler spesifik (`onReturnPressed`, `onEscapePressed`, `onEnterPressed`) yang lebih ringkas dan menghindari pengecekan `event.key` manual. Materi ini akan menjelaskan keduanya.

3. **`Shortcut` tidak disebutkan di kurikulum**, padahal ia adalah mekanisme ketiga untuk keyboard selain `Keys.onPressed` dan `GlobalShortcut`/`IpcHandler`. `Shortcut` bekerja **selama jendela memiliki fokus**, tanpa memerlukan `focus: true` pada item tertentu. Ini penting untuk membedakan tiga lapisan keyboard: (a) global (compositor), (b) jendela (Shortcut), (c) item (Keys + focus). Materi ini akan menambahkannya.

4. **`FileView` memiliki banyak properti yang tidak disebutkan kurikulum** tetapi krusial untuk persistensi yang benar: `blockLoading`, `atomicWrites`, `printErrors`, `preload`. Materi ini akan menjelaskan mana yang perlu diubah dan mana yang sebaiknya dibiarkan default.

5. **`JsonAdapter` hanya mendukung tipe tertentu.** Dokumentasi menyatakan tipe yang didukung: primitif (`int`, `bool`, `string`, `real`), `JsonObject` (sub-object), `var` (JSON object/array), dan `list<T>`. Tipe QML lain (misalnya `color`, `url`, `enum`) **tidak didukung secara langsung** dan harus dikonversi. Ini adalah jebakan yang belum disebut kurikulum.

6. **`Quickshell.statePath()` menggunakan `$XDG_STATE_HOME`**, bukan `$XDG_CONFIG_HOME`. Ini penting untuk keamanan dan kebersihan: state (preferensi runtime) berbeda dari config (konfigurasi pengguna). Materi ini akan menegaskan perbedaan tersebut.

7. **Kurikulum menyebut “simpan preferensi saja, bukan rahasia”** — prinsip ini benar, tetapi perlu penjabaran teknis: `FileView` menulis plaintext ke disk; tidak ada enkripsi. Jika Anda menyimpan token, siapa pun dengan akses baca ke file dapat membacanya. Materi ini akan menambahkan panduan tentang apa yang boleh dan tidak boleh disimpan.

Dengan catatan ini, saya akan membangun Modul 2.5 selengkap mungkin.

---

# Modul 2.5 — Navigasi Keyboard-Driven dan Persistensi State

> *“Fokus adalah mikrofon; hanya satu yang bicara pada satu waktu. Persistensi adalah ingatan; shell yang lupa harus belajar lagi setiap kali ia bangun.”*

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Tiga lapisan keyboard: global, jendela, item** — di mana `GlobalShortcut`, `Shortcut`, dan `Keys` berada.
2. **Rantai fokus QML** — `focus`, `activeFocus`, propagasi event, dan `event.accepted`.
3. **`Keys.onPressed` dan handler spesifik** — kapan memakai yang mana.
4. **Mode fokus layer-shell: siklus buka-tutup launcher** — mengapa fokus eksklusif harus dilepas, dan bagaimana melakukannya dengan aman.
5. **Mode modal ala vim** — `normal` vs `insert`, navigasi `j`/`k`, dan transisi mode.
6. **Persistensi: `FileView`, `JsonAdapter`, `Quickshell.statePath`** — membaca, menulis, dan menyinkronkan state.
7. **Keamanan persistensi** — apa yang boleh dan tidak boleh disimpan.
8. **Latihan, checkpoint, dan praktik terbaik**.

---

## 1. Tiga Lapisan Keyboard: Global, Jendela, Item

### Deskripsi Konkret & Peran dalam Kurikulum

Keyboard di Quickshell beroperasi pada **tiga lapisan** yang berbeda:

| Lapisan | Mekanisme | Cakupan | Contoh |
|---|---|---|---|
| **Global** | `GlobalShortcut` (Hyprland) | Seluruh sesi, bahkan saat shell tidak fokus | `SUPER+Space` → toggle launcher |
| **Jendela** | `Shortcut` (QtQuick) | Jendela shell, selama jendela memiliki fokus | `Ctrl+Q` → tutup popup |
| **Item** | `Keys.onPressed` + `focus` | Item QML tertentu yang memiliki `activeFocus` | `Escape` → tutup launcher |

**Mengapa penting:** Kurikulum menyebut “pintasan satu jendela vs global (`GlobalShortcut`, `IpcHandler`)” sebagai bagian dari Daftar Isi. Namun, ada lapisan tengah yang sering terlewat: `Shortcut` di tingkat jendela. Memahami ketiganya mencegah Anda menggunakan `GlobalShortcut` untuk hal-hal yang seharusnya cukup ditangani `Keys`, atau sebaliknya.

### Konsep Kunci & Filosofi

**Global** berarti compositor mengirim event ke shell **tanpa peduli jendela mana yang fokus**. Ini memerlukan protokol khusus (`hyprland_global_shortcuts_v1`) dan hanya berfungsi di Hyprland.

**Jendela** berarti event keyboard mencapai jendela shell karena jendela itu memiliki fokus (misalnya launcher sedang terbuka), lalu `Shortcut` menangkapnya **sebelum** item tertentu. `Shortcut` tidak memerlukan `focus: true` pada item; ia bekerja di tingkat `Window`.

**Item** berarti event mencapai item tertentu karena item itu memiliki `activeFocus`. Hanya satu item per jendela yang dapat memiliki `activeFocus` pada satu waktu.

**Analogi:** Global adalah pengumuman lewat speaker gedung—siapa pun di gedung mendengarnya. Jendela adalah microphone di ruangan tertentu—hanya orang di ruangan itu yang mendengar. Item adalah siapa yang sedang memegang microphone—hanya satu orang.

### Visualisasi: Tiga Lapisan Keyboard

```text
┌─────────────────────────────────────────────────────┐
│  GLOBAL (compositor)                                │
│  GlobalShortcut — bekerja bahkan saat shell tidak   │
│  fokus. Hanya Hyprland.                             │
│                                                     │
│  ┌───────────────────────────────────────────────┐  │
│  │  JENDELA (Window)                             │  │
│  │  Shortcut — bekerja selama jendela fokus,     │  │
│  │  tanpa perlu item tertentu fokus.             │  │
│  │                                               │  │
│  │  ┌─────────────────────────────────────────┐  │  │
│  │  │  ITEM (activeFocus)                     │  │  │
│  │  │  Keys.onPressed — bekerja hanya jika    │  │  │
│  │  │  item ini memiliki activeFocus.         │  │  │
│  │  └─────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

**Penjelasan:** Event keyboard “jatuh” dari lapisan global ke jendela ke item. `GlobalShortcut` menangkap di lapisan terluar; jika tidak ada, event mencapai jendela; `Shortcut` menangkap di lapisan tengah; jika tidak ada, event mencapai item yang memiliki `activeFocus`.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls

Item {
    // 1. Global (Hyprland)
    GlobalShortcut {
        appid: 'quickshell'
        name: 'launcher'
        onPressed: launcher.visible = !launcher.visible
    }

    // 2. Jendela (Shortcut)
    Shortcut {
        sequence: 'Ctrl+Q'
        onActivated: Qt.quit()
    }

    // 3. Item (Keys)
    Item {
        focus: true
        Keys.onEscapePressed: console.log('Escape di item')
    }
}
```

**Penjelasan kata-per-kata:**

- `GlobalShortcut { ... }`: mendaftarkan pintasan global melalui Hyprland. `appid:name` harus cocok dengan keybind `bind = ..., global, quickshell:launcher`.
- `Shortcut { sequence: 'Ctrl+Q'; onActivated: Qt.quit() }`: `Shortcut` dari QtQuick bekerja selama jendela memiliki fokus. Tidak memerlukan `focus: true` pada item.
- `Keys.onEscapePressed`: handler spesifik untuk Escape. Hanya dipanggil jika item ini memiliki `activeFocus`.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Lapisan | Mekanisme |
|---|---|---|
| Toggle launcher dari mana saja | Global | `GlobalShortcut` + keybind Hyprland |
| Tutup popup saat popup fokus | Jendela | `Shortcut` |
| Navigasi `j`/`k` di dalam launcher | Item | `Keys.onPressed` + `activeFocus` |
| Toggle bar dari Sway | Global (via CLI) | `IpcHandler` + `bindsym` |

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **Global shortcut** | Pintasan yang dikirim compositor tanpa peduli fokus jendela. |
| **`Shortcut`** | Tipe QtQuick yang menangkap kombinasi tombol di tingkat jendela. |
| **`activeFocus`** | Properti item yang menunjukkan apakah item ini penerima event keyboard saat ini. |
| **`focus: true`** | Permintaan agar item menjadi fokus; hanya satu per jendela yang menang. |

### Hubungan dengan Modul Lain

- **Modul 2.2:** `GlobalShortcut` dan `IpcHandler` adalah dua jalur global yang sudah dibahas.
- **Modul 2.4:** Launcher memerlukan kombinasi ketiga lapisan: global untuk membuka, jendela untuk `Ctrl+Q`, item untuk navigasi.

### Sumber Referensi

- Quickshell Book — Keys & Focus: https://programmersd21.github.io/the_quickshell_book/part-1-qml/keys-and-focus
- Qt Documentation — Keyboard Focus in Qt Quick: https://doc.qt.io/qt-6/qtquick-input-focus.html
- Quickshell — `GlobalShortcut`: https://quickshell.org/docs/v0.3.0/types/Quickshell.Hyprland/GlobalShortcut/

### Tips dan Praktik Terbaik

- **Gunakan `GlobalShortcut` hanya untuk aksi yang harus bekerja saat shell tidak fokus.**
- **Gunakan `Shortcut` untuk aksi yang relevan selama jendela shell fokus** (misalnya `Ctrl+Q` di popup).
- **Gunakan `Keys` untuk navigasi di dalam komponen tertentu** (misalnya `j`/`k` di launcher).

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Memakai `GlobalShortcut` untuk navigasi item | Semua tombol tertangkap secara global | Gunakan `Keys` + `activeFocus`. |
| Memakai `Shortcut` untuk toggle launcher | Tidak bekerja saat launcher tidak fokus | Gunakan `GlobalShortcut`. |
| `focus: true` pada dua item | Hanya yang terakhir menang | Gunakan `forceActiveFocus()` secara eksplisit. |

---

## 2. Rantai Fokus QML: `focus`, `activeFocus`, dan Propagasi Event

### Deskripsi Konkret & Peran dalam Kurikulum

QML mengelola fokus melalui **rantai fokus** (focus chain). Setiap item dapat meminta fokus dengan `focus: true`. Namun, permintaan ini bersifat hierarkis: item yang memiliki `focus: true` hanya benar-benar menerima keyboard jika **seluruh leluhurnya** juga memiliki fokus aktif. Properti `activeFocus` menunjukkan apakah item tersebut benar-benar penerima event saat ini.

**Mengapa penting:** Kesalahan paling umum dalam navigasi keyboard adalah mengatur `focus: true` pada item yang leluhurnya tidak fokus, sehingga item tersebut tidak pernah menerima event. Memahami rantai fokus adalah prasyarat untuk semua navigasi keyboard.

### Konsep Kunci & Filosofi

**Fokus sebagai spotlight hierarkis.** Bayangkan gedung dengan banyak ruangan. `focus: true` berarti “saya ingin microphone di ruangan ini.” Tetapi jika pintu ruangan induk tertutup (leluhur tidak fokus), microphone di ruangan anak tidak terhubung ke sistem. `activeFocus` adalah konfirmasi bahwa microphone benar-benar aktif.

**Propagasi event.** Ketika tombol ditekan, event dikirim ke item dengan `activeFocus`. Jika item tersebut **tidak** menangani event (atau menangani tetapi tidak menyetel `event.accepted = true`), event **naik ke parent**. Proses ini berulang sampai root atau sampai ada item yang menerima event.

**`event.accepted`.** Secara default, `event.accepted` bernilai `false` di dalam handler. Jika Anda menangani tombol tetapi lupa menyetel `event.accepted = true`, event akan terus naik ke parent dan mungkin memicu handler yang tidak diinginkan.

### Sintaks Dasar / Contoh Implementasi

```qml
import QtQuick

Item {
    id: root
    focus: true

    Keys.onPressed: event => {
        console.log('Root menerima:', event.key)
        // tidak set accepted → event bisa naik lebih jauh
    }

    Item {
        id: child
        focus: true   // child meminta fokus; tetapi root juga fokus

        Keys.onPressed: event => {
            if (event.key === Qt.Key_J) {
                console.log('Child menangani J')
                event.accepted = true   // hentikan propagasi
            }
            // jika bukan J, event naik ke root
        }
    }
}
```

**Penjelasan kata-per-kata:**

- `root { focus: true }`: root meminta fokus.
- `child { focus: true }`: child juga meminta fokus. Dalam QML, item terakhir yang menang; child menjadi `activeFocus` jika root fokus.
- `Keys.onPressed` di child: dipanggil terlebih dahulu karena child memiliki `activeFocus`.
- `event.accepted = true`: menghentikan propagasi ke root. Tanpa ini, event juga akan sampai ke handler root.
- Jika `event.key !== Qt.Key_J`, `event.accepted` tetap `false`, sehingga event naik ke root.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Fokus otomatis saat startup | `focus: true` pada satu item | Pastikan leluhur juga fokus. |
| Fokus programatik | `item.forceActiveFocus()` | Memberi fokus ke item dan seluruh rantai leluhurnya. |
| Navigasi Tab | `KeyNavigation.tab` | Menentukan item berikutnya saat Tab. |
| Navigasi panah | `KeyNavigation.left/right/up/down` | Menentukan target per arah. |

### Visualisasi: Propagasi Event

```text
Key event datang
      │
      ▼
Item dengan activeFocus
      │
      ├── Handler menangani & accepted = true → STOP
      │
      └── Handler tidak menangani / accepted = false
              │
              ▼
          Parent item
              │
              ├── Handler menangani & accepted = true → STOP
              │
              └── ... naik sampai root
```

**Penjelasan:** Event dimulai dari item dengan `activeFocus` dan naik ke parent jika tidak diterima. `event.accepted = true` menghentikan propagasi.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`focus`** | Permintaan item untuk menjadi fokus. |
| **`activeFocus`** | Properti readonly; `true` jika item benar-benar menerima event keyboard. |
| **`forceActiveFocus()`** | Memberi fokus ke item dan memastikan seluruh rantai leluhurnya fokus. |
| **`event.accepted`** | Jika `true`, propagasi event berhenti. |
| **`KeyNavigation`** | Attached property untuk menentukan target fokus per arah tombol. |

### Hubungan dengan Modul Lain

- **Modul 2.1:** `WlrLayershell.keyboardFocus` adalah lapisan Wayland dari fokus; tanpa itu, event tidak sampai ke jendela, sehingga rantai fokus QML tidak pernah dimulai.
- **Modul 2.4:** Launcher menggunakan rantai fokus untuk navigasi hasil.

### Sumber Referensi

- Qt Documentation — Keyboard Focus in Qt Quick: https://doc.qt.io/qt-6/qtquick-input-focus.html
- Quickshell Book — Keys & Focus: https://programmersd21.github.io/the_quickshell_book/part-1-qml/keys-and-focus

### Tips dan Praktik Terbaik

- **Selalu set `event.accepted = true` ketika Anda menangani tombol.**
- **Gunakan `forceActiveFocus()` alih-alih `focus = true` untuk fokus programatik.**
- **Hindari `focus: true` pada banyak item; pilih satu titik masuk fokus.**

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `focus: true` tanpa leluhur fokus | Item tidak menerima event | Pastikan rantai leluhur fokus atau gunakan `forceActiveFocus()`. |
| Lupa `event.accepted = true` | Handler parent juga terpicu | Set `event.accepted = true`. |
| Dua item `focus: true` | Hanya satu yang menang | Gunakan `forceActiveFocus()` secara eksplisit. |

---

## 3. `Keys.onPressed` dan Handler Spesifik

### Deskripsi Konkret & Peran dalam Kurikulum

QML menyediakan dua cara menangani tombol: **handler umum** (`Keys.onPressed`) dan **handler spesifik** (`Keys.onEscapePressed`, `Keys.onReturnPressed`, `Keys.onEnterPressed`, `Keys.onSpacePressed`, dll.). Kurikulum hanya menyebut `Keys.onPressed`, tetapi handler spesifik lebih ringkas dan mengurangi boilerplate.

**Mengapa penting:** Dalam launcher, Anda biasanya menangani `Escape` (tutup), `Return` (jalankan), dan tombol navigasi (`j`/`k`). Menggunakan handler spesifik untuk `Escape` dan `Return` membuat kode lebih bersih; gunakan `onPressed` hanya untuk tombol yang tidak memiliki handler spesifik (seperti `j`/`k`).

### Konsep Kunci & Filosofi

**Handler spesifik adalah gula sintaksis.** `Keys.onEscapePressed` setara dengan `Keys.onPressed` yang memeriksa `event.key === Qt.Key_Escape` dan menyetel `event.accepted = true`. Namun, handler spesifik **secara otomatis** menyetel `accepted` jika Anda tidak menyetelnya ke `false`, sehingga lebih sulit lupa.

**Kapan memakai `onPressed`:** Ketika Anda perlu menangani banyak tombol dalam satu handler, atau ketika tombol tidak memiliki handler spesifik. Untuk navigasi `j`/`k`, `onPressed` adalah pilihan yang tepat karena `J` dan `K` bukan tombol khusus.

### Sintaks Dasar / Contoh Implementasi

```qml
Item {
    focus: true

    // Handler spesifik: ringkas, accepted otomatis
    Keys.onEscapePressed: launcher.visible = false
    Keys.onReturnPressed: {
        const first = results.values[0]
        if (first) first.execute()
    }

    // Handler umum: untuk tombol yang tidak punya handler spesifik
    Keys.onPressed: event => {
        if (event.key === Qt.Key_J) {
            list.incrementCurrentIndex()
            event.accepted = true
        } else if (event.key === Qt.Key_K) {
            list.decrementCurrentIndex()
            event.accepted = true
        }
    }
}
```

**Penjelasan kata-per-kata:**

- `Keys.onEscapePressed: ...`: dipanggil hanya untuk Escape. Tidak perlu memeriksa `event.key`; `accepted` otomatis `true`.
- `Keys.onReturnPressed: ...`: dipanggil untuk Return (dan Enter di beberapa platform). Cocok untuk aksi “jalankan”.
- `Keys.onPressed: event => { ... }`: handler umum. Di sini, `j` dan `k` ditangani; `event.accepted = true` wajib agar tidak naik ke parent.
- `list.incrementCurrentIndex()` / `decrementCurrentIndex()`: method `ListView` untuk memindahkan selection.

**Opsi lain untuk tujuan yang sama:**

| Tombol | Handler spesifik | Handler umum |
|---|---|---|
| Escape | `onEscapePressed` | `onPressed` + cek `Qt.Key_Escape` |
| Return | `onReturnPressed` | `onPressed` + cek `Qt.Key_Return` |
| Space | `onSpacePressed` | `onPressed` + cek `Qt.Key_Space` |
| `j` / `k` | tidak ada | `onPressed` + cek `Qt.Key_J` / `Qt.Key_K` |

### Visualisasi: Kapan Handler Dipanggil

```text
Key event: Escape
      │
      ▼
Apakah ada Keys.onEscapePressed?
   │ Ya                    │ Tidak
   ▼                       ▼
Dipanggil (accepted=true)  Keys.onPressed (cek manual)

Key event: J
      │
      ▼
Apakah ada handler spesifik untuk J?
   │ Tidak (tidak ada)     │
   ▼                       │
Keys.onPressed (cek manual)
```

**Penjelasan:** Handler spesifik dipanggil lebih dulu. Jika tidak ada, `onPressed` dipanggil.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **Handler spesifik** | `onEscapePressed`, `onReturnPressed`, dll.; hanya untuk tombol tertentu. |
| **Handler umum** | `onPressed`; dipanggil untuk semua tombol yang tidak ditangani handler spesifik. |
| **`event.key`** | Kode tombol (misalnya `Qt.Key_J`). |
| **`event.modifiers`** | Modifier yang ditekan (misalnya `Qt.ControlModifier`). |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Launcher menggunakan `onReturnPressed` untuk menjalankan aplikasi.
- **Modul 2.5 (bagian berikutnya):** Mode modal menggunakan `onPressed` untuk transisi mode.

### Sumber Referensi

- Qt Documentation — `Keys` attached property: https://doc.qt.io/qt-6/qml-qtquick-keys.html
- Quickshell Book — Keys & Focus: https://programmersd21.github.io/the_quickshell_book/part-1-qml/keys-and-focus

### Tips dan Praktik Terbaik

- **Gunakan handler spesifik untuk tombol khusus (Escape, Return, Space) agar kode lebih bersih.**
- **Gunakan `onPressed` untuk navigasi kustom (`j`/`k`) dan selalu set `event.accepted = true`.**

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Lupa `accepted = true` di `onPressed` | Handler parent ikut terpicu | Set `event.accepted = true`. |
| Menggunakan `onPressed` untuk Escape | Kode lebih panjang dari perlu | Gunakan `onEscapePressed`. |
| Handler spesifik dan umum tumpang tindih | Escape ditangani dua kali | Pilih salah satu; handler spesifik menang. |

---

## 4. Mode Fokus Layer-Shell: Siklus Buka-Tutup Launcher

### Deskripsi Konkret & Peran dalam Kurikulum

Modul 2.1 memperkenalkan `WlrKeyboardFocus` (`None`, `OnDemand`, `Exclusive`). Di sini, kita menerapkannya pada siklus hidup launcher: saat launcher tersembunyi, fokus `None`; saat terbuka, fokus `Exclusive`; saat ditutup, kembali ke `None`.

**Mengapa penting:** Tanpa mengubah mode fokus secara dinamis, launcher tidak akan menerima ketikan, atau sebaliknya, akan terus mencuri fokus dari jendela lain setelah ditutup. Ini adalah pola dasar untuk semua overlay keyboard-driven.

### Konsep Kunci & Filosofi

**Fokus eksklusif adalah “mikrofon yang dipegang.”** Saat launcher terbuka, ia memegang mikrofon (`Exclusive`) sehingga semua ketikan masuk ke launcher. Saat ditutup, ia harus **melepaskan mikrofon** (`None`) agar ketikan kembali ke jendela aktif.

**Jebakan race condition:** Mengubah `keyboardFocus` dari `Exclusive` ke `None` saat jendela masih terlihat dapat menyebabkan permukaan segera merebut fokus kembali sebelum compositor sempat memproses pelepasan. Praktik nyata menyarankan: sembunyikan jendela terlebih dahulu (`visible: false`), lalu lepaskan fokus dengan `Qt.callLater` untuk memastikan compositor sudah memproses perubahan visibilitas.

**Mengapa `Exclusive` bukan lockscreen:** Sudah dibahas di Modul 2.1; di sini hanya ditegaskan kembali sebagai prinsip keamanan.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: launcher
    visible: false
    implicitWidth: 480
    implicitHeight: 320
    color: 'transparent'

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

    Item {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: {
            launcher.visible = false
            // Pastikan fokus dilepas setelah visibilitas berubah
            Qt.callLater(() => {
                launcher.WlrLayershell.keyboardFocus = WlrKeyboardFocus.None
            })
        }
    }
}
```

**Penjelasan kata-per-kata:**

- `visible: false`: launcher tersembunyi secara default.
- `WlrLayershell.keyboardFocus: visible ? Exclusive : None`: binding reaktif. Saat `visible` berubah, mode fokus berubah.
- `Keys.onEscapePressed`: saat Escape, set `visible = false`. Binding akan mengubah `keyboardFocus` ke `None`.
- `Qt.callLater(() => { ... })`: menunda penetapan fokus secara eksplisit hingga event loop berikutnya. Ini mengurangi risiko race condition di beberapa compositor.

**Opsi lain untuk tujuan yang sama:**

| Pendekatan | Kelebihan | Kekurangan |
|---|---|---|
| Binding ternary `visible ? Exclusive : None` | Sederhana, deklaratif | Bisa race di beberapa compositor |
| `visible = false` + `Qt.callLater` set `None` | Lebih aman | Sedikit lebih verbose |
| Tetap `Exclusive` saat tersembunyi | Sederhana | Mencuri fokus dari jendela lain (salah) |

### Visualisasi: Siklus Fokus Launcher

```text
Launcher tersembunyi                    Launcher terlihat
┌─────────────────────┐                ┌─────────────────────┐
│ visible: false      │                │ visible: true       │
│ keyboardFocus: None │  ── trigger ──>│ keyboardFocus:      │
│                     │                │   Exclusive         │
│ (ketikan ke jendela │                │                     │
│  lain)              │                │(ketikan ke launcher)│
└─────────────────────┘                └─────────────────────┘
          ▲                                      │
          │            ── Escape ──              │
          │    visible = false                   │
          └──────────────────────────────────────┘
               keyboardFocus → None
```

**Penjelasan:** Saat tersembunyi, `None`. Saat dipanggil, `Exclusive`. Saat ditutup, kembali ke `None`.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`WlrKeyboardFocus.Exclusive`** | Fokus keyboard eksklusif; jendela lain tidak menerima ketikan. |
| **Race condition** | Kondisi di mana urutan operasi memengaruhi hasil; di sini, pelepasan fokus sebelum visibilitas berubah. |
| **`Qt.callLater`** | Menunda pemanggilan fungsi hingga event loop berikutnya. |

### Hubungan dengan Modul Lain

- **Modul 2.1:** `WlrKeyboardFocus` diperkenalkan.
- **Modul 2.4:** Launcher adalah komponen yang menggunakan pola ini.
- **Modul 2.2:** Launcher dapat dipicu melalui `GlobalShortcut` atau `IpcHandler`.

### Sumber Referensi

- Quickshell — `WlrKeyboardFocus`: https://quickshell.org/docs/v0.3.1/types/Quickshell.Wayland/WlrKeyboardFocus/
- Quickshell — `WlrLayershell` (`keyboardFocus`): https://quickshell.org/docs/v0.3.1/types/Quickshell.Wayland/WlrLayershell/

### Tips dan Praktik Terbaik

- **Gunakan binding ternary untuk kesederhanaan; gunakan `Qt.callLater` jika Anda mengalami race condition.**
- **Selalu pastikan `keyboardFocus` kembali ke `None` saat launcher ditutup.**
- **Jangan gunakan `Exclusive` untuk lockscreen.**

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Fokus tetap `Exclusive` setelah ditutup | Ketikan tidak kembali ke jendela lain | Binding ternary atau `Qt.callLater` untuk set `None`. |
| Race condition saat melepas fokus | Fokus “macet” di launcher | Sembunyikan dulu, lalu lepaskan fokus dengan `Qt.callLater`. |

---

## 5. Mode Modal ala Vim: `normal` vs `insert`

### Deskripsi Konkret & Peran dalam Kurikulum

Mode modal adalah pola di mana **satu tombol berarti hal berbeda tergantung mode**. Dalam launcher ala vim: mode `normal` untuk navigasi (`j`/`k`), mode `insert` untuk mengetik query. Mode disimpan sebagai properti (`mode: 'normal'` atau `'insert'`), dan handler tombol memeriksa mode sebelum bertindak.

**Mengapa penting:** Kurikulum menyebut “mode modal ala vim” sebagai bagian dari latihan. Ini adalah pola yang sangat kuat untuk shell keyboard-driven: Anda dapat menggunakan tombol yang sama untuk tujuan berbeda tanpa menambah kombinasi modifier.

### Konsep Kunci & Filosofi

**Mode sebagai state eksplisit.** Daripada menebak apakah pengguna ingin mengetik atau menavigasi, shell **menanyakan** melalui mode. Di mode `normal`, `j`/`k` memindahkan selection; di mode `insert`, `j`/`k` mengetik huruf. Transisi mode eksplisit: `i` masuk ke `insert`, `Escape` kembali ke `normal`.

**Mode sebagai properti QML.** Properti `mode` dapat di-bind ke UI (misalnya indikator “-- NORMAL --” di bagian bawah layar) dan ke handler tombol. Ini adalah contoh sempurna dari reaktivitas QML: perubahan mode secara otomatis memperbarui UI dan perilaku.

**Fokus dan mode adalah dua hal berbeda.** Mode menentukan **apa arti tombol**; fokus menentukan **apakah tombol sampai ke item**. Keduanya harus dikelola bersama: launcher harus memiliki fokus (`Exclusive` + `activeFocus`) dan mode yang benar.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: launcher
    visible: false
    implicitWidth: 480
    implicitHeight: 320
    color: 'transparent'

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

    property string mode: 'normal'   // 'normal' | 'insert'
    property string query: ''

    Item {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: {
            if (launcher.mode === 'insert') {
                launcher.mode = 'normal'
            } else {
                launcher.visible = false
            }
        }

        Keys.onPressed: event => {
            if (launcher.mode === 'normal') {
                if (event.key === Qt.Key_J) {
                    list.incrementCurrentIndex()
                    event.accepted = true
                } else if (event.key === Qt.Key_K) {
                    list.decrementCurrentIndex()
                    event.accepted = true
                } else if (event.key === Qt.Key_I) {
                    launcher.mode = 'insert'
                    event.accepted = true
                } else if (event.key === Qt.Key_Return) {
                    const first = results.values[0]
                    if (first) first.execute()
                    event.accepted = true
                }
            } else if (launcher.mode === 'insert') {
                if (event.key === Qt.Key_Backspace && launcher.query.length > 0) {
                    launcher.query = launcher.query.slice(0, -1)
                    event.accepted = true
                }
                // karakter lain ditangani oleh TextInput
            }
        }

        TextInput {
            id: input
            visible: launcher.mode === 'insert'
            text: launcher.query
            onTextChanged: launcher.query = text
            focus: launcher.mode === 'insert'
        }

        ListView {
            id: list
            anchors.fill: parent
            // model: results ...
        }
    }
}
```

**Penjelasan kata-per-kata:**

- `property string mode: 'normal'`: state mode. Nilai awal `normal`.
- `Keys.onEscapePressed`: jika di `insert`, kembali ke `normal`; jika di `normal`, tutup launcher.
- `Keys.onPressed`: memeriksa `mode`. Di `normal`, `j`/`k` navigasi, `i` masuk `insert`, `Return` jalankan. Di `insert`, `Backspace` menghapus query.
- `TextInput { visible: mode === 'insert'; focus: mode === 'insert' }`: input hanya terlihat dan fokus di mode `insert`. `onTextChanged` menyinkronkan `query`.
- `ListView`: menampilkan hasil; `incrementCurrentIndex`/`decrementCurrentIndex` memindahkan selection.

**Opsi lain untuk tujuan yang sama:**

| Pola | Deskripsi | Catatan |
|---|---|---|
| Mode properti + `Keys.onPressed` | Seperti contoh di atas | Fleksibel; kontrol penuh. |
| Dua komponen terpisah | Satu untuk normal, satu untuk insert | Lebih banyak duplikasi; kurang reaktif. |
| `TextInput` selalu fokus | Tidak ada mode normal; `j`/`k` mengetik | Sederhana tetapi tidak bisa navigasi vim. |

### Visualisasi: Transisi Mode

```text
┌─────────────────────────────────────────────┐
│                  NORMAL                     │
│  j/k → navigasi                             │
│  i   → masuk INSERT                         │
│  Enter → jalankan                           │
│  Escape → tutup launcher                    │
└──────────────────┬──────────────────────────┘
                   │ i
                   ▼
┌─────────────────────────────────────────────┐
│                  INSERT                     │
│  ketik → query                              │
│  Backspace → hapus                          │
│  Escape → kembali NORMAL                    │
└─────────────────────────────────────────────┘
```

**Penjelasan:** `i` dari `normal` masuk ke `insert`; `Escape` dari `insert` kembali ke `normal`; `Escape` dari `normal` menutup launcher.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **Mode modal** | Pola di mana tombol yang sama berarti berbeda tergantung mode. |
| **`mode`** | Properti string yang menyimpan mode saat ini. |
| **Transisi mode** | Perubahan eksplisit dari satu mode ke mode lain. |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Launcher adalah tempat mode modal paling sering digunakan.
- **Modul 2.2:** Mode dapat diekspos melalui `IpcHandler` untuk diubah dari luar.

### Sumber Referensi

- Quickshell Book — Keys & Focus: https://programmersd21.github.io/the_quickshell_book/part-1-qml/keys-and-focus
- Contoh implementasi vim-like keybinds di Quickshell: https://g.freya.cat (pencarian “vim-like keybinds Quickshell”)

### Tips dan Praktik Terbaik

- **Tampilkan indikator mode** (misalnya teks “-- NORMAL --” di bawah) agar pengguna tahu mode saat ini.
- **Gunakan `TextInput` hanya di mode `insert`** dan sembunyikan di mode `normal`.
- **Pastikan `Escape` di `insert` tidak menutup launcher**; kembalikan ke `normal` terlebih dahulu.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `Escape` langsung menutup di `insert` | Pengguna tidak bisa kembali ke `normal` | Periksa mode sebelum menutup. |
| `TextInput` selalu fokus | `j`/`k` mengetik, bukan navigasi | Fokus hanya di `insert`. |
| Mode tidak di-bind ke UI | Pengguna bingung | Tampilkan indikator mode. |

---

## 6. Persistensi: `FileView`, `JsonAdapter`, dan `Quickshell.statePath`

### Deskripsi Konkret & Peran dalam Kurikulum

Persistensi adalah kemampuan menyimpan preferensi agar bertahan setelah restart. Quickshell menyediakan `FileView` untuk membaca/menulis file, `JsonAdapter` untuk memetakan JSON ke properti QML, dan `Quickshell.statePath()` untuk menentukan lokasi file state.

**Mengapa penting:** Tanpa persistensi, pengguna harus mengatur ulang tema, visibilitas bar, dan preferensi lain setiap kali login. Ini adalah pengalaman yang buruk dan tidak sesuai dengan shell yang matang.

### Konsep Kunci & Filosofi

**`FileView` adalah akses file yang reaktif.** Ia membaca file, memantau perubahan (`watchChanges`), dan menyediakan method `reload()` untuk memuat ulang. Ia juga dapat menulis melalui `setText()` atau melalui adapter.

**`JsonAdapter` adalah jembatan dua arah.** Setiap properti yang dideklarasikan di `JsonAdapter` dipetakan ke key di JSON. Ketika file dimuat, properti diperbarui. Ketika properti diubah dari QML, `FileView.adapterUpdated()` dipancarkan, yang dapat digunakan untuk menulis file.

**`Quickshell.statePath(path)` adalah lokasi state.** Dokumentasi menyatakan: “Can be overridden using `//@ pragma StateDir $BASE/path` in the root qml file, where `$BASE` corresponds to `$XDG_STATE_HOME` (usually `~/.local/state`).” Ini adalah tempat yang tepat untuk preferensi runtime, berbeda dari config pengguna.

**Tipe yang didukung `JsonAdapter`:** primitif (`int`, `bool`, `string`, `real`), `JsonObject`, `var` (JSON object/array), dan `list<T>`. Tipe QML lain seperti `color`, `url`, atau enum **tidak didukung langsung**; konversi ke string atau integer.

### Sintaks Dasar / Contoh Implementasi

```qml
import Quickshell
import Quickshell.Io

FileView {
    id: settingsFile
    path: Quickshell.statePath('settings.json')
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()

    adapter: JsonAdapter {
        property bool barVisible: true
        property string theme: 'dark'
        property int fontSize: 12
        property list<string> recentApps: []
    }
}
```

**Penjelasan kata-per-kata:**

- `path: Quickshell.statePath('settings.json')`: file state di `$XDG_STATE_HOME/quickshell/settings.json` (biasanya `~/.local/state/quickshell/settings.json`).
- `watchChanges: true`: memantau perubahan file di disk. Jika file diubah oleh editor eksternal, `onFileChanged` dipanggil.
- `onFileChanged: reload()`: memuat ulang file saat berubah.
- `onAdapterUpdated: writeAdapter()`: menulis file saat properti adapter berubah dari QML.
- `adapter: JsonAdapter { ... }`: mendeklarasikan properti yang dipetakan ke JSON.
- `property bool barVisible: true`: key `barVisible` dengan default `true`.
- `property string theme: 'dark'`: key `theme` dengan default `'dark'`.
- `property int fontSize: 12`: key `fontSize` dengan default `12`.
- `property list<string> recentApps: []`: key `recentApps` sebagai list string.

**Opsi lain untuk tujuan yang sama:**

| Kebutuhan | Pendekatan | Catatan |
|---|---|---|
| Preferensi sederhana | `FileView` + `JsonAdapter` | Direkomendasikan. |
| File teks mentah | `FileView` + `JSON.parse(text())` | Lebih manual; tidak reaktif per properti. |
| State sementara (runtime) | `Quickshell.statePath` + `FileView` | State tidak perlu selamat dari reboot. |
| Konfigurasi pengguna | `Quickshell.configPath` | Berbeda dari state; untuk config yang diedit pengguna. |

### Visualisasi: Alur Persistensi

```text
QML property berubah
        │
        ▼
JsonAdapter mendeteksi perubahan
        │
        ▼
FileView.adapterUpdated()
        │
        ▼
onAdapterUpdated: writeAdapter()
        │
        ▼
File ditulis ke disk (statePath)

File di disk berubah (editor eksternal)
        │
        ▼
FileView.fileChanged()
        │
        ▼
onFileChanged: reload()
        │
        ▼
JsonAdapter memperbarui properti QML
```

**Penjelasan:** Dua arah sinkronisasi: QML → disk (via `writeAdapter`) dan disk → QML (via `reload`). `watchChanges` memungkinkan hot-reload.

### Terminologi Esensial

| Istilah | Penjelasan |
|---|---|
| **`FileView`** | Pembaca/penulis file reaktif. |
| **`JsonAdapter`** | Adapter yang memetakan JSON ke properti QML. |
| **`statePath()`** | Fungsi untuk menentukan path di direktori state (`$XDG_STATE_HOME`). |
| **`watchChanges`** | Jika `true`, memantau perubahan file di disk. |
| **`writeAdapter()`** | Menulis state adapter ke file. |
| **`blockLoading`** | Jika `true`, membaca file memblokir hingga selesai dimuat. |

### Hubungan dengan Modul Lain

- **Modul 2.4:** Launcher dapat menyimpan `recentApps` atau query terakhir.
- **Modul 2.2:** State dapat diekspos melalui `IpcHandler` untuk diubah dari CLI.

### Sumber Referensi

- Quickshell — `FileView`: https://quickshell.org/docs/v0.3.1/types/Quickshell.Io/FileView/
- Quickshell — `JsonAdapter`: https://quickshell.org/docs/v0.3.1/types/Quickshell.Io/JsonAdapter/
- Quickshell — `Quickshell.statePath`: https://quickshell.org/docs/v0.3.1/types/Quickshell/Quickshell/

### Tips dan Praktik Terbaik

- **Gunakan `Quickshell.statePath()` untuk preferensi runtime**, bukan `configPath()`.
- **Biarkan `atomicWrites` default `true`** agar penulisan tidak merusak file jika gagal.
- **Gunakan `printErrors: true` (default) saat pengembangan** untuk melihat error baca/tulis.
- **Hindari `blockLoading: true` kecuali untuk file yang harus tersedia sebelum UI muncul.**
- **Deklarasikan tipe yang didukung `JsonAdapter`**; konversi tipe lain ke string/integer.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Menggunakan tipe `color` di `JsonAdapter` | Error atau nilai tidak tersimpan | Simpan sebagai string hex; konversi saat dibaca. |
| Lupa `onAdapterUpdated: writeAdapter()` | Perubahan tidak tersimpan | Tambahkan handler. |
| Menggunakan `configPath` untuk state | State bercampur dengan config pengguna | Gunakan `statePath`. |
| `blockLoading: true` pada file besar | UI freeze saat startup | Gunakan hanya untuk file kecil yang wajib. |

---

## 7. Keamanan Persistensi: Apa yang Boleh dan Tidak Boleh Disimpan

### Deskripsi Konkret & Peran dalam Kurikulum

Kurikulum menegaskan: “simpan preferensi saja, bukan rahasia.” Ini adalah prinsip keamanan yang perlu dijabarkan secara teknis.

**Mengapa penting:** `FileView` menulis **plaintext** ke disk. Tidak ada enkripsi. Siapa pun yang memiliki akses baca ke file (atau ke direktori state) dapat membaca isinya. Jika Anda menyimpan token API, password, atau kunci SSH, Anda menciptakan risiko keamanan.

### Konsep Kunci & Filosofi

**State adalah data non-sensitif.** Preferensi seperti tema, ukuran font, visibilitas bar, dan daftar aplikasi terakhir **tidak sensitif**. Menyimpannya di plaintext dapat diterima.

**Rahasia memerlukan mekanisme khusus.** Token, password, dan kunci harus disimpan di **keyring** (GNOME Keyring, KWallet, `pass`) atau file terenkripsi (GPG). Quickshell tidak menyediakan enkripsi bawaan untuk `FileView`.

**Environment bukan tempat menyimpan rahasia.** Shell yang mewariskan environment ke aplikasi yang diluncurkan (`execute()`, `execDetached`) dapat membocorkan variabel sensitif. Jangan menaruh rahasia di environment shell.

### Tips dan Praktik Terbaik

- **Simpan hanya preferensi non-sensitif di `FileView`/`JsonAdapter`.**
- **Gunakan keyring untuk rahasia.** Jika Anda memerlukan akses dari QML, gunakan `Process` untuk memanggil `secret-tool` atau `gpg`.
- **Jangan pernah menyimpan token di environment shell.**
- **Batasi izin file state** (misalnya `chmod 600`) jika berisi data pribadi non-rahasia.

---

## 8. Latihan dan Checkpoint

### Latihan (sesuai kurikulum)

**Tambahkan mode `normal`/`insert` ke launcher (`j`/`k` bergerak, `i` mengetik) dan simpan tema terakhir ke `settings.json`.**

**Langkah-langkah:**

1. Buat `PanelWindow` launcher dengan `mode: 'normal'` sebagai properti.
2. Tambahkan `Keys.onEscapePressed`: jika `insert`, kembali ke `normal`; jika `normal`, tutup launcher.
3. Tambahkan `Keys.onPressed`: di `normal`, `j`/`k` navigasi, `i` masuk `insert`; di `insert`, `Backspace` hapus query.
4. Tambahkan `TextInput` yang hanya fokus di mode `insert`.
5. Buat `FileView` dengan `path: Quickshell.statePath('settings.json')`, `watchChanges: true`, `onAdapterUpdated: writeAdapter()`.
6. Tambahkan `JsonAdapter` dengan `property string theme: 'dark'`.
7. Ikat tema ke UI (misalnya `color: theme === 'dark' ? '#1e1e2e' : '#ffffff'`).
8. Tambahkan tombol atau keybind untuk mengganti tema; perubahan harus tersimpan.
9. Restart Quickshell dan verifikasi tema tetap sama.
10. Uji hot-reload: ubah `settings.json` secara manual dan pastikan UI diperbarui (karena `watchChanges`).

**Checkpoint:** Jelaskan mengapa fokus eksklusif harus dilepas saat jendela tertutup.

**Jawaban singkat:** Fokus eksklusif (`WlrKeyboardFocus.Exclusive`) berarti permukaan menerima semua input keyboard dan jendela lain tidak bisa menerima input. Jika tidak dilepas saat launcher ditutup, ketikan pengguna akan terus masuk ke launcher yang tersembunyi, bukan ke jendela aktif. Ini membuat desktop tidak dapat digunakan. Melepas fokus ke `None` mengembalikan input ke compositor, yang kemudian mengarahkannya ke jendela yang fokus. Selain itu, `Exclusive` bukan mekanisme keamanan; untuk lockscreen, gunakan `WlSessionLock`.

---

## Motivasi

Fokus dan persistensi adalah dua pilar yang membuat shell Anda **dapat digunakan** dan **dapat diingat**. Fokus memastikan setiap ketikan sampai ke tempat yang benar; persistensi memastikan shell tidak melupakan preferensi Anda. Kuasai keduanya, dan shell Anda bukan lagi mainan—ia menjadi alat yang serius. Teruslah membangun; setiap mode yang berhasil dan setiap preferensi yang tersimpan adalah bukti bahwa Anda benar-benar mengendalikan lingkungan Anda.

---

## Selamat!

Materi **Modul 2.5** dan seluruh **Fase 2 — Integrasi Sistem: Wayland, Compositor, dan Layanan Desktop** telah selesai.

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../quickshell.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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

