spool m07-e03-07.txt

prompt Creando proxy PDB
prompt Iniciar rgpdip03
!sh s-030-start-cdb.sh rgpdip03 system3

prompt Iniciar rgpdip04
!sh s-030-start-cdb.sh rgpdip04 system04 

prompt Preparando rgpdip03_s2
connect sys/system3@rgpdip03 as sysdba

prompt Creando un common user
create user c##rodrigo_remote identified by rodrigo container=all;
grant create session, create pluggable database to c##rodrigo_remote
  container=all;

prompt Abriendo PDB
alter pluggable database rgpdip03_s2 open read write;

alter session set container=rgpdip03_s2;
create tablespace test_proxy_ts
  datafile '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_s2/test_proxy.dbf'
  size 1M autoextend on next 1M;

prompt Creando un usuario de prueba
create user rodrigo_proxy identified by rodrigo
  default tablespace test_proxy_ts
  quota unlimited on test_proxy_ts;

grant create session, create table to rodrigo_proxy;

prompt Creando la tabla test_refresh

create table rodrigo_proxy.test_proxy(id number);

prompt Insertando datos de prueba 

insert into rodrigo_proxy.test_proxy values (1);
commit;

select * from rodrigo_proxy.test_proxy;

pause Revisar datos [enter] para continuar

prompt Conectando a rgpdip04 para crear liga y proxy PDB
connect sys/system04@rgpdip04 as sysdba

prompt Creando liga 
create database link clone_link
  connect to c##rodrigo_remote identified by rodrigo
  using 'RGPDIP03_S2';

prompt Creando proxy PDB 
create pluggable database rgpdip04_p1 as proxy
from rgpdip03_s2@clone_link
file_name_convert=(
  '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_s2',
  '/u01/app/oracle/oradata/RGPDIP04/rgpdip04_p1'
);

pause Probando proxy PDB [enter] para continuar

prompt Abrir la proxy PDB 
alter pluggable database rgpdip04_p1 open read write;

prompt Accediendo a rgpdip03_s2 a traves de la proxy PDB 
connect rodrigo_proxy/rodrigo@rgpdip04_p1;

prompt Mostrando datos desde proxy 
select * from test_proxy;

prompt Insertando datos desde proxy 
insert into test_proxy values(2);
commit;

prompt Validando en rgpdip03_s2
connect sys/system3@rgpdip03_s2 as sysdba

select * from rodrigo_proxy.test_proxy;

pause Analizar resultados [Enter] para continuar con la limpieza

prompt limpieza en rgpdip03_s2
alter session set container=cdb$root;
--Eliminando el usuario en comun 
drop user c##rodrigo_remote cascade;

--eliminando el tablespace 
alter session set container=rgpdip03_s2;
drop tablespace test_proxy_ts including contents and datafiles;

--Eliminar al usuario rodrigo_proxy
drop user rodrigo_proxy cascade;

prompt limpieza en rgpdip04
connect sys/system04@rgpdip04 as sysdba
alter pluggable database rgpdip04_p1 close immediate;
drop pluggable database rgpdip04_p1 including datafiles;


drop database link clone_link;

spool off
exit 




