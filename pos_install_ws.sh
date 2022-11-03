#!/bin/bash
#
# Script feito por Rafael Tosta com o proposito de automatizar a pós instalação do Fedora WS
#

## Repositórios

# Desativando repositórios não utilizados
dnf config-manager --disable *-modular *-steam *-nvidia-driver *-PyCharm
 
# RPM Fusion
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Tema Adw-gtk3
dnf -y copr enable nickavem/adw-gtk3

# Visual Studio Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Drivers Intel extends
dnf -y install intel-media-driver libva libva-intel-driver libva-vdpau-driver libva-utils

## Removendo apps não utilizados
dnf remove -y gnome-photos gnome-contacts gnome-tour gnome-boxes gnome-maps gnome-logs gnome-weather podman firefox abrt rhythmbox totem simple-scan mediawriter

dnf autoremove

## Instalando programas pessoais
dnf install -y megasync google-chrome-stable code vlc nodejs adw-gtk3 dialect evolution 

## Instala as extensões
dnf install -y gnome-shell-extension-user-theme

## Apps em flatpak
flatpak install -y com.rtosta.zapzap com.mattjakeman.ExtensionManager \
org.eclipse.Java com.github.tchx84.Flatseal org.telegram.desktop io.github.shiftey.Desktop \
org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark 

## Desativa NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service
