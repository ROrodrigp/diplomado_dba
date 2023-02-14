spool m07-e03-05.txt

prompt Clonar PDB a partir de una NON CDB 

prompt Detener rgpdip03, se clonará en en rgpdip04
!sh s-030-stop-cdb.sh rgpdip03 system3 

prompt Iniciar rgpdip04
!sh s-030-start-cdb.sh rgpdip04 system04 

prompt Iniciar NON CDB 
!sh s-030-start-cdb.sh rgpdip02 system2 

prompt Crear un usuario en NON CDB 
connect sys/system2@rgpdip02_dedicated as sysdba 
create user rodrigo_remote identified by rodrigo;
grant create session, create pluggable database to rodrigo_remote;
ALTER SYSTEM SET ENCRYPTION wallet OPEN IDENTIFIED BY "wallet_password";

prompt Conectando a rgpdip04
connect sys/system04@rgpdip04 as sysdba

prompt Creando db link 
create database link clone_link
  connect to rodrigo_remote identified by rodrigo 
  using 'rgpdip02_dedicated';

prompt Creando PDB 
create pluggable database rgpdip04_m4
  from non$cdb@clone_link
  file_name_convert=(
    '/u01/app/oracle/oradata/RGPDIP02',
    '/u01/app/oracle/oradata/RGPDIP04/rgpdip04_m4'
  ) keystore identified by "wallet_password";

prompt Abriendo nueva PDB 
alter pluggable database rgpdip04_m4 open read write;
show pdbs

pause Analizar resultados. [Enter] para la limpieza. 

prompt Borrar PDB 
alter pluggable database rgpdip04_m4 close;
drop pluggable database rgpdip04_m4 including datafiles;

drop database link clone_link;

prompt Eliminando el usuario  en rgpdip02
connect sys/system2@rgpdip02_dedicated as sysdba

drop user rodrigo_remote cascade;

spool off 
exit