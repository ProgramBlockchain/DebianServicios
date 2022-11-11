# !/bin/bash
#
# Programa para instalar servicio de DNS con bind9
# Nombre: Cevallos Pablo
read -p "Ingresa tu direccion IPv4:" my_ip
# Actualizar paquetes
sudo apt update && sudo apt upgrade
# Intalacion del servicio vim
sudo apt install -y bind9 dnsutils
# Redireccionar la salida a /etc/bind/named.conf.options cambiando los forwarder
# a 8.8.8.8 
cat named.conf.options_cp > /etc/bind/named.conf.options

cat prueba.sh > /etc/resolv.conf

echo "Tu direccion ip es: $my_ip "

systemctl restart bind9
