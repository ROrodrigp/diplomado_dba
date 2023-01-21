--1
select name, log_mode, archivelog_compression
from v$database;

--2
select dest_id, dest_name, status, binding, destination
from v$archive_dest
where dest_name in ('LOG_ARCHIVE_DEST_1', 'LOG_ARCHIVE_DEST_2');

--3
alter session set nls_date_format='yyyy/mm/dd hh24:mi:ss';
select * from v$log;
--¿Cuál es el número de grupo en el que actualmente se está escribiendo?
--CURRENT
--¿Qué número de secuencia tiene cada grupo?
--346
--¿Qué valor tiene el número de secuencia menor?
--344 del grupo 2
