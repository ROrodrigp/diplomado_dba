prompt Autenticando como sysdba
connect sys/system2 as sysdba

prompt Iniciando en modo restringido
alter system enable restricted session;

prompt Creando al usuario user01
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;

prompt Intentado abrir sesion como user01
connect user01/user01

pause [Qué sucedió?, Enter para continuar]

prompt Asignando el privilegio restricted session a user01
connect sys/system2 as sysdba
grant restricted session to user01;

prompt Intentado crear sesión como user01
connect user01/user01
pause [Qué sucedió? Enter para continuar]

prompt Regresando al modo no restringido
connect sys/system2 as sysdba
alter system disable restricted session;

pause [Enter para continuar]
prompt Abrir en modo read only, primero detener la BD
--La BD tiene que detenerse antes de pasar a este modo.
shutdown immediate

prompt Abriendo la bd en modo read only
startup open read only;

prompt Conectando como user01, intentando crear una tabla 
connect user01/user01
create table test(id number);
pause [Qué sucedió? Enter para continuar]
 
prompt Regresando al modo de escritura y lectura
connect sys/system2 as sysdba
shutdown immediate
startup open read write;

prompt Haciendo limpieza, borrando a user01
drop user user01 cascade;

Prompt Listo! 
exit 
