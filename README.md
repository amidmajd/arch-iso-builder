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
sudo mkarchiso -v /path/to/profile/
# remove work folder (contains build temp files)
rm -rf work
```
