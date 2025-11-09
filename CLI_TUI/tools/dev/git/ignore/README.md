# .gitignore

### Tambahan Perintah di `.gitignore`

### Mengabaikan File dengan Underscore di Awal

```PS
# Mengabaikan file yang diawali dengan underscore
_*
```

### Pengaturan Dasar

- Mengabaikan seluruh direktori:

```PS
/dir_name/
```

- Mengabaikan semua file dengan ekstensi tertentu:

```PS
*.log
```

- Mengabaikan file tertentu di sembarang lokasi:

```PS
filename.txt
```

- Mengabaikan file dalam sub-direktori tertentu:

```PS
dir_name/*.temp
```

### Contoh Umum dari Berbagai Proyek

- **Node.js Projects**:

```PS
# Mengabaikan node_modules
node_modules/
```

- **Python Projects**:

```PS
# Mengabaikan cache dan bytecode
__pycache__/
*.pyc
*.pyo
*.pyd
```

- **Java Projects (Maven/Gradle)**:

```PS
# Mengabaikan target dan build directory
target/
build/
```

- **iOS Projects**:

```PS
# Mengabaikan workspace file
*.xcworkspace
```

- **Android Projects**:

```PS
# Mengabaikan IntelliJ IDE files, Gradle artifacts dan build directory
*.iml
.gradle/
build/
```

### Penggunaan Lanjutan

- Mengabaikan file yang spesifik, tapi melacak direktori:

```PS
dir_name/*
!dir_name/tracked_file.txt
```

- Menambahkan komentar:

```PS
# Ignore all HTML files
*.html
```

- Mengabaikan semua file kecuali beberapa file tertentu:

```PS
*.log
!important.log
```

- Spesifik hanya di direktori root:

```PS
/.config
```

- Mengabaikan folder tertentu (lanjutan):

```PS
# Mengabaikan folder debug dan temp di root
/debug/
/temp/
```

- Mengabaikan semua file yang bernama tertentu di direktori mana pun:

```PS
# Mengabaikan file config.json di sembarang lokasi
config.json
```

- Mengabaikan file dengan pola di sub-direktori tertentu:

```PS
# Mengabaikan semua log files dalam direktori logs dan semua tmp files dalam direktori tmp
logs/*.log
tmp/**/*.tmp
```

- Mengabaikan output build:

```PS
# Mengabaikan output build
bin/
obj/
target/
build/
```

- Mengabaikan hasil sementara dari text editor tertentu:

```PS
*.swp
.idea/
.vscode/
```

- Mengabaikan file berdasarkan ekstensi mereka:

```PS
*.dll
*.exe
*.bak
*.swp
```

- Mengabaikan file tertentu tetapi melacak direktori:

```PS
/logs/*
!/logs/app.log
```

- Menggunakan wildcard:

```PS
# Mengabaikan file sementara
*~
*.tmp
```
