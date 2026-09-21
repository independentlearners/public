# jq

**Jenis:** JSON processor CLI  
**Implementasi utama:** C  
**Peran:** filter, transformasi, dan generasi JSON dalam pipeline terminal.

## Contoh
```bash
echo '{"name":"dart","version":3}' | jq '.name'
jq '.items[]' data.json
```

## Modifikasi
Siapkan Git, C compiler/toolchain, build system proyek, pemahaman JSON, parser, struktur data, dan Unix pipeline.

## Sumber
https://github.com/jqlang/jq