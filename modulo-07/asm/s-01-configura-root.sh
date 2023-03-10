#!/bin/bash 
echo "Configurando ambiente ASM"

echo "Creando grupos para ASM"
groupadd asmadmin
groupadd asmdba
groupadd asmoper

echo "Actualizando grupos del usuario oracle"
usermod -aG asmdba oracle 

echo "Creando usuario grid"
useradd -g oinstall -G asmadmin,asmoper,asmdba,dba grid 

echo "Actualizando el password de grid"
passwd grid

echo "Crear directorios"
mkdir /u01/app/grid
chown grid:oinstall /u01/app
chown grid:oinstall /u01/app/grid

echo "Crear loop devices "
mkdir /unam-diplomado-bd/loop-devices/asm
chown grid:oinstall /unam-diplomado-bd/loop-devices/asm

cd /unam-diplomado-bd/loop-devices/asm

echo "Creando disk1.img - 2G"
dd if=/dev/zero of=disk1.img bs=100M count=25

echo "Creando disk2.img - 2G"
dd if=/dev/zero of=disk2.img bs=100M count=25

echo "Creando disk3.img - 2G"
dd if=/dev/zero of=disk3.img bs=100M count=25

echo "Creando disk4.img - 2G"
dd if=/dev/zero of=disk4.img bs=100M count=25

echo "Creando disk5.img - 2G"
dd if=/dev/zero of=disk5.img bs=100M count=25

echo "Creando disk6.img - 2G"
dd if=/dev/zero of=disk6.img bs=100M count=25

echo "Creando disk7.img - 2G"
dd if=/dev/zero of=disk7.img bs=100M count=25


echo "Cambiando permisos archivos img"
chown grid:asmdba *.img
chmod 660 *.img

echo "Asociando archivos img a un loop device"
for i in 1 2 3 4 5 6 7
do 
  disk="disk${i}.img"
  loopDevice=$(losetup -f)
  rawDevice="/dev/raw/asmraw0${i}"

  echo "Asociando ${loopDevice} a ${disk}"
  losetup ${loopDevice} ${disk}

  echo "Asociando a ${rawDevice}"
  raw ${rawDevice} ${loopDevice} 
done

echo "Cambiando permisos a raw devices"
chown grid:asmdba /dev/raw/asmraw*
chmod 660 /dev/raw/asmraw*

echo "Mostrando raw devices"
ls -l /dev/raw/

echo "Creando directorio para instalar grid"
mkdir -p /u01/app/grid/product/19.3.0/grid
cd /u01/app
echo "Cambiano permisos para grid"
chown -R grid:oinstall grid
