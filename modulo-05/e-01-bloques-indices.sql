spool 'salida-e01.txt' create;
whenever sqlerror exit rollback

connect sys/system2 as sysdba

declare v_count number;
begin
  select count(*) into v_count
  from dba_users
  where username='RODRIGO05';
  if v_count > 0 then 
    execute immediate 'drop user rodrigo05 cascade';
  end if;
end;
/

prompt Creando usuario 
create user rodrigo05 identified by rodrigo05 quota unlimited on users;
grant create session, create table to rodrigo05;

connect rodrigo05/rodrigo05
create table t01_id (
  id number(10,0) constraint t01_id_pk primary key
);

prompt Insertando registro 1 
insert into t01_id values(1);

prompt Mostrando datos del indice 
set linesize window 
col table_name format a20
select index_type, table_name, UNIQUENESS, tablespace_name, status, blevel, DISTINCT_KEYS, leaf_blocks
from user_indexes
where index_name = 'T01_ID_PK';

pause Analizar resultados, presionar [Enter] para continuar 

prompt Recolectando estadisticas
begin
  dbms_stats.gather_index_stats(ownname => 'RODRIGO05', indname => 'T01_ID_PK');
end;
/

prompt Mostrando datos del indice despues de la recoleccion 
set linesize window 
col table_name format a20
select index_type, table_name, UNIQUENESS, tablespace_name, status, blevel, DISTINCT_KEYS, leaf_blocks
from user_indexes
where index_name = 'T01_ID_PK';

pause Analizar resultados

begin
  for v_index in 2..1000000 loop
    execute immediate 'insert into t01_id(id) values (:ph1)' using v_index;
  end loop;
  commit;
end;
/

prompt Recolectando estadisticas despues de la carga
begin
  dbms_stats.gather_index_stats(ownname => 'RODRIGO05', indname => 'T01_ID_PK');
end;
/

prompt Mostrando datos del indice despues de la carga 
set linesize window 
col table_name format a20
select index_type, table_name, UNIQUENESS, tablespace_name, status, blevel, DISTINCT_KEYS, leaf_blocks
from user_indexes
where index_name = 'T01_ID_PK';

spool off;
exit