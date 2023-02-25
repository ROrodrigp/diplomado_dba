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
losetup /dev/loop11 disk1.img
losetup /dev/loop12 disk2.img
losetup /dev/loop13 disk3.img
losetup /dev/loop14 disk4.img
losetup /dev/loop15 disk5.img
losetup /dev/loop16 disk6.img
losetup /dev/loop17 disk7.img

echo "Verificando loop devices"
losetup -a 

echo "Asociar  loop device como raw"
raw /dev/raw/raw01 /dev/loop11
raw /dev/raw/raw02 /dev/loop12
raw /dev/raw/raw03 /dev/loop13
raw /dev/raw/raw04 /dev/loop14
raw /dev/raw/raw05 /dev/loop15
raw /dev/raw/raw06 /dev/loop16
raw /dev/raw/raw07 /dev/loop17

echo "Cambiando permisos a raw devices"
chown grid:asmdba /dev/raw/raw*
chmod 660 /dev/raw/raw*

echo "Mostrando raw devices"
ls -l /dev/raw/

echo "Creando directorio para instalar grid"
mkdir -p /u01/app/grid/product/19.3.0/grid
cd /u01/app
echo "Cambiano permisos para grid"
chown -R grid:oinstall grid
