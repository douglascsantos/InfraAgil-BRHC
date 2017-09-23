#!/bin/bash
#CRIADO POR DOUGLAS SANTOS COSTA
#dscosta@tendtudo.com.br - git: douglascsantos/InfraAgil-BRHC

clear
#este script esta organizado por sessões, cada sessão representa apenas 01 tarefa de maneira simples e direta sendo que para tarefas grandes podem haver varias subssesoes
#script que automatiza algumas instalações de programas muito usados e configurações gerais da maquina, tambem gerando logs de hardware, software, rede e impressões, que podem ser utilizados em propósitos futuros
#para que o script funcione precisamos de sistema operacional Linux Ubuntu 16.04.03 amd64 recem instalado e acesso a internet sem restrições
#segue o link https://www.ubuntu.com/download/desktop
#funciona para desktops acima de celeron de 1 nucleo com 2GB de RAM e 20 de HD
#para desktops abaixo disso ou thinclients não perca seu tempo com este script pois não irá funcionar
#este script foi gerado e testado em ubuntu 16.04.3 ultima (LTS) e acompanhara o ciclo de vida da distro sendo desativado em abril de 2021.

echo "BEM VINDO AO INSTALADOR INFRAAGIL-BRHC"
echo 
echo
echo
echo 
echo
echo
echo 
echo
echo
echo "ANTES DE INICIAR CERTIFIQUE-SE QUE SUA CONEXÃO COM INTERNET E OS REPOSITÓRIOS PADRÕES ESTÃO FUNCIONANDO"
echo
echo 
echo
echo
echo 
echo
echo
apt-get update &> /dev/null
if [ "S?" != 0 ]; then echo "APT-GET UPDATE ENCONTROU FALHAS VERIFIQUE O ARQUIVO /etc/apt/sources.list"; exit; fi
echo
echo 
echo
echo
echo 
echo
echo
uname -a 

#criar pastas e variaveis
mkdir /root/logs
mkdir /root/inventario
mkdir /root/wps-office
mkdir /root/shares #sincroniza com pasta remota
mkdir /root/apt #backup das conf de sources.list

data=`/bin/date +%d-%m-%Y`
filial=1057

#colocar repositórios
#repositorios externos

#desinstalar interface grafica
echo "VAMOS DESINSTALAR A BOSTA DO UNITY"
/ect/init.d/lightdm stop
apt-get purge unity8 -y
apt-get purge unity -y
apt-get purge lightdm -y 
#apt-get purge libreoffice* -y
apt-get autoremove -y
echo "DESINSTALAÇÃO CONCLUIDA"
apt-get update &> /dev/null
clear

#instalar programas do mais simples para o mais complexo
echo "INSTALANDO GNOME"
apt-get install -y gdm3
apt-get install -y gnome-shell
apt-get install -y ubuntu-gnome-shell
apt-get purge libreoffice* -y
apt-get -y autoremove
clear
echo "GNOME INSTALADO"

apt-get install -y pv 
apt-get install -y wmctrl
apt-get install -y x11vnc
apt-get install -y openssh-server
apt-get install -y synaptic
apt-get install -y chromium-browser
clear


#INSTALAR O WPS OFFICE
cd /root/wps-office
sudo dpkg --add-architecture i386 -y
sudo apt-get update &> /dev/null
sudo apt-get install ia32-libs -y
sudo apt-get install gdebi -y
apt-get install -y multiarch-support libc6 zlib1g

wget -O libpng12-0 http://ftp.br.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_i386.deb

wget -O web-office-fonts.deb http://kdl.cc.ksosoft.com/wps-community/download/a15/wps-office-fonts_1.0_all.deb

#http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_i386.deb
wget -O wps-office.deb http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_i386.deb

chmod +x libpng12-0
dpkg -i libpng12-0
chmod +x wps-office.deb
sudo gdebi wps-office.deb
sudo dpkg -i wps-office.deb
chmod +x wps-office-fonts.deb
sudo dpkg -i web-office-fonts.deb
sudo apt-get -f install

#rm -fv wps-office.deb
#rm -fv libpng12-0
#rm -fv web-fonts.deb

wget -O extensao.zip http://wps-community.org/download/dicts/pt_BR.zip

cd /

echo "WPS OFFICE INSTALADO"
clear

#INSTALAR O CID 
#sudo add-apt-repository ppa:emoraes25/cid/xenial
#sudo apt-get update 
#instalar repositorio xenial (versão)
#apt-get install -y cid cid-gtk 


echo "programas instalados"

#configurações personalizadas
echo "vamos configurar o x11vnc"

x11vnc -storepasswd
touch /etc/init.d/script-vnc.sh
chmod 755 /etc/init.d/script-vnc.sh
echo "x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /root/.vnc/passwd -rfbport 5900 -shared -ultrafilexfer -tightfilexfer -geometry 1024x768" > /etc/init.d/script-vnc.sh
update-rc.d script-vnc.sh defaults
#update-rc.d -f nome-do-script remove 
clear

echo "vamos configurar o ssh-server"


#remover o sources.list para impedir atualizações
cd /root/apt
cp -rfv /etc/apt/ /root/apt
cp -rfv /etc/apt/sources.d /root/apt
cp -v /etc/apt/sources.list /root/apt/

rm -rfv /etc/apt/sources.d
rm -fv /etc/apt/sources.list
sudo rm -r /var/lib/apt/lists/* -vf

#adicionar bloqueios
#adicionar bloqueio de kernel USB e dispositivos


#instalar o DOMINIO

#info hardware
cd /root/inventario
hwinfo > hw-"$data"-"$filial".txt

#info rede
cd /root/inventario

#info kernel
cd /root/inventario
reboot
