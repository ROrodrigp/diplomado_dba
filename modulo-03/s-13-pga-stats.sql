prompt Mostrando datos estadísticos de la PGA, conectando como sysdba 
connect sys/system2 as sysdba 

prompt Mostrando estadísticas
select name, 'MB' unit, value/1024/1024 value_mb
from v$pgastat
where unit = 'bytes'
union all 
select name, unit, value
from v$pgastat
where unit <> 'bytes'
order by value_mb desc;

pause Analizar resultados, [Enter ] para continuar

prompt Creando usuario user03pga
create user user03pga identified by user03pga quota unlimited on users;
grant create session, create table to user03pga

prompt Mostrando datos del server process para esta sesión
col program format a40 
col sosid format a15
select sosid, username, program,
  pga_used_mem/1024/1024 pga_used_mem_mb,
  pga_alloc_mem/1024/1024 pga_alloc_mem_mb, 
  pga_freeable_mem/1024/1024 pga_freeable_mem_mb,
  pga_max_mem/1024/1024 pga_max_mem_mb
from v$process
where background  is null 
and username <> 'oracle';

pause Analizar resultados, [Enter ] para continuar

prompt Creando copias de all_object
create table user03pga.all_objects_copy as
  select * from all_objects order by object_name;

prompt Mostrando datos del server process nuevamente

select sosid, username, program,
  pga_used_mem/1024/1024 pga_used_mem_mb,
  pga_alloc_mem/1024/1024 pga_alloc_mem_mb, 
  pga_freeable_mem/1024/1024 pga_freeable_mem_mb,
  pga_max_mem/1024/1024 pga_max_mem_mb
from v$process
where background  is null 
and username <> 'oracle';

pause Analizar resultados, que diferencias existen? [Enter] para continuar

prompt Mostrando estadísticas globales de la PGA nuevamente
select name, 'MB' unit, value/1024/1024 value_mb
from v$pgastat
where unit = 'bytes'
union all 
select name, unit, value
from v$pgastat
where unit <> 'bytes'
order by value_mb desc;

pause Comparar resultados con la primera consulta, [Enter] para continuar


prompt Realizando limpieza 
drop user user03pga cascade;