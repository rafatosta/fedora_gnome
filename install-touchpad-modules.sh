#!/usr/bin/env bash

set -e

CONF_PATH="/etc/modules-load.d/touchpad.conf"

echo "🔧 Criando configuração de carregamento automático..."

sudo bash -c "cat > $CONF_PATH" << 'EOF'
i2c_hid
i2c_hid_acpi
hid_multitouch
EOF

echo "📄 Conteúdo criado:"
cat $CONF_PATH

echo ""
echo "✔️ Configuração aplicada!"
echo "➡️ Reinicie para testar: sudo reboot"
