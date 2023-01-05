whenever sqlerror exit rollback;
spool 'salida-e04.txt' replace;
connect sys/system2 as sysdba 

prompt Mostrando el contenido del parametro db_block_size
show parameter db_block_size

prompt Conectando como rodrigo05 para generar una tabla grande 
connect rodrigo05/rodrigo05

begin 
  execute immediate 'drop table t03_row_chaining';
exception
  when others then 
    null;
end;
/

create table t03_row_chaining(
  id number(10,0) constraint t03_row_chaining_pk primary key,
  c1 char(2000) default 'A',
  c2 char(2000) default 'B',
  c3 char(2000) default 'C',
  c4 char(2000) default 'D',
  c5 char(2000) default 'E'
);

prompt Insertando un primer regisro 
insert into t03_row_chaining(id) values(1);

commit;

prompt mostrando el tamaño de la columna c1
select length(c1)
from t03_row_chaining
where id = 1;

prompt Actualizando estadisticas 
analyze table t03_row_chaining compute statistics;

prompt Consultando metadatos
set linesize window
select tablespace_name, pct_free, pct_used, num_rows, blocks, empty_blocks, 
  avg_space/1024 avg_space_kb, chain_cnt, avg_row_len/1024 avg_row_len_kb
from user_tables
where table_name = 'T03_ROW_CHAINING';

pause [Enter] para corregir el problema

prompt Creando un nuevo tablespace con bloques de 16K, conectando  como sys
connect sys/system2 as sysdba

alter system set db_16k_cache_size=10M scope = memory;

begin 
  execute immediate 'drop tablespace dip_m05_01 including contents and datafiles';
exception
  when others then 
    null;
end;
/

create tablespace dip_m05_01
blocksize 16K
datafile '/u01/app/oracle/oradata/RGPDIP02/dip_m05_01_01.dbf'
size 20m 
extent management local uniform size 1M;

prompt Otorgando cuota de almacenamiento al usuario rodrigo05 en el nuevo tablespace
alter user rodrigo05 quota unlimited on dip_m05_01;

prompt moviendo datos al nuevo TS, conectando como rodrigo05
connect rodrigo05/rodrigo05
alter table t03_row_chaining move tablespace dip_m05_01;

prompt reconstruyendo el indice (por efectos del cambio de TS)
alter index t03_row_chaining_pk rebuild;

prompt Actualizando estadisticas nuevamente
analyze table t03_row_chaining compute statistics;

prompt Consultando metadatos nuevamente 
set linesize window 
select tablespace_name, pct_free, pct_used, num_rows, blocks, empty_blocks, 
  avg_space/1024 avg_space_kb, chain_cnt, avg_row_len/1024 avg_row_len_kb
from user_tables
where table_name = 'T03_ROW_CHAINING';

Pause Analizar [Enter] para continuar

prompt Mostrando el DDL de la tabla modificada
set heading off
set echo off 
set pages 999
set long 90000
select dbms_metadata.get_ddl('TABLE','T03_ROW_CHAINING','RODRIGO05')
from dual;

pause Prueba terminada, presionar [Enter] para hacer limpieza 
connect sys/system2 as sysdba
prompt Eliminando tabla t03_row_chaining
drop table t03_row_chaining;

prompt Eliminando TS
drop tablespace dip_m05_01 including contents and datafiles;

spool off;
exit