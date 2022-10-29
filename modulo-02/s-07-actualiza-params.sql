prompt Actualizando parametros 
prompt Conectando como sysdba
connect sys/system1 as sysdba

prompt Realizando un respaldo 
create pfile from spfile;

prompt Modificando el valor de nls_date_format
prompt Nivel sesion : OK 
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

prompt Nivel memory: Se espera error 
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss' scope=memory;

prompt Nivel spfile: OK 
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss' scope=spfile;

prompt nivel spfile y memory: ERROR 
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss' scope=both;


Prompt modificando el valor para db_domain 
prompt Nivel sesion : ERROR 
alter session set db_domain='diplomado.fi.unam.mx';

prompt Nivel memory: ERROR 
alter system set db_domain='diplomado.fi.unam.mx' scope=memory;

prompt Nivel spfile: OK 
alter system set db_domain='diplomado.fi.unam.mx'  scope=spfile;

prompt nivel spfile y memory: ERROR 
alter system set db_domain='diplomado.fi.unam.mx' scope=both;


Prompt Modificando el valor para deferred_segment_creation
prompt Nivel sesion : OK
alter session set deferred_segment_creation=false;

prompt Nivel memory: OK
alter system set deferred_segment_creation=false scope=memory;

prompt nivel spfile y memory: OK
alter system set deferred_segment_creation=false scope=both;


prompt limpieza
prompt Para el parametro nls_date_format
alter system reset nls_date_format scope=spfile;

prompt Para db_domain
alter system set db_domain='fi.unam' scope=spfile;

prompt Para deferred_segment_creation
alter system reset deferred_segment_creation scope=both;
