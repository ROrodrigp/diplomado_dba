connect sys/system1 as sysdba

prompt creando usuario 
create user user_test identified by test1234;

prompt otorgando privilegios
grant create session, create table to user_test;

prompt otorgando rol 
grant role sysdba to user_test;

prompt conectando como user_test
connect user_test/test1234

prompt mostrando usuario 
show user

prompt creando tabla 
create table tabla1(id_tabla numeric);

prompt ingresando dato 
insert into tabla1 values(1);
commit;

prompt ejecutando instruccion
connect user_test/test1234 as sysdba

prompt mostrando contenido tabla 
select * from tabla1

prompt Se mostrara el contenido de la tabla 

prompt eliminando todo 
connect sys/system1 as sysdba
drop user user_test cascade;
