#!/bin/bash

#Sincronizando o repositório
# sudo dnf install git
# git clone https://github.com/rafatosta/fedora_gnome


# Ambiente 
dnf install -y gnome-shell nautilus ptyxis gnome-software @networkmanager-submodules flatpak \
    evince gnome-text-editor gnome-system-monitor gnome-clocks gnome-calculator gnome-disk-utility unzip



# Third-Party Repositories
dnf install -y fedora-workstation-repositories

# ativar o repositório do google-chrome
dnf config-manager setopt google-chrome.enabled=1
dnf config-manager setopt rpmfusion-nonfree-nvidia-driver.enabled=1
dnf config-manager setopt phracek-PyCharm.enabled=0
dnf config-manager setopt rpmfusion-nonfree-steam.enabled=0

# Visual Studio Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Configurar o flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# Pacote e apps 
dnf install -y nodejs adw-gtk3-theme google-chrome-stable code


## Apps em flatpak
flatpak install -y com.mattjakeman.ExtensionManager \
     com.github.tchx84.Flatseal \
     org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3' && gsettings set org.gnome.desktop.interface color-scheme 'default'

# Desativa NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service

# Ativando o gdm e definindo como padrão
systemctl set-default graphical.target