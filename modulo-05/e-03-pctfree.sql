connect rodrigo05/rodrigo05
spool 'salida-e03.txt' replace;
whenever sqlerror exit rollback;

prompt Creando tabla con pctfree 0 
create table t02_random_str_0(
  str char(18) 
) pctfree 0;

prompt Creando tabla con pctfree 50
create table t02_random_str_50(
  str char(18) 
) pctfree 50;

pause [Enter] para continuar con la carga

declare
  v_str char(18);
begin
  v_str := rpad('A',18,'X');
  for v_index in 1..10000 loop
    insert into t02_random_str_0 values (v_str);
    insert into t02_random_str_50 values (v_str);
  end loop;
end;
/

commit;

prompt Consultando bloques y sus registros para t02_random_str_0
select dbms_rowid.rowid_relative_fno(rowid) as file_number, 
  dbms_rowid.rowid_block_number(rowid) as block_number,
  count(*) total_registros
from t02_random_str_0
group by dbms_rowid.rowid_relative_fno(rowid),
  dbms_rowid.rowid_block_number(rowid)
order by 1,2;

prompt Consultando bloques y sus registros para t02_random_str_50
select dbms_rowid.rowid_relative_fno(rowid) as file_number, 
  dbms_rowid.rowid_block_number(rowid) as block_number,
  count(*) total_registros
from t02_random_str_50
group by dbms_rowid.rowid_relative_fno(rowid),
  dbms_rowid.rowid_block_number(rowid)
order by 1,2;

spool off;
exit