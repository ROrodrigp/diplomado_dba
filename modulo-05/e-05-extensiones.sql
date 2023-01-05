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