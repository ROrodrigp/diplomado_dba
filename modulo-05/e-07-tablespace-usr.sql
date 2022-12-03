prompt conectando como sys 
spool 'salida-e07.txt' create;
connect sys/system2 as sysdba

set linesize window 
col property_name format A30
col property_value format A30
col tablespace_name format A30
col username format A30

prompt Mostrando datos de los tablespaces empleando database_properties
select property_name, property_value
from database_properties
where property_name like '%TABLESPACE%';

prompt Mostrando datos de los tablespace a traves de user_user 
connect rodrigo05/rodrigo05
select default_tablespace, temporary_tablespace, local_temp_tablespace
from user_users;

prompt Mostrando tablespace undo empleado por todos los usuarios 
connect sys/system2 as sysdba
show parameter undo_tablespace

prompt Mostrando cuotas de almacenamientos para los usuarios 
select tablespace_name, username, bytes/1024/1024 quota_mb, blocks, max_blocks
from dba_ts_quotas;

prompt Mostrar los datos de la ts temporal 
select tablespace_name, tablespace_size/1024/1024  ts_size_mb,
  allocated_space/1024/1024 allocate_space_mb,
  free_space/1024/1024 free_space_mb
from dba_temp_free_space;

--Instruccion para cambiar el ts temporal 
--alter database default temporary tablespace <tablespace name>

spool off;
exit



