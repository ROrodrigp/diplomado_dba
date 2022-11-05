prompt conectando como sysdba
connect sys/system2 as sysdba

prompt creando usuarios
create user user03_a1 identified by user03_a1 quota unlimited on users;
grant create session, create table to user03_a1;

create user user03_a2 identified by user03_a2 quota unlimited on users;
grant create session, create table to user03_a2;

create user user03_a3 identified by user03_a3 quota unlimited on users;
grant create session, create table to user03_a3;

prompt Asignando privilegio sysbackup a user03_a1
grant sysbackup to user03_a1;

prompt Abrir 2 terminales T1 y T2, autenticar en T1 como user03_a1
prompt en T2 autenticar como user03_a2, crear tabla y registro 
pause [Enter] al terminar

prompt Inactivando la BD. Que sucedera? Considerando las sesion en T1 y T2
pause [Enter] para continuar

alter system quiesce restricted;

prompt BD Inactiva
prompt Abrir una terminal T3, intentar autenticar con user03_a3
prompt Abrir una terminal T4, intentar autenticar con user03_a1 como sysbackup
pause Que sucedera? [Enter para continuar]

prompt Mostrando status de inactividad
select active_state from v$instance;

prompt Reactivando instancia 
pause Analizar terminales, comentar lo que suceder [Enter] para continuar
alter system unquiesce;

pause Cerrar sesiones para realizar limpieza [Enter] para continuar
drop user user03_a1 cascade;
drop user user03_a2 cascade;
drop user user03_a3 cascade;