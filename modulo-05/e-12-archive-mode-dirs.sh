#!/bin/bash
#Script encargado de crear directorios simulando discos para 
#almacenar archived redo logs 
#Se usaran los puntos de montaje 
#/unam-diplomado-bd/disk-04
#/unam-diplomado-bd/disk-05

if [[ -d "/unam-diplomado-bd/disk-05" || -d "/unam-diplomado-bd/disk-04" ]]
then
  echo "Directorios de la instancia RGPDIP02 existe. Se omite la creacion"
  exit 1
fi 

echo "Creando puntos de montaje"
mkdir -p /unam-diplomado-bd/disk-04/RGPDIP02/arclogs
mkdir -p /unam-diplomado-bd/disk-05/RGPDIP02/arclogs

echo "Cambiando permisos y dueno al directorio de arclogs"
cd /unam-diplomado-bd/disk-04
chown -R oracle:oinstall RGPDIP02/arclogs
chmod -R 750 RGPDIP02/arclogs

cd /unam-diplomado-bd/disk-05
chown -R oracle:oinstall RGPDIP02/arclogs
chmod -R 750 RGPDIP02/arclogs
