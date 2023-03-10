set verify off
set linesize window
spool salida-e03-flashback-query.txt

define syslogon='sys/system2 as sysdba' 
define userlogon='user06/user06'

conn &syslogon
prompt 1. Creando al usuario user06
create user user06 identified by user06
default tablespace users
quota unlimited on users;

grant dba to user06;

prompt 2. Conectandose con el usuario user06
conn &userlogon

prompt Creando la  tabla fb_version
create table fb_query(id number(2),name varchar2(10));

prompt 3. Ingresando datos a la tabla 
insert into fb_query values(1,'dato1'); 
insert into fb_query values(2,'dato2');
insert into fb_query values(3,'dato3'); 
commit;


prompt Mostrando datos de la tabla 
select * from fb_query;

exec dbms_lock.sleep(5);

prompt 4. Obtener el SCN actual y la marca de tiempo 
select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora1
from dual;

select current_scn scn1 from v$database;

prompt 5. Modificar un dato en la tabla y confirmar
update fb_query set name='cambio1' where id=1; 
commit;

select * from fb_query;
exec dbms_lock.sleep(5);

prompt 6. Obtener nuevamente el SCN actual y la marca de tiempo
select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora2 from dual;
select current_scn scn2 from v$database;

prompt 7. Eliminar un registro en la tabla y confirmar 
delete fb_query where id=1;
commit;

select * from fb_query;
exec dbms_lock.sleep(5);

prompt 8. Nuevamente obtener el SCN actual y la marca de tiempo
select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora3 from dual;
select current_scn scn3 from v$database;

prompt 9. Mostrando la información en diferentes momentos
select * from fb_query as of
timestamp to_timestamp('&fechaHora1','dd-mm-yyyy hh24:mi:ss'); 

select * from fb_query as of scn &scn3;

prompt 10. Recuperamos el dato eliminado 
insert into fb_query(select * from fb_query as of scn &scn2 where id=1);
commit;

prompt Mostrando la información recuperada
select * from fb_query;

spool off
exit