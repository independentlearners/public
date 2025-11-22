# **Instalasi Flutter Di ArchLinux**

Instal paket manager AUR
```bash
cd ~
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

Instal semua yang dibutuhkan
```bash
yay -Syyuu --needed --noconfirm flutter-bin android-sdk android-sdk-build-tools android-sdk-cmdline-tools-latest android-platform android-sdk-platform-tools adb mesa-utils
```
Jalankan
```bash
sudo cp -R /opt/android-sdk ~
sudo chown -R yourusername:yourgroupname android-sdk
```
Komponen Java
```bash
# Perhatikan versi berapakah java yang terinstal
ls -a1 /usr/lib/jvm

# Contoh disini saya menginstal verisi berikut:
# /usr/lib/jvm/java-24-openjdk
# Maka jalankan berikut:
flutter config --jdk-dir="/usr/lib/jvm/java-24-openjdk
```
Dalam kasus ini kita memisahkan semua environment flutter dari ~/.zshrc ke dalam file yang berbeda, seperti contoh disini saya membuat file baru:
`touch ~/.program` dan kemudian saya isi seperti ini
```bash
#!

# Untuk android sdk
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Untuk java
export JAVA_HOME=/usr/lib/jvm/java-24-openjdk 

# Untuk brave jika tidak menggunakan chrome
export CHROME_EXECUTABLE=/usr/bin/brave
```
Selanjutnya pastekan `source ~/.program` ke dalam `~/.zshrc`

**Konfirmasi lisensi android dan cek kesehatan serta buat proyek baru untuk mengujicoba**
```bash
# Setujui semuanya
flutter doctor --android-licenses

# Cek kesehatan
flutter doctor -v

# Buat ujicoba
flutter create proyek
cd proyek
flutter run
```














