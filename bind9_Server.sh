# !/bin/bash
#
# Programa para instalar servicio de DNS con bind9
# Nombre: Cevallos Pablo
sudo apt install lolcat
echo "██████╗ ███╗   ██╗███████╗     ██████╗ ██████╗ ███╗   ██╗    ██████╗ ██╗███╗   ██╗██████╗  █████╗ 
██╔══██╗████╗  ██║██╔════╝    ██╔════╝██╔═══██╗████╗  ██║    ██╔══██╗██║████╗  ██║██╔══██╗██╔══██╗
██║  ██║██╔██╗ ██║███████╗    ██║     ██║   ██║██╔██╗ ██║    ██████╔╝██║██╔██╗ ██║██║  ██║╚██████║
██║  ██║██║╚██╗██║╚════██║    ██║     ██║   ██║██║╚██╗██║    ██╔══██╗██║██║╚██╗██║██║  ██║ ╚═══██║
██████╔╝██║ ╚████║███████║    ╚██████╗╚██████╔╝██║ ╚████║    ██████╔╝██║██║ ╚████║██████╔╝ █████╔╝
╚═════╝ ╚═╝  ╚═══╝╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚════╝ "|lolcat

echo " "
read -p "Ingresa tu direccion IPv4:" my_ip
read -p "Ingrese el nombre de domino:" my_dominio
echo "Ahora para la configuracion de red inversa es necesario que
ingrese su ipv4 de forma invertida la parte que hace referencia al host.
Ejemplo: Si mi direccion ip es 192.168.0.1 entonces ingresare 0.168.192"
read -p "Ingrese su direccion IPv4 de forma invertida:" my_ip_inv
read -p "Ingrese el ultimo numero de su IPv4:" my_ip_ult


echo "Tu direccion ip es: $my_ip"
echo "Tu dominio es: $my_dominio"
echo "Tu direccion invertida es: $my_ip_inv"

# Actualizar paquetes
sudo apt update && sudo apt upgrade
# Intalacion del servicio vim
sudo apt install -y bind9 dnsutils
# Redireccionar la salida a /etc/bind/named.conf.options cambiando los forwarder
# a 8.8.8.8 
cat named.conf.options_cp > /etc/bind/named.conf.options
echo "//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include \"/etc/bind/zones.rfc1918\";
//Zona directa
zone \"$my_dominio\"{
        type master;
        file \"/etc/bind/db.$my_dominio\";
};

//Zona inversa
zone \"$my_ip_inv.in-addr.arpa\"{
        type master;
        file \"/etc/bind/db.$my_ip\";

};" > /etc/bind/named.conf.local

sudo touch /etc/bind/db.$my_domino /etc/bind/db.$my_ip

echo ";
; BIND data file for local $my_dominio
;
"$(echo '$TTL')"    604800
@       IN      SOA     $my_dominio. root.$my_dominio. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns.$my_dominio.
@       IN      A       $my_ip
@       IN      AAAA    ::1
ns      IN      A       $my_ip" > /etc/bind/db.$my_dominio

echo ";
; BIND reverse data file for $my_ip.xxx
;
"$(echo '$TTL')"    604800
@       IN      SOA     ns.$my_dominio. root.$my_dominio. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns.
$my_ip_ult     IN      PTR     ns.$my_dominio." > /etc/bind/db.$my_ip



cat localhostserver.sh > /etc/resolv.conf


systemctl restart bind9
