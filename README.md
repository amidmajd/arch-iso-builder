# Arch iso Builder

My **Arch linux with GUI** live ISO builder

[Archiso wiki](https://wiki.archlinux.org/title/Archiso)

## Credentials

```
username : root
password : root

username : arch
password : arch
```

## Building the ISO

```bash
cp -f /etc/pacman.conf path_to_profile/airootfs/etc/pacman.conf
ln -f arch_install_helper.sh path_to_profile/airootfs/etc/skel/

sudo mkarchiso -v path_to_profile/
sudo chown -R $USER:$USER out/

# remove work folder (contains build temp files)
sudo rm -rf work
```
