#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="/usr/local/bin/fix-touchpad-udev.sh"
RULE_PATH="/etc/udev/rules.d/99-touchpad-elan.rules"
LOG_FILE="/var/log/fix-touchpad.log"

usage() {
echo "Uso: $0 [install|remove|status]"
exit 1
}

require_root() {
if [[ $EUID -ne 0 ]]; then
echo "Execute como root (use sudo)."
exit 1
fi
}

install_all() {
echo "🔧 Instalando script e regra udev (ELAN)..."

# 1) Script

echo "→ Criando ${SCRIPT_PATH}"
install -m 0755 /dev/stdin "${SCRIPT_PATH}" << 'EOF'
#!/usr/bin/env bash

LOG="/var/log/fix-touchpad.log"

echo "==== $(date) [udev-elan] ====" >> "$LOG"

# Checagem leve no kernel (evita libinput)

if grep -qi elan /proc/bus/input/devices 2>/dev/null; then
echo "Touchpad já ativo (kernel detectado)" >> "$LOG"
exit 0
fi

echo "Touchpad ELAN não detectado, corrigindo..." >> "$LOG"

# Garante módulos

/sbin/modprobe i2c_hid_acpi || true
/sbin/modprobe i2c_hid || true
/sbin/modprobe hid_multitouch || true

# Pequeno atraso para estabilização do I2C

sleep 1

# Tenta bind nos dispositivos ACPI PNP0C50 (HID over I2C)

if [[ -d /sys/bus/acpi/drivers/i2c_hid_acpi ]]; then
for dev in /sys/bus/acpi/devices/PNP0C50:*; do
name="$(basename "$dev")"
echo "Bind $name" >> "$LOG"
echo "$name" > /sys/bus/acpi/drivers/i2c_hid_acpi/bind 2>>"$LOG" || true
done
else
echo "Driver i2c_hid_acpi não exposto em /sys (ok em alguns boots)" >> "$LOG"
fi

sleep 1

# Verificação final

if grep -qi elan /proc/bus/input/devices 2>/dev/null; then
echo "SUCESSO (ELAN ativo)" >> "$LOG"
else
echo "FALHA (ELAN não apareceu)" >> "$LOG"
fi
EOF

# 2) Regra udev (específica para PNP0C50)

echo "→ Criando ${RULE_PATH}"
install -m 0644 /dev/stdin "${RULE_PATH}" << 'EOF'

# Fix Touchpad ELAN via ACPI (HID over I2C)

ACTION=="add", SUBSYSTEM=="acpi", KERNEL=="PNP0C50:*", RUN+="/usr/local/bin/fix-touchpad-udev.sh"
EOF

# 3) Log (garante existência)

touch "${LOG_FILE}"
chmod 0644 "${LOG_FILE}"

# 4) Recarregar udev

echo "→ Recarregando udev"
udevadm control --reload
udevadm trigger

echo "✔️ Instalação concluída."
echo "➡️ Reinicie para validar: reboot"
}

remove_all() {
echo "🧹 Removendo regra e script..."

if [[ -f "${RULE_PATH}" ]]; then
rm -f "${RULE_PATH}"
echo "→ Removido ${RULE_PATH}"
else
echo "→ Regra não encontrada (ok)"
fi

if [[ -f "${SCRIPT_PATH}" ]]; then
rm -f "${SCRIPT_PATH}"
echo "→ Removido ${SCRIPT_PATH}"
else
echo "→ Script não encontrado (ok)"
fi

# Recarregar udev para aplicar remoção

echo "→ Recarregando udev"
udevadm control --reload
udevadm trigger

echo "✔️ Remoção concluída."
}

status_all() {
echo "🔎 Status:"
if [[ -f "${SCRIPT_PATH}" ]]; then
echo "→ Script: PRESENTE (${SCRIPT_PATH})"
else
echo "→ Script: AUSENTE"
fi

if [[ -f "${RULE_PATH}" ]]; then
echo "→ Regra: PRESENTE (${RULE_PATH})"
else
echo "→ Regra: AUSENTE"
fi

echo ""
echo "Últimos logs:"
tail -n 20 "${LOG_FILE}" 2>/dev/null || echo "(sem logs)"
}

main() {
[[ $# -lt 1 ]] && usage
require_root

case "$1" in
install) install_all ;;
remove)  remove_all  ;;
status)  status_all  ;;
*) usage ;;
esac
}

main "$@"
