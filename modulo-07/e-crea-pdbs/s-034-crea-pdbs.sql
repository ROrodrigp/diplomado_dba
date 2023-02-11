spool m07-e03-04.txt
prompt Hacer clon rgpdip03_s1 -> rgpdip04_m3 Ahora con DB links 

prompt Iniciando rgpdip03 
!sh s-030-start-cdb.sh rgpdip03 system3 

prompt Iniciando rgpdip04 
!sh s-030-start-cdb.sh rgpdip04 system04 

prompt Conectando a rgpdip03
connect sys/system3@rgpdip03 as sysdba 

--Crear un usuario en comun (nivel CDB) para realizar conexiones a traves de 
--un DB link 
prompt Creando usuario en rgpdip03
create user c##rodrigo_remote identified by rodrigo container=ALL;
grant create session, create pluggable database to c##rodrigo_remote container=all;

prompt Conectando a rgpdip04 para crear DB link 
connect sys/system04@rgpdip04 as sysdba

create database link clone_link 
  connect to c##rodrigo_remote identified by rodrigo 
  using 'RGPDIP03';

prompt Creando pdb rgpdip04_m3
create pluggable database rgpdip04_m3
  from rgpdip03_s1@clone_link
  file_name_convert=(
    '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_s1',
    '/u01/app/oracle/oradata/RGPDIP04/rgpdip04_m3'
  );

prompt Abriendo y verificando la nueva pdb 
alter pluggable database rgpdip04_m3 open read write;
show pdbs 

pause Analizar resultados. [Enter] para continuar con limpieza 

prompt Borrar PDB 
alter pluggable database rgpdip04_m3 close;
drop pluggable database rgpdip04_m3 including datafiles;

drop database link clone_link;

prompt Eliminando el usuario  en rgpdip03
connect sys/system3@rgpdip03 as sysdba

drop user c##rodrigo_remote cascade;

spool off 
exit
