#!/bin/bash
echo "Creando archivo de passwords para la instancia 2"

echo "Configurando ORACLE_SID"
export ORACLE_SID=rgpdip02
echo ${ORACLE_SID}

archivoPwd="orapw${ORACLE_SID}"

echo "Creando archivo de passwords"

if [ -f "${ORACLE_HOME}/dbs/${archivoPwd}" ]
then 
    echo "El archivo existe, se va a sobrescribir..."
fi

orapwd \
    FILE="${ORACLE_HOME}/dbs/${archivoPwd}" \
    FORMAT=12.2 \
    FORCE=Y \
    SYS=password

echo "Comprobando la existencia del archivo"
ls -l ${ORACLE_HOME}/dbs/${archivoPwd}
