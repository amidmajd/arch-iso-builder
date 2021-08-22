# Grow arch root partition size on the fly
mount -o remount,size=2G /run/archiso/cowspace

timedatectl set-ntp true

fdisk -l    # sda1 : efi, sda2 : swap, sda3 : root, sda4 : home
mkfs.fat -F32 /dev/vda1
mkfs.ext4 /dev/vda3
mkswap /dev/vda2
swapon /dev/vda2

mount -o noatime /dev/vda3 /mnt
mkdir -p /mnt/boot/efi
mkdir /mnt/home
mount /dev/vda1 /mnt/boot/efi
mount -o noatime /dev/vda4 /mnt/home

reflector --country United_Kingdom,Germany  --verbose --latest 30 -a 12 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy
pacstrap /mnt base linux-zen linux-zen-headers linux-firmware reflector vim htop
cp -f /etc/pacman.conf /mnt/etc/pacman.conf
cp -f /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt

### after arch-chroot ###
ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen     # setting locale
sed -i 's/#fa_IR/fa_IR/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "ArchLinux" >> /etc/hostname

echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   ArchLinux.localdomain  ArchLinux
" > /etc/hosts

passwd
useradd -m amidmajd
passwd amidmajd
usermod -aG wheel,audio,video,optical,storage amidmajd
pacman -S --needed base-devel sudo git
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers    # activating wheel group (uncommenting %wheel ALL=(ALL) ALL)

pacman -S grub efibootmgr dosfstools mtools os-prober intel-ucode
pacman -S xf86-video-qxl

mkinitcpio -P

#MBR =>
grub-install --recheck --target=i386-pc --bootloader-id=Arch  /dev/vda
#EFI =>
grub-install --recheck --target=x86_64-efi --bootloader-id=Arch

grub-mkconfig -o /boot/grub/grub.cfg


pacman -S networkmanager networkmanager-openvpn wireless_tools wpa_supplicant dialog blueberry cups
pacman -S xorg
pacman -S alacritty firefox net-tools neofetch openssh
systemctl enable NetworkManager bluetooth cups fstrim.timer

# Desktops
pacman -S cinnamon gnome-keyring xdg-user-dirs
pacman -S gnome gdm gnome-extra
pacman -S plasma-desktop sddm sddm-kcm kwayland-integration plasma-wayland-session konsole dolphin dolphin-plugins kdeconnect kcron ksystemlog plasma-disks plasma-systemmonitor kwalletmanager kwallet-pam gnome-keyring seahorse gparted gnome-disk-utility ark lrzip lzop p7zip unrar unarchiver filelight kcalc gwenview okular kdenlive kdenetwork-filesharing print-manager bluedevil breeze-gtk drkonqi kde-gtk-config kdeplasma-addons kgamma5 khotkeys kinfocenter kscreen ksshaskpass kwrited plasma-browser-integration plasma-firewall plasma-nm plasma-pa plasma-thunderbolt plasma-workspace-wallpapers powerdevil xdg-desktop-portal-kde

# Login Managers
pacman -S lightdm lightdm-gtk-greeter
vim /etc/lightdm/lightdm.conf
# greeter-session=lightdm-gtk-greeter
# for virtual machine : display-setup-script=xrandr --output Virtual-1 --mode (1360x768 | 1366x768)
systemctl enable lightdm | gdm | sddm


# VMs
# fix picom for VMs: vim /etc/xdg/picom.conf  ==> comment "vsync" option
vim /etc/ssh/sshd_config       # PermitRootLogin yes
systemctl enable sshd

# Cleanup
pacman -Rsn $(pacman -Qdtq)

# EXIT CHROOT
umount -a
reboot
