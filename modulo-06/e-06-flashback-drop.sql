set verify off
set linesize window
spool salida-e06-flashback-drop.txt

define syslogon='sys/system2 as sysdba' 
define userlogon='user06/user06'


prompt 1. Conectando como usuario sys 
conn &syslogon

prompt Verificando la papelera 
col object_name format a30
col original_name format a15
col createtime format a19
select object_name,original_name,createtime from recyclebin;

prompt Activando la papelera de reciclaje
alter session set recyclebin=on;

prompt Verificando la papelera
select object_name,original_name,createtime from recyclebin;

prompt 2. Con el usuario user06
conn &userlogon

prompt Creando tabla fb_drop
create table fb_drop(id number, datos varchar2(10));

prompt Insertando datos
insert into fb_drop values(1,'dato1');
insert into fb_drop values(2,'dato2');
insert into fb_drop values(3,'dato3');
insert into fb_drop values(4,'dato4');
commit;

prompt Mostrando datos de la tabla
select * from fb_drop;


prompt 3. Eliminar la tabla y verificar
drop table fb_drop;
commit;

prompt Verificando que sea eliminada 
select * from fb_drop;

prompt 4. Mostrar el contenido de la papelera 
select object_name,original_name,createtime from recyclebin;

prompt 5.    Consultar el contenido de object_name
select * from "&object_name";

prompt 6. Recupera la tabla eliminada
flashback table fb_drop to before drop;

prompt Verificando la existencia de la tabla
select * from fb_drop;

prompt 7. Eliminar la tabla nuevamente y verificar
drop table fb_drop;
commit;

prompt Verificando la segunda eliminación
select * from fb_drop;

prompt 8. Crear la tabla nuevamente e insertar datos distintos
create table fb_drop(id number,datos varchar2(10));

prompt insertando datos
insert into fb_drop values(5,'dato5');
insert into fb_drop values(6,'dato6');
insert into fb_drop values(7,'dato7');
commit;

prompt Consultando datos segunda tabla 
select * from fb_drop;

prompt 9. Consultar la papelera de reciclaje
select object_name,original_name,createtime 
from recyclebin;

prompt 10. Eliminar la tabla nuevamente y verificar
drop table fb_drop;
commit;

prompt verifiacando la tercera eliminación
select * from fb_drop;

prompt 11. Consultar la papelera de reciclaje
select object_name,original_name,createtime from recyclebin;

prompt 12. Recupera las tablas eliminadas y renombrarlas
prompt fb_drop1
flashback table "&object_name1" to before drop rename  to fb_drop1;

prompt Consulta de la tabla fb_drop1
select * from fb_drop1;

prompt fb_drop2
flashback table "&object_name2" to before drop rename to fb_drop2;

prompt Consulta de la tabla fb_drop2
select * from fb_drop2;

prompt 13. Desactivar la papelera de reciclaje
alter session set recyclebin=off;

prompt 14. Borrar ambas tablas
drop table fb_drop1;
drop table fb_drop2;
commit;

prompt Consultar la papelera de reciclaje
select object_name,original_name,createtime from recyclebin;

spool off
exit
