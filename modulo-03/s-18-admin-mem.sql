prompt Conectando como sys
connect sys/system2 as sysdba

/*
Consultas obtenidas


*/





 





prompt Configurando administracion Automatic shared memory management

alter system set memory_target=0 scope=spfile;

--total_sga_1 + inmemory
alter system set sga_target=600M scope=spfile;
--pga_reservada_max
alter system set pga_aggregate_target=300M scope=spfile;

alter system set shared_pool_size=0 scope=spfile;
alter system set target_pool_size=0 scope=spfile;
alter system set java_pool_size=0 scope=spfile;
alter system set db_cache_size=0 scope=spfile;
alter system set streams_pool_size=0 scope=spfile;

prompt Reiniciando instancia para probar metodo semiautomatico 
pause [Enter ] para reiniciar
shutdown immediate
startup 

Prompt mostrando valores de parametros

Prompt mostrando parametros modo Automatic Shared Memory Management
select (
  select value/1024/1024 from v$spparameter where name='memory_target'
) memory_target, (
  select value/1024/1024 from v$spparameter where name='memory_max_target'
) memory_max_target, (
  select value/1024/1024 from v$spparameter where name='sga_target'
) sga_target, (
  select value/1024/1024 from v$spparameter where name='pga_aggregate_target'
) pga_aggregate_target, (
  select value/1024/1024 from v$spparameter where name='shared_pool_size'
) shared_pool_size (
  select value/1024/1024 from v$spparameter where name='large_pool_size'
) large_pool_size, (
  select value/1024/1024 from v$spparameter where name='java_pool_size'
) java_pool_size, (
  select value/1024/1024 from v$spparameter where name='db_cache_size'
) db_cache_size, (
  select value/1024/1024 from v$spparameter where name='streams_pool_size'
) streams_pool_size
from dual;

prompt Agregando un nuevo registro a la tabla de valores de memoria 
@s-14-monitor-mem.sql

pause analizar los resultados, [Enter] para continuar 

prompt Realizar configuracion Manual shared memory management

--parametros en cero 
alter system set memory_target=0 scope=spfile;
alter system set sga_target=0 scope=spfile;

--pga_reservada_max (Conservamos configuracion para PGA)
alter system set pga_aggregate_target=300M scope=spfile;

alter system set shared_pool_size=292M scope=spfile;
alter system set target_pool_size=20M scope=spfile;
alter system set java_pool_size=4M scope=spfile;
alter system set db_cache_size=68M scope=spfile;
alter system set streams_pool_size=0 scope=spfile;

prompt Reiniciando instancia para probar metodo manual  
pause [Enter ] para reiniciar
shutdown immediate
startup 

Prompt mostrando valores de parametros

Prompt mostrando parametros modo Manual Shared Memory Management
select (
  select value/1024/1024 from v$spparameter where name='memory_target'
) memory_target, (
  select value/1024/1024 from v$spparameter where name='memory_max_target'
) memory_max_target, (
  select value/1024/1024 from v$spparameter where name='sga_target'
) sga_target, (
  select value/1024/1024 from v$spparameter where name='pga_aggregate_target'
) pga_aggregate_target, (
  select value/1024/1024 from v$spparameter where name='shared_pool_size'
) shared_pool_size (
  select value/1024/1024 from v$spparameter where name='large_pool_size'
) large_pool_size, (
  select value/1024/1024 from v$spparameter where name='java_pool_size'
) java_pool_size, (
  select value/1024/1024 from v$spparameter where name='db_cache_size'
) db_cache_size, (
  select value/1024/1024 from v$spparameter where name='streams_pool_size'
) streams_pool_size
from dual;

prompt Agregando un nuevo registro a la tabla de valores de memoria 
@s-14-monitor-mem.sql

prompt Restaurando modo Automatico
alter system set memory_target=768M scope=spfile;

prompt reset de parametros
alter system reset sga_target scope=spfile;
alter system reset pga_aggregate_target scope=spfile;
alter system reset shared_pool_size scope=spfile;
alter system reset target_pool_size scope=spfile;
alter system reset java_pool_size scope=spfile;
alter system reset db_cache_size scope=spfile;
alter system reset streams_pool_size scope=spfile;

prompt Reiniciando instancia para probar metodo automatic  
pause [Enter ] para reiniciar
shutdown immediate
startup 

Prompt mostrando valores de parametros

Prompt mostrando parametros modo Automatic Shared Memory Management
select (
  select value/1024/1024 from v$spparameter where name='memory_target'
) memory_target, (
  select value/1024/1024 from v$spparameter where name='memory_max_target'
) memory_max_target, (
  select value/1024/1024 from v$spparameter where name='sga_target'
) sga_target, (
  select value/1024/1024 from v$spparameter where name='pga_aggregate_target'
) pga_aggregate_target, (
  select value/1024/1024 from v$spparameter where name='shared_pool_size'
) shared_pool_size (
  select value/1024/1024 from v$spparameter where name='large_pool_size'
) large_pool_size, (
  select value/1024/1024 from v$spparameter where name='java_pool_size'
) java_pool_size, (
  select value/1024/1024 from v$spparameter where name='db_cache_size'
) db_cache_size, (
  select value/1024/1024 from v$spparameter where name='streams_pool_size'
) streams_pool_size
from dual;

prompt Agregando un nuevo registro a la tabla de valores de memoria 
@s-14-monitor-mem.sql