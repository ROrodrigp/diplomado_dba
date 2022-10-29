#!/bin/bash
echo "Creando loop devices"
echo "Creando carpeta para guardar archivos img"
mkdir -p /unam-diplomado-bd/loop-devices

cd /unam-diplomado-bd/loop-devices

echo "Creando disk1.img"
dd if=/dev/zero of=disk-01.img bs=100M count=10

echo "Creando disk2.img"
dd if=/dev/zero of=disk-02.img bs=100M count=10

echo "Creando disk3.img"
dd if=/dev/zero of=disk-03.img bs=100M count=10

echo "Verificando la existencia de los archivos img"
du -sh disk*.img

echo "Asociando archivos de img a un loop device"
losetup -fP disk-01.img
losetup -fP disk-02.img
losetup -fP disk-03.img

echo "Mostrando la creacion de looop devices"
losetup -a 

echo "Aplicando formato ext4 a los nuevos dispositivos"
mkfs.ext4 disk-01.img
mkfs.ext4 disk-02.img
mkfs.ext4 disk-03.img

echo "Listo"
