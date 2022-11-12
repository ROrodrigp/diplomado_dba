prompt Configurando modo compartido 
connect sys/system2 as sysdba

prompt Configurando dispatcher
alter system set 
  dispatchers='(ADDRESS=(PROTOCOL=TCP)(PORT=5000))','(ADDRESS=(PROTOCOL=TCP)(PORT=5001))'
  scope = both;

prompt Configurando 3 shared servers
alter system set shared_servers=3 scope=both;

prompt Configurando DRCP
prompt Habilitando el pool existente por default 
-- se usa exec para ejecutar un procedimiento plsql desde sql
exec dbms_connection_pool.start_pool();

prompt Configurando pool servers minimos
exec dbms_connection_pool.alter_param('','MINSIZE','5');

prompt Configurando el numero maximo de pool servers existentes en el pool 
exec dbms_connection_pool.alter_param('','MAXSIZE','10');

prompt Configurando tiempo de vida maximo en el poo 
exec dbms_connection_pool.alter_param('','INACTIVITY_TIMEOUT','3600');

prompt Configurando tiempo de inactividad en el cliente
exec dbms_connection_pool.alter_param('','MAX_THINK_TIME','300');

prompt Avisando al listener la nueva configuracion
alter system register;

prompt Mostrando los servicios del listener nuevamente 
!lsnrctl services

pause Analizar resultados [Enter] para reiniciar

shutdown immediate
startup 

alter system register;
prompt Revisando servicios del listener despues del reinicio 
!lsnrctl services

prompt Abrir tnsnames.ora, agregar los 3 alias para la conexion con los 3 modos
pause [Enter] al terminar

prompt Probando modo dedicado 
connect sys/system2@rgpdip02_dedicated as sysdba
select server from v$session where username='SYS';

prompt Probando modo DRCP 
connect sys/system2@rgpdip02_pooled as sysdba
select server from v$session where username='SYS';

prompt Probando modo compartido 
connect sys/system2@rgpdip02_shared as sysdba
select server from v$session where username='SYS';

prompt Revisando servicios del listener 
!lsnrctl services

pause Analizar resultados [Enter] para continuar

select circuit, dispatcher, status, bytes/1024 kbs from v$circuit;

--No hay limpieza--