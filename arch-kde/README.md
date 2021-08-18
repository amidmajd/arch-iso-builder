# Arch KDE

## Guide
- Install `SSDM` on the main system.
- Run these commands:

```sh
mkdir -p airootfs/etc/systemd/system/multi-user.target.wants

ln -sf /usr/lib/systemd/system/NetworkManager-wait-online.service airootfs/etc/systemd/system/network-online.target.wants

ln -sf /usr/lib/systemd/system/NetworkManager.service airootfs/etc/systemd/system/multi-user.target.wants/

ln -sf /usr/lib/systemd/system/sddm.service airootfs/etc/systemd/system/display-manager.service
```
