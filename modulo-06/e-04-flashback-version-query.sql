set verify off
set linesize window
spool salida-e04-flashback-version-query.txt

define syslogon='sys/system2 as sysdba' 
define userlogon='user06/user06'

prompt 1. Conectarse con el usuario user06 
conn &userlogon

prompt Creando la tabla fb_version

create table fb_version(id number,name varchar2(15),fechaHora varchar2(30));
exec dbms_lock.sleep(5);

prompt insertando tres registros
insert into fb_version values(1,'valor1',to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') );
insert into fb_version values(2,'valor2',to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') );
insert into fb_version values(3,'valor3',to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') );
commit;

prompt Mostrando datos de la  tabla 
select * from fb_version;

prompt 2. Consultando el SCN actual y la marca de tiempo
select current_scn scn1 from v$database; 
exec dbms_lock.sleep(5);

prompt 3. Realizando una actualización
update fb_version set name='cambio1', fechaHora=to_char(sysdate,'dd-mm- yyyy hh24:mi:ss') where id=1;
commit;

prompt Mostrando datos de la tabla 
select * from fb_version;
exec dbms_lock.sleep(5);

prompt 4. Realizando nuevamente una actualizacion
update fb_version set name='cambio2', fechaHora=to_char(sysdate,'dd-mm- yyyy hh24:mi:ss') where id=1;
commit;

prompt Mostrando datos actualizados
select * from fb_version;
exec dbms_lock.sleep(5);

prompt 5. Eliminar un registro de la tabla
delete fb_version where id=1;
commit;

prompt Mostrando datos actualizados
select * from fb_version;
exec dbms_lock.sleep(5);

prompt 6. Obtener el SCN actual 
select current_scn scn2 from v$database; 
exec dbms_lock.sleep(5);

prompt 7. Mostrando el historico de los eventos ocurridos
prompt Consulta 1 fechaHora
select id,name,fechaHora
from fb_version
versions between timestamp minvalue 
and maxvalue
where id=1;

prompt Consulta 2 SCN
select id,name,fechaHora 
from fb_version
versions between scn &scn1 and &scn2
where id=1;

spool off
exit