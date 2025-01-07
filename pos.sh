
## Removendo apps não utilizados
dnf remove -y gnome-photos gnome-contacts gnome-tour \
    gnome-boxes gnome-maps gnome-logs gnome-weather \
    podman firefox abrt rhythmbox totem simple-scan mediawriter


dnf autoremove

# Desativando repositórios não utilizados
dnf config-manager --disable *-steam *-PyCharm *-openh264

dnf up

