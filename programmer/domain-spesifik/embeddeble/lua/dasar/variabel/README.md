# **1. Konsep Dasar Variabel di Lua**

Variabel adalah tempat penyimpanan data yang memiliki nama dan nilai. Di Lua, variabel bersifat **dinamis** (tipe data ditentukan otomatis) dan **case-sensitive** (huruf besar/kecil berpengaruh).

# **2. Jenis Variabel**

- **Global**: Bisa diakses dari mana saja (default)
- **Local**: Hanya bisa diakses dalam scope/blok tertentu
- **Table fields**: Variabel dalam struktur tabel

```lua
-- Contoh global variable
nama = "Budi" -- Global
print(nama) --> Budi

-- Contoh local variable
local umur = 12 -- Local
print(umur) --> 12

-- Contoh table field
murid = { nama = "Ani", kelas = 5 }
print(murid.nama) --> Ani
```

# **3. Tipe Data yang Dapat Disimpan**

Variabel di Lua bisa menyimpan berbagai tipe data:

```lua
a = 15          -- Number
b = 3.14        -- Float
c = "Hello"     -- String
d = true         -- Boolean
e = nil          -- Nil (kosong)
f = {1,2,3}     -- Table
g = function() end -- Function
```

# **4. Aturan Penamaan Variabel**

- Boleh mengandung huruf, angka, dan underscore
- Tidak boleh diawali angka
- Contoh valid: `nilai1`, `sensorA`, `_temp`
- Contoh invalid: `2nilai`, `nilai-tinggi`

# **5. Deklarasi dan Assignment**

```lua
-- Assignment sederhana
panjang = 10
lebar = 5
luas = panjang * lebar
print(luas) --> 50

-- Multiple assignment
x, y = 5, 10
x, y = y, x -- Swap nilai
print(x, y) --> 10 5

-- Dynamic typing
nilai = 100
print(type(nilai)) --> number
nilai = "seratus" -- Ganti tipe data
print(type(nilai)) --> string
```

# **6. Scope dan Blok Kode**

```lua
-- Variabel global
counter = 0

function tambah()
    counter = counter + 1 -- Akses global
    local temp = 5 -- Local function
    print(temp)
end

tambah()
print(counter) --> 1
print(temp) --> nil (error karena local)
```

# **7. Best Practices untuk Pemula**

1. Selalu gunakan `local` kecuali benar-benar perlu global
2. Gunakan nama deskriptif: `sensorSuhu` lebih baik dari `s1`
3. Inisialisasi variabel sebelum digunakan
4. Kelola scope dengan baik untuk menghindari konflik

# **8. Contoh Embedded System**

Dalam sistem embedded (seperti ESP32/Arduino dengan Lua), variabel sering digunakan untuk:

**Contoh GPIO Control:**

```lua
local pinLED = 4 -- Deklarasi pin
local statusLED = false

function toggleLED()
    statusLED = not statusLED
    gpio.write(pinLED, statusLED and 1 or 0)
end

-- Blink LED dengan timer
tmr.alarm(0, 1000, tmr.ALARM_AUTO, toggleLED)
```

**Contoh Sensor Reading:**

```lua
local pinSensor = 5
local threshold = 30.5
local sensorValue = 0

function bacaSensor()
    sensorValue = adc.read(pinSensor)
    if sensorValue > threshold then
        print("Peringatan! Nilai melebihi batas")
    end
end
```

# **9. Pola Penggunaan dalam Embedded**

1. **Konfigurasi Perangkat**:
   ```lua
   local config = {
       ssid = "WifiSaya",
       password = "12345678",
       timeout = 30
   }
   ```
2. **State Machine**:

   ```lua
   local state = "IDLE"

   function updateState(newState)
       local prev = state
       state = newState
       print("State changed from "..prev.." to "..state)
   end
   ```

3. **Data Logging**:

   ```lua
   local logData = {}

   function addLog(timestamp, value)
       table.insert(logData, {time = timestamp, val = value})
   end
   ```

# **10. Latihan Pemahaman**

1. Buat variabel untuk menyimpan:

   - Suhu ruangan
   - Status alarm (on/off)
   - Daftar nama sensor

2. Implementasikan fungsi untuk menghitung rata-rata dari 3 nilai sensor:

   ```lua
   local sensor1 = 25.4
   local sensor2 = 26.1
   local sensor3 = 24.9

   function rataRata()
       return (sensor1 + sensor2 + sensor3)/3
   end
   ```

3. Buat sistem kontrol LED dengan variabel:
   - Blink interval
   - Jumlah blink maksimal
   - Counter untuk jumlah blink saat ini

# **Tips untuk Belajar Lebih Lanjut**

1. Eksperimen dengan mengubah nilai variabel dalam berbagai scope
2. Coba kombinasi variabel dengan struktur kontrol (if, for, while)
3. Implementasikan variabel tabel untuk data kompleks
4. Pelajari garbage collection untuk manajemen memori di embedded
5. Praktekkan dengan simulator embedded seperti TINAH atau ESP32 emulator

Pemahaman variabel yang baik akan menjadi fondasi untuk mempelajari konsep Lua lanjutan seperti fungsi, tabel, dan OOP sederhana. Dalam embedded system, pengelolaan variabel yang efisien sangat penting karena keterbatasan resource.

### Variabel Muti

```lua
local i = {}

do
	local a = "teks"
	table.insert(i, a)
end

local a = 10
do
	table.insert(i, a)
end

do
	local a = false
	table.insert(i, a)
end

do
	local a = 5.5
	table.insert(i, a)
end

for x, v in ipairs(i) do
	print(x, v)
end
```

### Kode saya:

```lua

a = 10
b = 20
c = a + b

print('nilai: a',a)
print('nilai: b',b)
print('nilai: c',c)

local a = "lua"
print(a)

a = 40
print(a)

if true then
	local indside = "hidden"
end
print(inside)

if true then
	local ins = true
	print(ins)
end
```

> - **[Ke Atas](#)**
> - **[Kurikulum][1]**

[1]: ../../README.md
