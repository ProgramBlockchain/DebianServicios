# !/bin/bash
#
# Programa para instalar servicio de DNS con bind9
# Nombre: Cevallos Pablo
# Actualizar paquetes
sudo apt update && sudo apt upgrade

# Intalacion del servicio vim
sudo apt install -y bind9 dnsutils
# Redireccionar la salida a /etc/bind/named.conf.options cambiando los forwarder
# a 8.8.8.8 
cat named.conf.options_cp > /etc/bind/named.conf.options


