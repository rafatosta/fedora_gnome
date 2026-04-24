#!/usr/bin/env bash

set -e

SCRIPT_PATH="/usr/local/bin/fix-touchpad-acpi.sh"
SERVICE_PATH="/etc/systemd/system/fix-touchpad-acpi.service"

echo "🔧 Instalando script de correção do touchpad..."

sudo bash -c "cat > $SCRIPT_PATH" << 'EOF'
#!/usr/bin/env bash

LOG="/var/log/fix-touchpad.log"

echo "==== $(date) ====" >> $LOG

if libinput list-devices | grep -qi touchpad; then
echo "Touchpad OK" >> $LOG
exit 0
fi

echo "Touchpad NÃO detectado - tentando bind ACPI..." >> $LOG

modprobe i2c_hid_acpi

for dev in /sys/bus/acpi/devices/PNP0C50:*; do
name=$(basename $dev)
echo "Tentando bind $name" >> $LOG
echo $name > /sys/bus/acpi/drivers/i2c_hid_acpi/bind 2>>$LOG
done

sleep 2

modprobe -r hid_multitouch 2>/dev/null
modprobe -r i2c_hid_acpi 2>/dev/null
modprobe -r i2c_hid 2>/dev/null

sleep 1

modprobe i2c_hid
modprobe i2c_hid_acpi
modprobe hid_multitouch

sleep 2

if libinput list-devices | grep -qi touchpad; then
echo "SUCESSO" >> $LOG
else
echo "FALHA" >> $LOG
fi
EOF

sudo chmod +x $SCRIPT_PATH

echo "⚙️ Criando serviço systemd..."

sudo bash -c "cat > $SERVICE_PATH" << 'EOF'
[Unit]
Description=Fix Touchpad via ACPI
After=graphical.target

[Service]
Type=oneshot
ExecStart=/usr/bin/sleep 6
ExecStart=/usr/local/bin/fix-touchpad-acpi.sh

[Install]
WantedBy=graphical.target
EOF

echo "🔄 Recarregando systemd..."
sudo systemctl daemon-reload

echo "✅ Ativando serviço..."
sudo systemctl enable fix-touchpad-acpi.service

echo "🚀 Executando teste..."
sudo systemctl start fix-touchpad-acpi.service

echo "📊 Status:"
systemctl status fix-touchpad-acpi.service --no-pager

echo ""
echo "✔️ Fix instalado com sucesso!"
echo "➡️ Reinicie para validar: sudo reboot"
