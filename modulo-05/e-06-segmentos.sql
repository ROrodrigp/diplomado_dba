prompt Explorando segmentos
spool 'salida-e06.txt' create;
connect rodrigo05/rodrigo05

begin
  execute immediate 'drop table rodrigo05.empleado';
exception
  when others then
    null;
end;
/

create table empleado(
  empleado_id number(10,0) constraint empleado_pk primary key,
  curp varchar2(18) constraint empleado_curp_uk unique,
  email varchar2(100), 
  foto blob,
  cv clob,
  perfil varchar2(4000)
) segment creation immediate;

prompt Creando un indice explicito
create index empleado_email_ix on empleado(email);

prompt mostrando los segmentos asociados con esta tabla

set linesize window
col segment_name format A30
select tablespace_name, segment_name, segment_type, blocks, extents
from user_segments
where segment_name like '%EMPLEADO%';

prompt mostrando los datos de user_lobs

col index_name format A30
col column_name format A30 
select tablespace_name, segment_name, index_name, column_name
from user_lobs
where table_name = 'EMPLEADO';

spool off;
exit