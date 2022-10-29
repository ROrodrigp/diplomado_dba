prompt conectando como sysdba(sys)
--No poner password en ambientes productivos/testing
connect sys/system1 as sysdba

prompt Creando usuario rodrigo02
create user rodrigo02 identified by rodrigo02 quota unlimited on users;

prompt asignando privilegios de sistema
grant create table, create session to rodrigo02;

prompt conectand como rodrigo02
connect rodrigo02/rodrigo02

prompt creando tabla de prueba
create table test01(id number);

prompt conectando como sys 
connect sys/system1 as sysdba

prompt mostrando los privilegios del usuario
col grantee format A30
select grantee, privilege, admin_option
from dba_sys_privs
where grantee='RODRIGO02';

prompt haciendo limpieza 
drop user rodrigo02 cascade;
