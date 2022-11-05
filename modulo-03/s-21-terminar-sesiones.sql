prompt conectando como sysdba
connect sys/system2 as sysdba


prompt Mostrando status de inactividad
select active_state from v$instance;

prompt Eliminando sesiones que impiden inactivar 
pause Cuantas sesiones deberan terminarse? [Enter] para continuar 
set serveroutput on 

declare
  cursor cur_sessiones is 
    select s.sid, s.serial#, s.username
    from v$session s, v$blocking_quiesce b
    where s.sid = b.sid;
begin
  for r in cur_sessiones loop
    dbms_output.put_line('Cerrando sesion para el usuario '||r.username);
    execute immediate 'alter system kill session '''||r.sid||','||r.serial#||'''';
  end loop;
end;
/