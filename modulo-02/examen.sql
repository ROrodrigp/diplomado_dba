connect sys/system1 as sysdba

prompt creando usuario 
create user usutestragp identified by usutestragp;
alter user usutestragp quota 2G on users;

prompt creando el rol 
create role role_admin;
grant create session, create table to role_admin;

prompt asignando rol 
grant role_admin to usutestragp with admin option;

prompt conectando como usuario creado 
connect usutestragp/usutestragp

prompt cambiando contrasena
alter user usutestragp identified by ragp;

prompt creando la tabla 
create table alumno(id number, nombreAlumno varchar(40));

prompt insertando registro 
insert into alumno values(1, 'Rodrigo Alan Garcia Perez');
commit;

prompt mostrando contenido tabla 
select * from alumno;

prompt aplicando limpieza
connect sys/system1 as sysdba

prompt eliminando todo 
drop user usutestragp cascade;
drop role role_admin;
