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

reflector --country United_Kingdom,Germany  --verbose --latest 10 -a 12 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware reflector
genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt

### after arch-chroot ###
ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime
hwclock --systohc
pacman -S vim htop
vim /etc/pacman.conf
vim /etc/locale.gen     # uncomment en_US.UTF-8 UTF-8
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "archLinux" >> /etc/hostname

echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   archLinux.localdomain  archLinux
" > /etc/hosts

passwd
useradd -m amidmajd
passwd amidmajd
usermod -aG wheel,audio,video,optical,storage amidmajd
pacman -S --needed base-devel sudo git
visudo

pacman -S grub efibootmgr dosfstools mtools os-prober linux-headers intel-ucode
pacman -S xf86-video-qxl
pacman -S linux-zen linux-zen-headers linux-headers

mkinitcpio -P

#MBR =>
grub-install --recheck --target=i386-pc --bootloader-id=GRUB  /dev/vda
#EFI =>
grub-install --recheck --target=x86_64-efi --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg


pacman -S networkmanager network-manager-applet networkmanager-openvpn wireless_tools wpa_supplicant dialog blueberry cups
pacman -S xorg
systemctl enable NetworkManager bluetooth cups

pacman -S cinnamon gnome-keyring gnome-terminal alacritty
pacman -S xmonad xmonad-contrib xmobar picom rofi alacritty
pacman -S gnome gdm gnome-extra
pacman -S plasma-meta sddm plasma-wayland-session kde-system-meta konsole kdeconnect dolphin-plugins kwalletmanager ark lrzip lzop p7zip unrar unarchiver kompare filelight kcalc gwenview kcolorchooser okular kdenlive elisa kdenetwork-filesharing print-manager


pacman -S lightdm lightdm-webkit2-greeter
paru lightdm-webkit-theme-aether
vim /etc/lightdm/lightdm.conf
# greeter-session=lightdm-webkit2-greeter
# for virtual machine : display-setup-script=xrandr --output Virtual-1 --mode 1366x768
systemctl enable lightdm gdm sddm


# fix picom for virtual machine :
## vim /etc/xdg/picom.conf  ==> comment "vsync" option

pacman -S openssh net-tools neofetch
vim /etc/ssh/sshd_config       # PermitRootLogin yes
systemctl enable sshd
dmesg -wH
pacman -Rsn $(pacman -Qdtq)

umount -a
reboot
