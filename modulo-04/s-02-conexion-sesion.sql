prompt Conectando como sysdba
connect sys/system2 as sysdba

prompt Creando user04
create user user04 identified by user04 quota unlimited on users;
grant create table, create session to user04;

Pause Iniciar sesión en T2 como user04 [Enter] para continuar

prompt Mostrando datos de las sesiones de user04
col username format a30 
select username, sid, serial#, server, paddr, status
from v$session where username='USER04';

pause Analizar resultados, [Enter] para continuar

prompt Configurando el rol plustrace 
@?/sqlplus/admin/plustrce.sql

grant plustrace to user04;

prompt En T2, cerrar sesión, volver a iniciar y habilitar autotrace
pause [Enter] al terminar

prompt Mostrando nuevamente las sesiones del USER04
pause Qué se obtendrá? [Enter]
select username, sid, serial#, server, paddr, status
from v$session where username='USER04';

pause Analizar resultados, [Enter] para continuar

prompt En T2, cerrar sesión de user04, manatener conexion (ejecutar disconnect)
pause [Enter] al terminar

prompt Mostrando sesiones nuevamente, la sesion user04 ya no debería existir
select username, sid, serial#, server, paddr, status
from v$session where username='USER04';

pause Analizar resultados, [Enter] para continuar

prompt Mostrando los datos del server process que en teoria debe seguir existiendo
prompt Indicar el valor del address del proceso que se muestra en la sesión de USER04
select sosid, username, program
from v$process
where addr=hextoraw('&p_addr');