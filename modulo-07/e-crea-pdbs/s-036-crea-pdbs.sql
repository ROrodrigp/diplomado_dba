spool m07-e03-06.txt
prompt Creando PDB tipo refreshable 

prompt Iniciar rgpdip03
!sh s-030-start-cdb.sh rgpdip03 system3

prompt Iniciar rgpdip04
!sh s-030-start-cdb.sh rgpdip04 system04

prompt conectando a rgpdip03
connect sys/system3@rgpdip03 as sysdba

prompt Abriendo rgpdip03_s1
alter pluggable database rgpdip03_s1 open read write;


prompt Crear un tablespace para guardar datos
alter session set container=rgpdip03_s1;
create tablespace test_refresh_ts
  datafile '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_s1/test_refresh.dbf'
  size 1M autoextend on next 1M;

prompt Creando un usuario comun
alter session set container=cdb$root;
create user c##rodrigo_remote identified by rodrigo container=all;
grant create session, create pluggable database to c##rodrigo_remote
  container=all;

prompt Conectando a rgpdip04 para crear la liga 
connect sys/system04@rgpdip04 as sysdba

prompt Crear liga 
create database link clone_link
  connect to c##rodrigo_remote identified by rodrigo
  using 'RGPDIP03_S1';

prompt Crear PDB de tipo refreshable
create pluggable database rgpdip04_r3
from rgpdip03_s1@clone_link
file_name_convert=(
  '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_s1',
  '/u01/app/oracle/oradata/RGPDIP04/rgpdip04_r3'
) refresh mode manual;

prompt Consultando el ultimo refresh 
select last_refresh_scn
from dba_pdbs
where pdb_name='RGPDIP04_R3';

pause Analizar el valor del SCN [enter] para continuar 

prompt Crear una tabla y un registro en rgpdip03_s1
connect sys/system3@rgpdip03_s1 as sysdba

prompt Creando un usuario de prueba
create user rodrigo_refresh identified by rodrigo
  default tablespace test_refresh_ts
  quota unlimited on test_refresh_ts;

grant create session, create table to rodrigo_refresh;

prompt Creando la tabla test_refresh

create table rodrigo_refresh.test_refresh(id number);

prompt Insertando datos de prueba 

insert into rodrigo_refresh.test_refresh values (1);
commit;

select * from rodrigo_refresh.test_refresh;

pause Revisar tabla y datos creados [Enter] para continuar
prompt conectando a la rgpdip04_r3

connect sys/system04@rgpdip04 as sysdba

prompt Hacer switch a rgpdip04_r3
alter pluggable database rgpdip04_r3 open read only;

alter session set container=rgpdip04_r3;

prompt Verificando datos 
pause Qué se obtendría al intentar consultar la tabla? [Enter] para continuar
--Respuesta esperada: No va a exisitir porque falta hacer refresh 
select * from rodrigo_refresh.test_refresh;

prompt Hacer refresh (desde root)
alter session set container=cdb$root;
--la PDB debe estar cerrada 
alter pluggable database rgpdip04_r3 close immediate;
alter pluggable database rgpdip04_r3 refresh;


prompt Consultando datos nuevamente
pause Qué se esperaría? [Enter] para continuar
alter pluggable database rgpdip04_r3 open read only;

alter session set container=rgpdip04_r3;
select * from rodrigo_refresh.test_refresh;

prompt Mostrar el ultimo scn 
select last_refresh_scn
from dba_pdbs
where pdb_name='RGPDIP04_R3';

pause Analizar resultados [Enter] para realizar limpieza
alter session set container=cdb$root;
alter pluggable database rgpdip04_r3 close immediate;
drop pluggable database rgpdip04_r3 including datafiles;


drop database link clone_link;

--Eliminando el usuario en comun 
connect sys/system3@rgpdip03 as sysdba
drop user c##rodrigo_remote cascade;

--eliminando el tablespace 
alter session set container=rgpdip03_s1;
drop tablespace test_refresh_ts including contents and datafiles;

--Eliminar al usuario rodrigo_refresh
drop user rodrigo_refresh cascade;

spool off
exit 