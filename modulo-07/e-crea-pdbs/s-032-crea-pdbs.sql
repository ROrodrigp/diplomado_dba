spool m07-e03-02.txt

prompt Creando PDB con rutas particulares 

prompt Conectar a root 
connect sys/system3@rgpdip03 as sysdba 

prompt Creando PDB rgpdip03_s3

create pluggable database rgpdip03_s3 admin user admin_s3
  identified by admin_s3
  file_name_convert=(
    '/u01/app/oracle/oradata/RGPDIP03/pdbseed',
    '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_s3'
  );

pause Revisar datafiles generados en ORACLE_BASE/oradata [Enter] para continuar 

prompt limpieza
drop pluggable database rgpdip03_s3 including datafiles;
