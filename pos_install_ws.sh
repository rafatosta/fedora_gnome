#!/bin/bash
#
# Script feito por Rafael Tosta com o proposito de automatizar a pós instalação do Fedora WS
#

## Repositórios

# Desativando repositórios não utilizados
dnf config-manager --disable *-steam *-nvidia-driver *-PyCharm *-openh264
 
# Zapzap
dnf copr enable rafatosta/zapzap

# Visual Studio Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

## Removendo apps não utilizados
dnf remove -y gnome-photos gnome-contacts gnome-tour gnome-boxes gnome-maps gnome-logs gnome-weather podman firefox abrt rhythmbox totem simple-scan mediawriter

dnf autoremove

## Instalando programas pessoais
dnf install -y google-chrome-stable code nodejs adw-gtk3-theme dialect zapzap 

## Instala as extensões
dnf install -y gnome-shell-extension-user-theme gnome-shell-extension-appindicator

## Apps em flatpak
flatpak install -y com.mattjakeman.ExtensionManager \
org.eclipse.Java com.github.tchx84.Flatseal org.telegram.desktop io.github.shiftey.Desktop \
org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark 

## Desativa NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service
