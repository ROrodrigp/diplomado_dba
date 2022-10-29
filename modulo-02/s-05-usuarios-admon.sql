define syslogon='sys/system1 as sysdba'
prompt Conectando como sysdba
connect &syslogon

prompt Creando usuario user01
grant create session, create table to user01 identified by user01;
alter user user01 quota unlimited on users;

grant create session to user02 identified by user02;
alter user user02 quota unlimited on users;

grant create session to user03 identified by user03;
alter user user03 quota unlimited on users;

prompt Otorgando privilegios de administración 
grant sysdba to user01;
grant sysoper to user01;

prompt Conectando como user01
connect user01/user01

prompt Mostrando usuario:
show user 

prompt Mostrando el esquema:
select sys_context('USERENV','CURRENT_SCHEMA') as schema from dual;

prompt Mostrando el esquema:
select sys_context('USERENV','AUTHENTICATION_METHOD') as auth_method from dual;

prompt Creando tabla e insertando datos 
create table test(id number);
insert into test values(1);
commit;

prompt Conectando como user01 as sysdba
connect user01/user01 as sysdba 

prompt Mostrando usuario:
show user 

prompt Mostrando el esquema:
select sys_context('USERENV','CURRENT_SCHEMA') as schema from dual;

prompt Mostrando el esquema:
select sys_context('USERENV','AUTHENTICATION_METHOD') as auth_method from dual;

prompt Mostrando los datos de la tabla test ¿se podrá? si se puede!
select * from user01.test;


prompt Conectando como user01 as sysoper
connect user01/user01 as sysoper 

prompt Mostrando usuario:
show user 

prompt Mostrando el esquema:
select sys_context('USERENV','CURRENT_SCHEMA') as schema from dual;

prompt Mostrando el esquema:
select sys_context('USERENV','AUTHENTICATION_METHOD') as auth_method from dual;

pause Mostrando los datos de la tabla test ¿se podrá? - se espera error
select * from user01.test;


prompt Otorgando privilegio para que cualquier usuario pueda leer los datos
prompt de la tabla test0
connect user01/user01
grant select on test to public;

Prompt Conectando como user02
connect user02/user02

Prompt consultando la tabla publica 
select * from user01.test;

Prompt Conectando como user03
connect user03/user03

Prompt consultando la tabla publica 
select * from user01.test;

prompt aplicando limpieza
connect sys/system1 as sysdba

drop user user01 cascade;
drop user user02 cascade;
drop user user03 cascade;

disconnect
