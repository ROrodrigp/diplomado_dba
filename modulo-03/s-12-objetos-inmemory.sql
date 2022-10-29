prompt Autenticando como sysdba
connect sys/system2 as sysdba 

prompt Consultando dato de user03imc.movie, mostrando plan de ejecución
explain plan
set statement_id ='q1' for
select /*+ gather_plan_statistics */ title, trunc(duration/60,1) duration_hr
from user03imc.movie
where upper(title) like '% WAR %';

prompt Mostrando el plan de ejecución
select * from table (
  dbms_xplan.display(
    statement_id => 'q1'
  )
);

pause Analizar el plan de ejecución [enter] para continuar

prompt Habilitando In Memory column store para la table movie 
alter table user03imc.movie inmemory;
 
prompt Mostrando configuracion IM Column store
col table_name format a10
select table_name, inmemory, inmemory_compression, inmemory_priority
from dba_tables
where table_name='MOVIE'
and owner = 'USER03IMC';

pause Analizar la configuracion de la IM Column Store [enter] para continuar
prompt Consultando segmentos de la tabla movie en el IM column store
col segment_name format a20
select segment_name, bytes/1024/1024 mbs, inmemory_size/1024/1024 inmemory_size_mb,
  populate_status
from v$im_segments
where segment_name='MOVIE'
and owner ='USER03IMC';

pause Analizar los segmentos de la tabla en el IM Column Store [Enter ] para continuar
prompt Realizando consulta en la tabla MOVIE para provocar carga de datos en el IM column store
col title format a40
select title, trunc(duration/60,1) duration_hr
from user03imc.movie
where upper(title) like '% WAR %';

pause Cuantos registros se obtuvieron? [Enter ] para continuar
prompt Mostrando los datos del segmento nuevamente, se esperan datos...
select segment_name, bytes/1024/1024 mbs, inmemory_size/1024/1024 inmemory_size_mb,
  populate_status
from v$im_segments
where segment_name='MOVIE'
and owner = 'USER03IMC';

pause Analizar resultados, [Enter ] para continuar
prompt Mostrando informacion de los iMCUs
col column_name format a20
col minimum_value format a20
col maximum_value format a50
select column_number, column_name, minimum_value, maximum_value
from v$im_col_cu cu, dba_objects o, dba_tab_cols c
where cu.objd = o.data_object_id
and o.object_name = c.table_name
and cu.column_number = c.column_id
and o.object_name='MOVIE'
and o.owner='USER03IMC'
order by column_number, minimum_value;

pause Analizar resultados, [Enter ] para continuar
prompt Deshabilitando el uso de la IMC store de forma temporal 
alter session set inmemory_query=disable;

prompt Ejecutando consulta nuevamente
select title, trunc(duration/60,1) duration_hr
from user03imc.movie
where upper(title) like '% WAR %';

prompt Mostrando estadísticas del uso de la IMC column store y sus iMCUs -  inmemory_query=disbale

col display_name format a30
select display_name,value
from v$mystat m, v$statname n
where m.statistic# = n.statistic#
and display_name in (
  'IM scan segments minmax eligible',
  'IM scan CUs delta pruned',
  'IM scan segments disk',
  'IM scan bytes in-memory',
  'IM scan bytes uncompressed',
  'IM scan rows',
  'IM scan blocks cache'
);

pause Analizar resultados, [Enter ] para continuar

prompt Habilitar nuevamente el uso de la IMC store
alter session set inmemory_query=enable;

prompt Ejecutando consulta nuevamente
select title, trunc(duration/60,1) duration_hr
from user03imc.movie
where upper(title) like '% WAR %';

prompt Mostrando estadísticas del uso de la IMC column store y sus iMCUs -  inmemory_query=enable
select display_name,value
from v$mystat m, v$statname n
where m.statistic# = n.statistic#
and display_name in (
  'IM scan segments minmax eligible',
  'IM scan CUs delta pruned',
  'IM scan segments disk',
  'IM scan bytes in-memory',
  'IM scan bytes uncompressed',
  'IM scan rows',
  'IM scan blocks cache'
);

pause Analizar resultados, [Enter ] para continuar
prompt mostrando nuevamete el plan de ejecución con el IMC store habilitada
explain plan
set statement_id ='q2' for
select /*+ gather_plan_statistics */ title, trunc(duration/60,1) duration_hr
from user03imc.movie
where upper(title) like '% WAR %';

prompt Mostrando el plan de ejecución
select * from table (
  dbms_xplan.display(
    statement_id => 'q2'
  )
);

pause Analizar el plan de ejecución [enter] para continuar
prompt Deshabilitar el uso de la IMC Store para hacer el script idempotente
alter table user03imc.movie no inmemory;

disconnect
