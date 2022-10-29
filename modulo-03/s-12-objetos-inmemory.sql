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
)

pause Analizar el plan de ejecución [enter] para continuar

prompt Habilitando In Memory column store para la table movie 
alter table user03imc.movie inmemory;

prompt Mostrando configuracion IM Column store 
select table_name, inmemory, inmemory_compression, inmemory_priority
from dba_tables
where table_name='MOVIE'
and owner = 'USER03IMC';

pause Analizar el plan de ejecución [enter] para continuar
prompt Consultando segmentos de la tabla movie