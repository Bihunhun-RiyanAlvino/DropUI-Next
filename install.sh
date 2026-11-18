#!/bin/bash

echo "Memulai transformasi sistem ke DropUI Next (Arch Linux Base)..."

# A. Hapus wallpaper lama & skrip autostart Nyarch
rm -rf ~/.local/share/wallpapers/*
sudo rm -rf /etc/skel/.local/share/wallpapers/*
sudo rm -rf /usr/share/backgrounds/default.jpg /usr/share/backgrounds/*nyarch* /usr/share/backgrounds/*nyaight* /usr/share/backgrounds/*anime*
sudo rm -rf /usr/share/wallpapers/Nyarch* /usr/share/wallpapers/*nyaight* /usr/share/wallpapers/*anime*
sudo rm -f /etc/xdg/autostart/autostart.sh /etc/xdg/autostart/what.sh /etc/skel/.config/autostart/start.desktop

# B. Pasang wallpaper dan logo DropUI Next
mkdir -p ~/.local/share/wallpapers/
sudo mkdir -p /etc/skel/.local/share/wallpapers/
cp assets/DropUI-*.png ~/.local/share/wallpapers/
sudo cp assets/DropUI-*.png /etc/skel/.local/share/wallpapers/
sudo cp assets/droplogo.png /usr/share/pixmaps/dropui-next-logo.png

# C. Terapkan identitas OS (tetap berbasis Arch Linux)
sudo cp configs/os-release /etc/os-release
echo "DropUI Next \r (\l)" | sudo tee /etc/issue > /dev/null
sudo hostnamectl set-hostname dropui-next

# D. Sapu bersih sisa teks "Nyarch" di konfigurasi Fastfetch & tema (membiarkan Arch original)
sudo sed -i 's/Nyarch Linux/DropUI Next/g; s/Nyarch/DropUI Next/g; s/nyarch/dropui-next/g' /etc/skel/.config/fastfetch/config.jsonc /etc/skel/.config/kde-material-you-colors/config.conf 2>/dev/null
sed -i 's/Nyarch Linux/DropUI Next/g; s/Nyarch/DropUI Next/g; s/nyarch/dropui-next/g' ~/.config/kde-material-you-colors/config.conf ~/.config/fastfetch/config.jsonc 2>/dev/null

# E. Atur About System KDE Plasma 6
sudo kwriteconfig6 --file /etc/xdg/kcm-about-distrorc --group General --key LogoPath "/usr/share/pixmaps/dropui-next-logo.png"
sudo kwriteconfig6 --file /etc/xdg/kcm-about-distrorc --group General --key Name "DropUI Next"
sudo kwriteconfig6 --file /etc/xdg/kcm-about-distrorc --group General --key Variant "Arch Linux Base"

# F. Atur wallpaper default untuk user saat ini & user baru
kwriteconfig6 --file plasmarc --group Wallpapers --key usersWallpapers "$HOME/.local/share/wallpapers/DropUI-Next.png,$HOME/.local/share/wallpapers/DropUI-Default.png"
plasma-apply-wallpaperimage "$HOME/.local/share/wallpapers/DropUI-Next.png"

# G. Terapkan logo boot Plymouth (ukuran proporsional 96px)
if [ -d "/usr/share/plymouth/themes/bgrt" ]; then
    sudo cp assets/droplogo-boot.png /usr/share/plymouth/themes/bgrt/watermark.png
fi
if [ -d "/usr/share/plymouth/themes/spinner" ]; then
    sudo cp assets/droplogo-boot.png /usr/share/plymouth/themes/spinner/watermark.png
fi
sudo mkdir -p /etc/plymouth
sudo tee /etc/plymouth/plymouthd.conf > /dev/null << 'PLY'
[Daemon]
Theme=bgrt
ShowDelay=0
DeviceScale=1
PLY
sudo mkinitcpio -P

echo "Selesai! Sistem sepenuhnya telah menjadi DropUI Next (Arch Linux Base)."
