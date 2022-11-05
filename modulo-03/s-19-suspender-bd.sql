prompt Conectando como sys
connect sys/system2 as sysdba

prompt Creando usuarios
create user user03_s1 identified by user03_s1 quota unlimited on users;
grant create session, create table to user03_s1;

pause [Enter] para comenzar con el reincio 
shutdown immediate
startup 

prompt Abrir terminal T1 y entrar como user03_s1
pause [Enter ] al terminar 

prompt Suspendiendo instancia 
pause Qué sucederá considerando que hay una sesión en T1? [Enter] para continuar
alter system suspend;

prompt Salir de sesión en T1, intentar autenticar nuevamente y crear una tabla 
pause Qué sucederá?, considerar que la BD esta suspendida [Enter] para continuar

prompt Mostrando el estatus de suspensión
select database_status from v$instance;

prompt Terminando  estatus de suspensión
pause Qué sucederá? considerando que en T1 hay sesión (posiblemente)
alter system resume;

prompt Mostrando estatus de suspensión nuevamente
select database_status from v$instance;

prompt Limpieza, salir de la sesión en T1 de ser necesario
pause [Enter ] para continuar
drop user user03_s1 cascade;