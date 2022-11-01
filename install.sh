#!/bin/bash
#
# Olhar: https://www.reddit.com/r/Fedora/comments/lobnfm/guide_fedora_gnome_minimal_install/
#
# Script feito por Rafael Tosta com o proposito de automatizar a minha instalação
# do Fedora, a partir de uma INSTALACAO MINIMA da ISO Everything:
#

#Sincronizando o repositório
# sudo dnf install git
# git clone http://github.com/rafatosta/fedora_gnome_everything

# Desativando repositórios Modular para updates mais rápidos
dnf config-manager --disable *-modular

# Adicionando repositórios RPM Fusion
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Third-Party Repositories
dnf install -y fedora-workstation-repositories

# ativar o repositório do google-chrome
dnf config-manager --set-enabled google-chrome

# Adw-gtk3
dnf copr enable nickavem/adw-gtk3

#Visual Studio Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Flatpak
dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
 
# Instalando o Xorg base (suporte para VGA intel, radeon e nouveau)
dnf install -y @base-x

#Drivers Intel extends
dnf -y install intel-media-driver libva libva-intel-driver libva-vdpau-driver libva-utils

# Instalando pacote básicos gnome
dnf install -y gdm gnome-shell gnome-console gnome-console-nautilus nautilus xdg-user-dirs-gtk \
 gnome-tweaks evince gnome-text-editor gnome-system-monitor gnome-clocks \
 gnome-calendar gnome-calculator gnome-disk-utility eog dialect transmission evolution

# Aplicativos Qt com o Adwaita
#dnf install adwaita-qt5 adwaita-qt6 

# Instalando programas pessoais
dnf install -y megasync google-chrome-stable code vlc

# Apps em flatpak
flatpak install -y com.rtosta.zapzap com.mattjakeman.ExtensionManager \
org.eclipse.Java com.github.tchx84.Flatseal org.telegram.desktop\
org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark 

# Ativando o gdm e definindo como padrão
systemctl enable gdm
systemctl set-default graphical.target

#Instala as extensões
dnf install -y gnome-shell-extension-user-theme

#copiando pasta de temas
cp -r themes ~/.local/share

#Desativa NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service
 
# Esconde o grub
grub2-editenv - set menu_auto_hide=1
grub2-mkconfig -o /etc/grub2-efi.cfg
# edite o timeout em /etc/default/grub
# execute: sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Reinicia a máquina
#reboot
