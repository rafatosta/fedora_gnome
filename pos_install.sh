#!/bin/bash
#
# Script feito por Rafael Tosta com o proposito de automatizar a pós instalação do Fedora WS
#

## Repositórios

# Visual Studio Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

## Removendo apps não utilizados
#dnf remove -y 

dnf autoremove

## Instalando programas pessoais
dnf install -y google-chrome-stable code nodejs

## Instala as extensões
dnf install -y gnome-shell-extension-user-theme gnome-shell-extension-appindicator

## Apps em flatpak
#flatpak install -y 

## Desativa NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service
