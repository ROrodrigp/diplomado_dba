--1
connect sys/system2 as sysdba 
spool 'salida-e14.txt' replace;
prompt Consulta 1
select name, log_mode, archivelog_compression
from v$database;

--2
prompt Consulta 2
col DEST_NAME format A30
col DESTINATION format A50
select dest_id, dest_name, status, binding, destination
from v$archive_dest
where dest_name in ('LOG_ARCHIVE_DEST_1', 'LOG_ARCHIVE_DEST_2');

--3
prompt Consulta 3
alter session set nls_date_format='yyyy/mm/dd hh24:mi:ss';
select * from v$log;

--4 
prompt Consulta 4
select * from v$log_history;

--5
prompt Consulta 5
select * from v$archived_log;