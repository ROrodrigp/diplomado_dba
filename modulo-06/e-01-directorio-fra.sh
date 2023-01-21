#!/bin/bash

echo "1. Creando directorio para la FRA"
mkdir -p /unam-diplomado-bd/fast-recovery-area

echo "2 Cambiar permisos"

cd /unam-diplomado-bd
chown oracle:oinstall fast-recovery-area
chmod 750 fast-recovery-area

echo "Mostrando estructuras de directorio"
tree /unam-diplomado-bd/fast-recovery-area

exit