#!/bin/bash
#
# Instalação de Flatpaks essenciais
# Autor: Rafael Tosta
#

set -euo pipefail

# Lista de apps em um array para ficar mais limpo e fácil de manter
APPS=(
    app.drey.Dialect
    com.belmoussaoui.Obfuscate
    com.boxy_svg.BoxySVG
    com.github.tchx84.Flatseal
    com.jetbrains.IntelliJ-IDEA-Community
    com.mattjakeman.ExtensionManager
    com.rtosta.zapzap
    com.spotify.Client
    io.github.giantpinkrobots.varia
    io.github.pol_rivero.github-desktop-plus
    net.nokyan.Resources
    org.gaphor.Gaphor
    org.onlyoffice.desktopeditors
    org.videolan.VLC
    org.virt_manager.virt-manager
    page.tesk.Refine
    io.qt.Designer
    org.flatpak.Builder
    org.libreoffice.LibreOffice
)

# Garante que o repositório Flathub esteja configurado
if ! flatpak remote-list | grep -q flathub; then
    echo "Adicionando repositório Flathub..."
    flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo
fi

# Instalação em lote
for APP in "${APPS[@]}"; do
    echo "Instalando $APP..."
    flatpak install --system -y "$APP" || echo "Falha ao instalar $APP. Pulando..."
done

echo "Atualizando Flatpaks..."
flatpak update -y || true

echo "✅ Flatpaks instalados com sucesso!"
