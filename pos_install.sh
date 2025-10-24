#!/bin/bash
#
# Pós-instalação do Fedora Workstation
# Autor: Rafael Tosta
#

set -euo pipefail

echo "### ------ ATUALIZANDO SISTEMA ------ ###"
dnf upgrade -y

echo "### ------ ADICIONANDO REPOSITÓRIOS ------ ###"

# Repositório do Visual Studio Code
if ! [ -f /etc/yum.repos.d/vscode.repo ]; then
    echo "Adicionando repositório do VS Code..."
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    cat <<EOF > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
else
    echo "Repositório do VS Code já presente. Pulando..."
fi

echo "### ------ REMOVENDO APLICATIVOS NÃO UTILIZADOS ------ ###"

# Remoção mais segura: ignora caso pacote não exista
dnf remove -y \
    gnome-tour gnome-boxes gnome-maps gnome-weather showtime decibels \
    firefox abrt simple-scan mediawriter || true

dnf autoremove -y

echo "### ------ INSTALANDO PROGRAMAS PESSOAIS ------ ###"
dnf install -y \
    google-chrome-stable \
    code \
    nodejs \

echo "### ------ INSTALANDO EXTENSÕES GNOME ------ ###"
dnf install -y \
    gnome-shell-extension-user-theme \
    gnome-shell-extension-appindicator \


echo "### ------ INSTALANDO FLATPAKS ------ ###"
if [ -f ./install_flatpaks.sh ]; then
    chmod +x ./install_flatpaks.sh
    ./install_flatpaks.sh
else
    echo "Script install_flatpaks.sh não encontrado. Pulando instalação de Flatpaks."
fi

echo "### ------ AJUSTANDO SERVIÇOS ------ ###"
systemctl disable NetworkManager-wait-online.service || true

echo "### ------ LIMPEZA E FINALIZAÇÃO ------ ###"
dnf autoremove -y
flatpak update -y

echo "✅ Pós-instalação concluída com sucesso!"
