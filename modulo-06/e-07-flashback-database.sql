set verify off
set linesize window
spool salida-e07-flashback-database.txt

define syslogon='sys/system2 as sysdba' 
define userlogon='user06/user06'


prompt 1. Conectando como usuario sys 
conn &syslogon

prompt Verificar el número SCN actual 
select dbms_flashback.get_system_change_number scnIni  from dual;

prompt 2. Creando el punto de restauración
create restore point punto_rest;

prompt 3. Verificando el punto de restuaración
col name format a15
col time format a50
select name,scn,time from v$restore_point;

prompt 4. Conectarse como user06 crear la tabla e insertar datos
conn &userlogon

prompt Creando la tabla 
create table fb_database(id number);
insert into fb_database values(1);
insert into fb_database values(2);
insert into fb_database values(3);
insert into fb_database values(4);
commit;

prompt Verificando contenido de la tabla 
select * from fb_database;

prompt 5.  Detener la instancia en modo mount 
conn &syslogon
shutdown immediate;
startup mount;

prompt 6. Regresando la base de datos al punto de restauración
flashback database to restore point punto_rest;

prompt 7. Abrir la base de datos en modo open y reiniciar los redo log
alter database open resetlogs;

prompt 8. Verificar que haya retornado al punto marcado
select * from user06.fb_database;

prompt 9. Eliminar el punto de restauración
drop restore point punto_rest;
exit
