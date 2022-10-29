#!/bin/bash
echo "Creando PFILE"

export ORACLE_SID="rgpdip02"

echo "Creando archivo de parametros basicos"
echo \
"
db_name='${ORACLE_SID}'
memory_target=768M
control_files=(
  /unam-diplomado-bd/disk-01/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl,
  /unam-diplomado-bd/disk-02/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl,
  /unam-diplomado-bd/disk-03/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl
)
" >${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora

echo "comprobando existencia"

ls -l  ${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora

echo "Mostrando el contenido"
cat ${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora
