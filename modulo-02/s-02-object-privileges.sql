prompt Conectando como sysdba 
connect sys/system1 as sysdba

prompt Creando usuarios
create user user01 identified by user01 quota unlimited on users;
create user guest01 identified by guest01 quota unlimited on users;

prompt Otorgando privilegios de sistema 
grant create table, create session to user01;
grant create session to guest01;

prompt Creando al usuario guest02 otorgando privilegios al mismo tiempo
grant create session to guest02 identified by guest02;
alter user guest02 quota 10M on users;

prompt Permitir a el usuario guest02 la posibilidad de otorgar privilegios de objeto 
prompt a cualquier usuario 
grant grant any object privilege to guest02;

prompt Conectando como user01
connect user01/user01

prompt Creando tabla de prueba
create table test(id number);
insert into test values(1);
commit;

prompt conectando como guest01
connect guest01/guest01

prompt Intentar consultar datos de la tabla test
pause ¿Qué sucedera si se intenta acceder a user01.test? [enter]
select * from user01.test;

prompt Otorgando privilegio de objeto(select) a guest01

prompt conectando como user01
connect user01/user01

grant select on test to guest01;

prompt conectando como guest01 para validar acceso 
connect guest01/guest01
pause ¿Qué sucedera ahoram el usuario guest01 podra acceder a la tabla user01.test? [enter]
select * from user01.test;

prompt conectando como guest02
connect guest02/guest02 
grant insert on user01.test to guest01;

prompt Comprobando privilegio de insercion para guest01
connect guest01/guest01
pause ¿Será posible insertar en user01.test ?
insert into user01.test (id) values (2);
select * from user01.test;

prompt limpieza;
connect sys/system1 as sysdba
drop user user01 cascade;
drop user guest01;
drop user guest02;

disconnect

