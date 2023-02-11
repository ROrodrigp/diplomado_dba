set linesize window
col pdb_name format a30
col name format a30
col open_time format a40 

prompt Consulta 1, conectando a root 
prompt Conectando a root 
connect sys/system3@rgpdip03
select dbid, name, cdb, con_id, con_dbid
from v$database;

prompt Consulta 1, conectando a rgpdip03_s1
connect sys/system3@rgpdip03_s1
select dbid, name, cdb, con_id, con_dbid
from v$database;

pause Analizar resultados [Enter] para continuar


prompt Consulta 2 en root - dba_pdbs
connect sys/system3@rgpdip03
select pdb_id, pdb_name, dbid, status from dba_pdbs;
prompt Consulta 2 en rgpdip03_s2 - dba_pdbs
connect sys/system3@rgpdip03_s2
select pdb_id, pdb_name, dbid, status from dba_pdbs;

pause Analizar resultados [Enter] para continuar

prompt Consulta 3 en root - v$pdbs
connect sys/system3@rgpdip03
select con_id, name, open_mode, open_time from v$pdbs;
prompt Consulta 3 en rgpdip03_s1 - v$pdbs
connect sys/system3@rgpdip03_s1
select con_id, name, open_mode, open_time from v$pdbs;
prompt Consulta 3 en rgpdip03_s2 - v$pdbs
connect sys/system3@rgpdip03_s2
select con_id, name, open_mode, open_time from v$pdbs;


pause Analizar resultados [Enter] para continuar

prompt pregunta 4 desde root empleando alter session 
alter session set container=cdb$root;
show con_id 
show con_name 

prompt pregunta 4 desde rgpdip03_s1 empleando alter session 
alter session set container=rgpdip03_s1;
show con_id 
show con_name 

prompt pregunta 4 desde rgpdip03_s2 empleando alter session 
alter session set container=rgpdip03_s2;
show con_id 
show con_name 

pause Analizar resultados [Enter] para continuar

prompt pregunta 5, conectando a rgpdip03_s1, creando una tabla 
alter session set container=rgpdip03_s1;
create user rodrigo07 identified by rodrigo quota unlimited on users;
grant create session, create table to rodrigo07;
create table rodrigo07.test(id number);

prompt pregunta 5, conectando a rgpdip03_s2, creando una tabla 
alter session set container=rgpdip03_s2;
create user rodrigo07 identified by rodrigo quota unlimited on users;
grant create session, create table to rodrigo07;
create table rodrigo07.test(id number);

prompt Creando un nuevo registro en rgpdip03_s1 para  rodrigo07.test
alter session set container=rgpdip03_s1;
--aqui se genera una transaccion 
insert into rodrigo07.test values (100);


prompt Conectando a rgpdip03_s2 sin hacer commit desde esta transaccion 
pause Se podrá? [Enter] para continuar
alter session set container=rgpdip03_s2;
pause ¿Fue posible? [Enter] para continuar 

prompt Intentando insertar en la tabla ¿Se genera otra transaccion?
insert into rodrigo07.test values (200);
pause ¿Fue posible? [Enter] para continuar 

prompt Conectando nuevamente a la rgpdip03_s1 ¿Qué sucedio con la transaccion ?
alter session set container=rgpdip03_s1;
pause ¿Que mostrara al intentar consultar los datos de la tabla test?
select * from rodrigo07.test;

