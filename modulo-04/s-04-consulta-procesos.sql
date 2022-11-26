connect sys/system2 as sysdba

prompt Mostrando total de procesos de existentes en la instancia
select count(*) total_procesos from v$process;

prompt Mostrando el total de procesos que no son de background 
select count(*) no_background from v$process
where background is null;

prompt Mostrando el total de procesos de background 
select count(*) background from v$process
where background = 1;

prompt Mostrando los datos de la session de SQL Developer
select * from v$session where program = 'SQL Developer' and type = 'USER';

prompt Empleando el resultado anterior, mostrar los datos del proceso asociado 
prompt a la sesion creada en SQL Developer 
select p.* from v$process p, v$session s
where p.addr = s.paddr
and s.program = 'SQL Developer' and s.type = 'USER';

prompt Mostrando datos de monitoreo 
select h.*
from v$active_session_history h, v$session s
where h.session_id = s.sid
and s.program = 'SQL Developer' and s.type = 'USER';
