# Arch iso Builder

My `Arch linux + GUI` live iso builder

[Archiso wiki](https://wiki.archlinux.org/title/Archiso)

```
username : root
password : root

username : arch
password : arch
```

build iso using:

```bash
ln -f arch_install_helper.sh /path/to/profile/airootfs/etc/skel/

sudo mkarchiso -v /path/to/profile/
sudo chown -R USER:USER out/

# remove work folder (contains build temp files)
rm -rf work
```
