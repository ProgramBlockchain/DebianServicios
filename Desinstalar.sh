# !/bin/bash
#Programa para desistalar paquetes

nombredelpaquete=$1
sudo apt purge --remove $nombredelpaquete -y
sudo apt autoremove -y
sudo apt autoclean -y
