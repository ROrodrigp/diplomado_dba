set verify off
set linesize window
spool salida-e05-flashback-table.txt

define syslogon='sys/system2 as sysdba' 
define userlogon='user06/user06'


prompt 1. Conectarse con el usuario user06 
conn &userlogon

prompt Creando la tabla venta
create table venta(idVenta number,monto number(12));
exec dbms_lock.sleep(5);

prompt 2.  Configurar la tabla para regresarla en el tiempo 

alter table venta enable row movement;

prompt 3. Tomar el scn actual y el tiempo
select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora1,
dbms_flashback.get_system_change_number() scn1
from dual;

exec dbms_lock.sleep(5);

prompt 4.  Agregar el primer registro a la tabla
prompt registro 1

insert into venta values(1,1300);
commit;
select * from venta;

exec dbms_lock.sleep(5);

prompt 5. Tomando  el scn y el tiempo
select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora2,
dbms_flashback.get_system_change_number() scn2
from dual;
exec dbms_lock.sleep(5);

prompt 6.  Agregando dos datos mas a la tabla
prompt  registro 2

insert into venta values(2,1500);
commit;

select * from venta;

select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora3,
dbms_flashback.get_system_change_number() scn3
from dual;

exec dbms_lock.sleep(5);

prompt  registro 3

insert into venta values(3,500);
commit;
select * from venta;

select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora4,
dbms_flashback.get_system_change_number() scn4
from dual;

exec dbms_lock.sleep(5);

prompt 7. Mostrar el contenido de la tabla

select * from venta;
exec dbms_lock.sleep(5);

prompt Eliminando el contenido de la tabla 
delete from venta;
commit;

prompt Mostrando los cambios 
select * from venta;
exec dbms_lock.sleep(5);

prompt 8. Tomar el scn y el tiempo

select to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora5,
dbms_flashback.get_system_change_number() scn5
from dual;
exec dbms_lock.sleep(5);

prompt 9. Restaurar la tabla a algún punto en el tiempo 
prompt Con SCN
flashback table venta to scn &scn;
select * from venta;

prompt con fechaHora
flashback table venta to timestamp to_timestamp('&fechaHora','dd-mm-yyyy hh24:mi:ss');
select * from venta;

prompt 10. Mostrar el contenido final de la tabla venta
select * from venta;

spool off
exit