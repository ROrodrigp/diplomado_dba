define syslogon='sys/system2 as sysdba'
define test_user='rodrigo05'
set verify off 
set linesize window 

connect &syslogon

prompt 1. Mostrando tablespace undo en uso 
-------------------------------------------
show parameter undo_tablespace

pause [Enter] para continuar

prompt 2. Creando un nuevo tablespace
-------------------------------------------
set serveroutput on 
declare
  v_count number;
begin 
  select count(*) into v_count
  from dba_tablespaces
  where tablespace = 'UNDOTBS2';
  if v_count > 0 then
    dbms_output.put_line('Eliminando undotbs2');
    execute immediate
      'alter system set undo_tablespace=''undotbs1'' scope=memory';
    execute immediate
      'drop tablespace undotbs2 including contents and datafiles';
  end if;
end;
/

create undo tablespace undotbs2
datafile '/u01/app/oracle/oradata/RGPDIP02/undotbs_2.dbf'
size 30M
autoextend off 
extent management local autollocate;

prompt 3. Configurando el nuevo TS undo 
-------------------------------------------
alter system set undo_tablespace='undotbs2' scope=memory;

prompt 4. Mostrar nuevamente el parametro undo_tablespace
-------------------------------------------
show parameter undo_tablespace
pause Analizar resultado [Enter] para continuar

prompt 5. Mostrando estadisticas de los datos undo 
-------------------------------------------
alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';

select * from 
(select begin_time, end_time, undotsn, undoblks, txncount, maxqueryid,maxquerylen,
  activeblks, unexpiredblks, expiredblks, tuned_undoretention, tuned_undoretention/60 tuned_undo_min
from v$undostat
order by begin_time desc;
) where rownum <= 20; 

pause 6. Analizar resultados, contestar preguntas [Enter] para continuar 
-------------------------------------------
prompt 7. Mostrando nombres de los dba_tablespaces
select * from
(
  select u.begin_time, u.end_time, u.undotsn, t.name 
  from v$undostat, v$tablespace t
  where u.undotsn = t.ts#
  order by u.begin_time desc 
) where rownum <= 20;

pause Analizar resultados, [Enter] para continuar

prompt 8. Mostrar los datos del nuevo TS
-------------------------------------------
select df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2) as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

pause Analizar resultados [Enter] para continuar 
prompt 9. Creacion y poblado de tabla  en el esquema  del usuario el modulo 
-------------------------------------------
declare
  v_count number;
begin 
  --check sequence 
  select count(*)
  into v_count
  from all_sequence 
  where sequence_name  = 'SEC_RANDOM_STR_2'
  and sequence_owner = upper('&test_user');

  if v_count > 0 then 
    execute immediate 'drop sequence &test_user..sec_random_str_2';
  end if;
  --check table 
  select count(*)
  into v_count
  from all_tables
  where table_name = 'RANDOM_STR_2'
  and owner = upper('&test_user');
  if v_count > 0 then
    execute immediate 'drop table &test_user..random_str_2 purge';
  end if;

  create table &test_user..random_str_2 (
    id number, 
    cadena varchar2(1024)
  ) nologging;

  create sequence &test_user..sec_random_str_2;

  prompt secuencias actuales de redologs 
  select group#, thread#, sequence#, bytes/1024/1024 size_mb
  from v$log; 

  pause [Enter] para comenzar el poblado de la tabla 

  
end;
/