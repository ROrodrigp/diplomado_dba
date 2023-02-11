#! /bin/bash 

# Script encargado de detener una cdb. Recibe dos parametro: 
# - nombre de la CDB (DB_NAME)
# - password 
# Se realiza una conexion local 

# parametro 1
cdb="${1}"

if [ -z "${cdb}" ]
then 
  echo "ERROR: indicar el CDB name (db_name) a iniciar: ./s30-stop-cdb.sh <db_name> <pwd>"
  exit 1 
fi

# parametro 2
pwd="${2}"

if [ -z "${pwd}" ]
then 
  echo "ERROR: indicar el password de SYS: ./s30-stop-cdb.sh <db_name> <pwd>"
  exit 1 
fi

echo "Deteniendo ${cdb}"
export ORACLE_SID="${cdb}"
sqlplus sys/${pwd} as sysdba <<EOF
shutdown immediate
exit;
EOF
