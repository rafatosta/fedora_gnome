#!/bin/bash
# Configuração automática para corrigir erro de suspend da NVIDIA no Linux
# Testado no Fedora + GNOME, mas funciona em distros baseadas em systemd

CONFIG_FILE="/etc/modprobe.d/nvidia-power.conf"

echo "=== Configuração do driver NVIDIA ==="

# Verifica se está rodando como root
if [[ $EUID -ne 0 ]]; then
   echo "Por favor, execute como root (use: sudo $0)"
   exit 1
fi

# Cria o arquivo de configuração
echo "Criando arquivo $CONFIG_FILE..."
cat <<EOF > "$CONFIG_FILE"
# Desativa runtime suspend que causa erro -5
options nvidia NVreg_DynamicPowerManagement=0x02
EOF

# Atualiza initramfs
echo "Atualizando initramfs..."
if command -v dracut &>/dev/null; then
    dracut --force
elif command -v update-initramfs &>/dev/null; then
    update-initramfs -u
else
    echo "⚠ Nenhum gerador de initramfs encontrado (dracut/update-initramfs)."
fi

echo "✅ Configuração aplicada com sucesso!"
echo "🔄 Reinicie o computador para ativar as mudanças."
