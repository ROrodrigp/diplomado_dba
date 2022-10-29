
define syslogon='sys/system1 as sysdba'
prompt Conectando como sysdba
connect &syslogon

prompt Creando un user profile 
create profile session_limit_profile limit
  sessions_per_user 2
;

prompt Creando usuario user01
create user user01 identified by user01 profile session_limit_profile;
grant create session to user01;

pause Abrir 3 terminales y validar el user profile [Enter ] para continuar. No cerrarlas

prompt Consultando sesiones del usuario user01
col username format  A30
select sid, serial#, username, schemaname, status
from v$session
where username='USER01';

pause [Enter] Cerrar terminales antes de realizar limpieza para realizar limpieza
drop user user01;
drop profile session_limit_profile;
