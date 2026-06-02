```bash
lsblk -f
NAME             FSTYPE      FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda
└─sda1           exfat       1.0   data      7281-0BBC                             769.2G    17% /srv/data
nvme0n1
├─nvme0n1p1      ntfs                        ECA2E689A2E6581A
├─nvme0n1p2      crypto_LUKS 1               d68f7470-bcc0-42b1-a992-472268831b1b
│ └─manjaro-root ext4        1.0   manjaroot bbb72ffe-6ba4-4e40-ae26-f78f1b6dbec6
├─nvme0n1p3      vfat        FAT32 EFIBOOT   BC93-16D6
├─nvme0n1p4      crypto_LUKS 1               1d5212de-280d-4ea9-9d72-9c6fc25a5427
├─nvme0n1p5      ext4        1.0             6a72ac8a-12e1-432d-a716-744e666643f4   79.4G    32% /
├─nvme0n1p6      swap        1               2783fd51-fead-43a5-87c7-a648f3627c91                [SWAP]
├─nvme0n1p7      vfat        FAT32           4886-2E94
├─nvme0n1p8      ext4        1.0             dd3c3ad4-daae-43c6-84ac-6119577cc1f1
└─nvme0n1p9      swap        1               528717ff-4078-4782-a168-6519170b0465                [SWAP]
```


| Partisi   | Fungsi                                  |
| --------- | --------------------------------------- |
| nvme0n1p1 | Windows 11                              |
| nvme0n1p2 | LUKS Manjaro (kemungkinan root Manjaro) |
| nvme0n1p3 | EFI System Partition                    |
| nvme0n1p4 | LUKS Swap Manjaro                       |
| nvme0n1p5 | Root Arch Linux (sedang aktif)          |
| nvme0n1p6 | Swap Arch Linux                         |
| nvme0n1p7 | EFI WinPE                               |
| nvme0n1p8 | Root Debian                             |
| nvme0n1p9 | Swap Debian                               |

Sebelum melakukan chroot ke Manjaro, pastikan dulu isi dari `p2`, karena saat ini hanya terlihat sebagai container LUKS.

Langkah 1 — Buka LUKS Manjaro

```bash
sudo cryptsetup luksOpen /dev/nvme0n1p2 manjaro-root
```

Kemudian cek:

```bash
lsblk -f
```

Biasanya akan muncul:

```text
mapper/manjaro-root ext4
```

atau

```text
mapper/manjaro-root btrfs
```

Jika muncul filesystem, lanjut.

Langkah 2 — Mount root Manjaro

Misalnya ext4:

```bash
sudo mount /dev/mapper/manjaro-root /mnt
```

Jika btrfs dan memakai subvolume:

```bash
sudo mount -o subvol=@ /dev/mapper/manjaro-root /mnt
```

Cek:

```bash
ls /mnt
```

Harus terlihat:

```text
bin
boot
etc
home
usr
var
```

Langkah 3 — Mount EFI yang digunakan Manjaro

Cari dulu:

```bash
cat /mnt/etc/fstab
```

Lihat UUID EFI yang dipakai.

Jika ternyata memakai `nvme0n1p3`:

```bash
sudo mount /dev/nvme0n1p3 /mnt/boot/efi
```

atau

```bash
sudo mount /dev/nvme0n1p3 /mnt/boot
```

sesuai isi `fstab`.

Langkah 4 — Bind mount

```bash
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo mount --bind /run /mnt/run
```

Untuk sistem UEFI:

```bash
sudo mount --bind /sys/firmware/efi/efivars \
    /mnt/sys/firmware/efi/efivars
```

Langkah 5 — Chroot

```bash
sudo chroot /mnt /bin/bash
```

atau bila tersedia:

```bash
sudo arch-chroot /mnt
```

Langkah 6 — Perbarui GRUB

Di dalam chroot:

```bash
grub-install
```

Jika UEFI:

```bash
grub-install --target=x86_64-efi \
             --efi-directory=/boot/efi \
             --bootloader-id=Manjaro
```

Lalu:

```bash
update-grub
```

atau:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

Sebelum menjalankan apa pun, saya sarankan tampilkan dulu hasil:

```bash
sudo cryptsetup luksOpen /dev/nvme0n1p2 manjaro-root
lsblk -f
```

karena dari output saat ini belum bisa dipastikan apakah `p2` benar-benar root Manjaro atau masih berisi LVM/Btrfs subvolume di dalam LUKS. Setelah melihat output tersebut, langkah mount yang tepat bisa ditentukan dengan pasti.


<!---->
<!-- ~ ❯ sudo cryptsetup luksOpen /dev/nvme0n1p2 manjaro-root -->
<!-- Enter passphrase for /dev/nvme0n1p2: -->
<!-- No key available with this passphrase. -->
<!-- Enter passphrase for /dev/nvme0n1p2: -->
<!-- ~ ❯ lsblk -f -->
<!-- NAME             FSTYPE      FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS -->
<!-- sda -->
<!-- └─sda1           exfat       1.0   data      7281-0BBC                             769.2G    17% /srv/data -->
<!-- nvme0n1 -->
<!-- ├─nvme0n1p1      ntfs                        ECA2E689A2E6581A -->
<!-- ├─nvme0n1p2      crypto_LUKS 1               d68f7470-bcc0-42b1-a992-472268831b1b -->
<!-- │ └─manjaro-root ext4        1.0   manjaroot bbb72ffe-6ba4-4e40-ae26-f78f1b6dbec6 -->
<!-- ├─nvme0n1p3      vfat        FAT32 EFIBOOT   BC93-16D6 -->
<!-- ├─nvme0n1p4      crypto_LUKS 1               1d5212de-280d-4ea9-9d72-9c6fc25a5427 -->
<!-- ├─nvme0n1p5      ext4        1.0             6a72ac8a-12e1-432d-a716-744e666643f4   79.4G    32% / -->
<!-- ├─nvme0n1p6      swap        1               2783fd51-fead-43a5-87c7-a648f3627c91                [SWAP] -->
<!-- ├─nvme0n1p7      vfat        FAT32           4886-2E94 -->
<!-- ├─nvme0n1p8      ext4        1.0             dd3c3ad4-daae-43c6-84ac-6119577cc1f1 -->
<!-- └─nvme0n1p9      swap        1               528717ff-4078-4782-a168-6519170b0465                [SWAP] -->
<!-- ~ ❯ sudo mount /dev/mapper/manjaro-root /mnt -->
<!-- ~ ❯ lsblk -f -->
<!-- NAME             FSTYPE      FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS -->
<!-- sda -->
<!-- └─sda1           exfat       1.0   data      7281-0BBC                             769.2G    17% /srv/data -->
<!-- nvme0n1 -->
<!-- ├─nvme0n1p1      ntfs                        ECA2E689A2E6581A -->
<!-- ├─nvme0n1p2      crypto_LUKS 1               d68f7470-bcc0-42b1-a992-472268831b1b -->
<!-- │ └─manjaro-root ext4        1.0   manjaroot bbb72ffe-6ba4-4e40-ae26-f78f1b6dbec6   96.2G    29% /mnt -->
<!-- ├─nvme0n1p3      vfat        FAT32 EFIBOOT   BC93-16D6                              1022M     0% /efi -->
<!-- ├─nvme0n1p4      crypto_LUKS 1               1d5212de-280d-4ea9-9d72-9c6fc25a5427 -->
<!-- ├─nvme0n1p5      ext4        1.0             6a72ac8a-12e1-432d-a716-744e666643f4   79.4G    32% / -->
<!-- ├─nvme0n1p6      swap        1               2783fd51-fead-43a5-87c7-a648f3627c91                [SWAP] -->
<!-- ├─nvme0n1p7      vfat        FAT32           4886-2E94 -->
<!-- ├─nvme0n1p8      ext4        1.0             dd3c3ad4-daae-43c6-84ac-6119577cc1f1 -->
<!-- └─nvme0n1p9      swap        1               528717ff-4078-4782-a168-6519170b0465                [SWAP] -->
<!-- ~ ❯ sudo arch-chroot /mnt -->
<!-- [archlinux /]# update-grub -->
<!-- Generating grub configuration file ... -->
<!-- Found linux image: /boot/vmlinuz-6.12-x86_64 -->
<!-- Found initrd image: /boot/intel-ucode.img /boot/amd-ucode.img /boot/initramfs-6.12-x86_64.img -->
<!-- Warning: os-prober will be executed to detect other bootable partitions. -->
<!-- Its output will be used to detect bootable binaries on them and create new boot entries. -->
<!-- Found Debian GNU/Linux 13 (trixie) on /dev/nvme0n1p8 -->
<!-- Adding boot menu entry for UEFI Firmware Settings ... -->
<!-- Root filesystem isn't btrfs -->
<!-- If you think an error has occurred, please file a bug report at "https://github.com/Antynea/grub-btrfs" -->
<!-- Found memtest86+ image: /boot/memtest86+/memtest.bin -->
<!-- Found memtest86+ EFI image: /boot/memtest86+/memtest.efi -->
<!-- done -->
<!-- [archlinux /]# grub-mkconfig -o /boot/grub/grub.cfg -->
<!-- Generating grub configuration file ... -->
<!-- Found linux image: /boot/vmlinuz-6.12-x86_64 -->
<!-- Found initrd image: /boot/intel-ucode.img /boot/amd-ucode.img /boot/initramfs-6.12-x86_64.img -->
<!-- Warning: os-prober will be executed to detect other bootable partitions. -->
<!-- Its output will be used to detect bootable binaries on them and create new boot entries. -->
<!-- Found Debian GNU/Linux 13 (trixie) on /dev/nvme0n1p8 -->
<!-- Adding boot menu entry for UEFI Firmware Settings ... -->
<!-- Root filesystem isn't btrfs -->
<!-- If you think an error has occurred, please file a bug report at "https://github.com/Antynea/grub-btrfs" -->
<!-- Found memtest86+ image: /boot/memtest86+/memtest.bin -->
<!-- Found memtest86+ EFI image: /boot/memtest86+/memtest.efi -->
<!-- done -->
<!-- [archlinux /]# -->
