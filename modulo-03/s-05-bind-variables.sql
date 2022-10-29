connect sys/system2 as sysdba 

prompt Creando usuario user01
create user user01 identified by user01 quota unlimited on users;

grant create table, create session to user01;

prompt Creando tabla de prueba
create table user01.test(id number) segment creation immediate;

prompt Remueve informacion del shared_pool
alter system flush shared_pool;

prompt Habilitando conteo de tiempo 
set timing on

prompt 1. Sentencia sql con bind variables 
begin
    for i in 1..100000 loop
        execute immediate 'insert into user01.test (id) values (:ph1)' using i;
    end loop;
end;
/

prompt Mostrando datos de la secuencia con bind variables 
select executions,
    loads, parse_calls,
    disk_reads, buffer_gets,
    cpu_time/1000 cpu_time_ms,
    elapsed_time/1000 elapsed_time_ms
from v$sqlstats
where sql_text = 'insert into user01.test (id) values (:ph1)';

prompt 2. Sentencia sql sin bind variables 
begin
    for i in 1..100000 loop
        execute immediate 'insert into user01.test (id) values ('||i||')';
    end loop;
end;
/

prompt Mostrando datos de la secuencia sin bind variables 
select count(*) t_rows, sum(executions) executions,
    sum(loads) loads, sum(parse_calls) parse_calls,
    sum(disk_reads) disk_reads, sum(buffer_gets) buffer_gets,
    sum(cpu_time)/1000 cpu_time_ms,
    sum(elapsed_time)/1000 elapsed_time_ms
from v$sqlstats
where sql_text like 'insert into user01.test (id) values (%)'
and sql_text <> 'insert into user01.test (id) values (:ph1)';


set timing off

prompt limpieza 
connect sys/system2 as sysdba
drop user user01 cascade;

