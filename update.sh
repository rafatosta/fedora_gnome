

## Instalando programas pessoais
dnf install -y google-chrome-stable code nodejs adw-gtk3-theme 

## Instala as extensões
dnf install -y gnome-shell-extension-user-theme gnome-shell-extension-appindicator

## Apps em flatpak
flatpak install -y com.mattjakeman.ExtensionManager \
     com.github.tchx84.Flatseal \
     org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark

## Desativa NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service