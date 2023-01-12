spool 'salida-e05.txt' replace;
prompt Consultando extensiones, conectando como sys 
connect sys/system2 as sysdba

begin
  execute immediate 'drop table rodrigo05.t04_ejemplo_extensiones';
exception
  when others then
    null;
end;
/

prompt Creando tabla de prueba
create table rodrigo05.t04_ejemplo_extensiones(
  str char(1024)
);

prompt Consultando extensiones 
set linesize window 

select segment_type, tablespace_name, file_id, extent_id, block_id, bytes/1024 extent_size_kb, blocks
from dba_extents
where segment_name = 'T04_EJEMPLO_EXTENSIONES'
and owner = 'RODRIGO05';

prompt Insertando 100 registros 
begin
  for v_index in 1..100 loop
    insert into RODRIGO05.T04_EJEMPLO_EXTENSIONES values ('A');
  end loop;
end;
/
commit;

prompt Mostrando datos de las extensiones despues de la insercion 

select segment_type, tablespace_name, file_id, extent_id, block_id, bytes/1024 extent_size_kb, blocks
from dba_extents
where segment_name = 'T04_EJEMPLO_EXTENSIONES'
and owner = 'RODRIGO05';

prompt Mostrando estado de los bloques 
set serveroutput on 
declare
  v_unformatted_blocks number;
  v_unformatted_bytes number;
  v_fs1_blocks number;
  v_fs1_bytes number;
  v_fs2_blocks number;
  v_fs2_bytes number;
  v_fs3_blocks number;
  v_fs3_bytes number;
  v_fs4_blocks number;
  v_fs4_bytes number;
  v_full_blocks number;
  v_full_bytes number;
begin
  dbms_space.space_usage(
      'RODRIGO05',
      'T04_EJEMPLO_EXTENSIONES',
      'TABLE',
      v_unformatted_blocks,
      v_unformatted_bytes,
      v_fs1_blocks,
      v_fs1_bytes,
      v_fs2_blocks,
      v_fs2_bytes,
      v_fs3_blocks,
      v_fs3_bytes,
      v_fs4_blocks,
      v_fs4_bytes,
      v_full_blocks,
      v_full_bytes
  );
  dbms_output.put_line('Mostrando valores de los bloques');
  dbms_output.put_line('v_unformatted_blocks = '||v_unformatted_blocks);
  dbms_output.put_line('v_unformatted_bytes = '||v_unformatted_bytes);
  dbms_output.put_line('v_fs1_blocks = '||v_fs1_blocks);
  dbms_output.put_line('v_fs1_bytes = '||v_fs1_bytes);
  dbms_output.put_line('v_fs2_blocks = '||v_fs2_blocks);
  dbms_output.put_line('v_fs2_bytes = '||v_fs2_bytes);
  dbms_output.put_line('v_fs3_blocks = '||v_fs3_blocks);
  dbms_output.put_line('v_fs3_bytes = '||v_fs3_bytes);
  dbms_output.put_line('v_fs4_blocks = '||v_fs4_blocks);
  dbms_output.put_line('v_fs4_bytes = '||v_fs4_bytes);
  dbms_output.put_line('v_full_blocks = '||v_full_blocks);
  dbms_output.put_line('v_full_bytes = '||v_full_bytes);
end;
/

prompt Eliminando los cien registros 
begin
  execute immediate 'truncate table rodrigo05.t04_ejemplo_extensiones';
exception
  when others then
    null;
end;
/

declare
  v_unformatted_blocks number;
  v_unformatted_bytes number;
  v_fs1_blocks number;
  v_fs1_bytes number;
  v_fs2_blocks number;
  v_fs2_bytes number;
  v_fs3_blocks number;
  v_fs3_bytes number;
  v_fs4_blocks number;
  v_fs4_bytes number;
  v_full_blocks number;
  v_full_bytes number;
begin
  dbms_space.space_usage(
      'RODRIGO05',
      'T04_EJEMPLO_EXTENSIONES',
      'TABLE',
      v_unformatted_blocks,
      v_unformatted_bytes,
      v_fs1_blocks,
      v_fs1_bytes,
      v_fs2_blocks,
      v_fs2_bytes,
      v_fs3_blocks,
      v_fs3_bytes,
      v_fs4_blocks,
      v_fs4_bytes,
      v_full_blocks,
      v_full_bytes
  );
  dbms_output.put_line('Mostrando valores de los bloques');
  dbms_output.put_line('v_unformatted_blocks = '||v_unformatted_blocks);
  dbms_output.put_line('v_unformatted_bytes = '||v_unformatted_bytes);
  dbms_output.put_line('v_fs1_blocks = '||v_fs1_blocks);
  dbms_output.put_line('v_fs1_bytes = '||v_fs1_bytes);
  dbms_output.put_line('v_fs2_blocks = '||v_fs2_blocks);
  dbms_output.put_line('v_fs2_bytes = '||v_fs2_bytes);
  dbms_output.put_line('v_fs3_blocks = '||v_fs3_blocks);
  dbms_output.put_line('v_fs3_bytes = '||v_fs3_bytes);
  dbms_output.put_line('v_fs4_blocks = '||v_fs4_blocks);
  dbms_output.put_line('v_fs4_bytes = '||v_fs4_bytes);
  dbms_output.put_line('v_full_blocks = '||v_full_blocks);
  dbms_output.put_line('v_full_bytes = '||v_full_bytes);
end;
/

spool off;
exit