#!/usr/bin/env bash

set -e

SERVICE_NAME="fix-touchpad.service"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}"

echo "🔧 Criando serviço systemd para corrigir o touchpad..."

sudo bash -c "cat > ${SERVICE_PATH}" << 'EOF'
[Unit]
Description=Fix Touchpad (Reload i2c_hid_acpi)
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/sleep 2
ExecStart=/usr/sbin/modprobe -r i2c_hid_acpi
ExecStart=/usr/sbin/modprobe i2c_hid_acpi
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Recarregando systemd..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "✅ Ativando serviço..."
sudo systemctl enable ${SERVICE_NAME}

echo "🚀 Iniciando serviço para teste..."
sudo systemctl start ${SERVICE_NAME}

echo "📊 Status do serviço:"
systemctl status ${SERVICE_NAME} --no-pager

echo ""
echo "🎯 Concluído!"
echo "➡️ Reinicie o sistema para validar completamente: sudo reboot"
