prompt Autenticando como sysdba
connect sys/system2 as sysdba

prompt Creando al usuario user01
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;

prompt Creando al usuario user02
create user user02 identified by user02 quota unlimited on users;
grant create session, create table to user02;


pause Abre una terminal e inicia sesion como user01, [Enter] para continuar

prompt Iniciando en modo restringido
pause Será posible pasar a modo restringido con user01 en sesión, [Enter] para continuar
alter system enable restricted session;

pause En caso afirmativo crear una tabla de prueba e insertar 1 registro, hacer commit. ¿Qué sucederá? [Enter] para continuar

prompt Intentado autenticar como user02
pause Qué sucederá? [Enter ] para continuar

connect user02/user02

prompt Asignando el privilegio restricted session a user02
connect sys/system2 as sysdba
grant restricted session to user02;

prompt Intentado crear sesión como user02
connect user02/user02
pause [Qué sucedió? Enter para continuar]

prompt Regresando al modo no restringido
connect sys/system2 as sysdba
alter system disable restricted session;

pause [Enter para continuar]
prompt Abrir en modo read only, primero detener la BD
--La BD tiene que detenerse antes de pasar a este modo.
shutdown immediate

prompt Abriendo la bd en modo read only
pause  ¿será posible iniciar en modo read only con el usuario user01 previamente conectado?
startup open read only;
pause Qué sucedio?

prompt Conectando como user02, 
connect user02/user02
pause [Qué sucedió? Enter para continuar]
 
prompt Regresando al modo de escritura y lectura
connect sys/system2 as sysdba
shutdown immediate
startup open read write;

prompt Haciendo limpieza, borrando a user01
drop user user01 cascade;
drop user user02 cascade;
Prompt Listo! 
exit 
