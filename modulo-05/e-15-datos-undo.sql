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