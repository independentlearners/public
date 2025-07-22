# **Instalasi Flutter Di ArchLinux**

Instal paket manager AUR
```bash
cd ~
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
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
Konfirmasi lisensi android
```bash
# Setujui semuanya
flutter doctor --android-licenses
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














