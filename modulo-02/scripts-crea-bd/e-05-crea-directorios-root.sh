#!/bin/bash
echo "Creando directorios para la nueva BD"

echo "Creando directorios para datafiles"

dirDataFiles="/u01/app/oracle/oradata/RGPDIP02"

if [ -d "${dirDataFiles}" ]
then 
  read -p "El directorio no esta vacio [Enter] para borrarlos, [Ctrl-C] para cancelar"
  rm -rf "${dirDataFiles}"/*

fi
echo "Cambiando dueno y permisos"
mkdir -p "${dirDataFiles}"
chown oracle:oinstall "${dirDataFiles}"
chmod 750 "${dirDataFiles}"

echo "Creando directorios para redologs y Control files"

pmontaje01="/unam-diplomado-bd/disk-01"
pmontaje02="/unam-diplomado-bd/disk-02"
pmontaje03="/unam-diplomado-bd/disk-03"

path="app/oracle/oradata/RGPDIP02"

if [[ -d "${pmontaje01}/${path}" || -d "${pmontaje02}/${path}"  || -d "${pmontaje03}/${path}"  ]]
then
  read -p "Se encontraron los directorios, [Enter] para borrarlos, [Ctrl-C] para cancelar"
  rm -rf "${pmontaje01}"/*
  rm -rf "${pmontaje02}"/*
  rm -rf "${pmontaje03}"/*
fi

mkdir -p "${pmontaje01}/${path}" 
mkdir -p "${pmontaje02}/${path}" 
mkdir -p "${pmontaje03}/${path}" 

echo "Cambiando dueno y permisos"
chown -R oracle:oinstall "${pmontaje01}"/* 
chown -R oracle:oinstall "${pmontaje02}"/* 
chown -R oracle:oinstall "${pmontaje03}"/* 

chmod -R 750 "${pmontaje01}"/* 
chmod -R 750 "${pmontaje02}"/*
chmod -R 750 "${pmontaje03}"/*  

echo "Verificando directorios creados"
echo "directorio de datafiles"
cd "${dirDataFiles}"
cd ..
ls -l 

echo "directorio de redologs "
ls -l "${pmontaje01}"
ls -l "${pmontaje02}"
ls -l "${pmontaje03}"

