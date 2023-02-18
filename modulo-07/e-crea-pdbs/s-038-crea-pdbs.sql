spool m07-e03-08.txt
prompt Creando un Application container 

prompt Detener rgpdip04
!sh s-030-stop-cdb.sh rgpdip04 system04

prompt Iniciar rgpdip03
!sh s-030-start-cdb.sh rgpdip03 system3 

prompt Conectando a rgpdip03
connect sys/system3@rgpdip03 as sysdba 

prompt Crear un application container rgpdip03_app_c1

create pluggable database rgpdip03_app_c1 as application container
  admin user admin identified by admin 
  file_name_convert=(
    '/u01/app/oracle/oradata/RGPDIP03/pdbseed',
    '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_app_c1'
);

prompt Abriendo rgpdip03_app_c1
alter pluggable database rgpdip03_app_c1 open read write;

prompt Conectando a rgpdip03_app_c1
alter session set container=rgpdip03_app_c1;

prompt Mostrando los datos del container 
show con_id 
show con_name

pause Analizar resultados [Enter] para continuar 

prompt Crear PDB rgpdip03_app_c1_s1

create pluggable database rgpdip03_app_c1_s1
  admin user admin identified by admin 
  file_name_convert=(
    '/u01/app/oracle/oradata/RGPDIP03/pdbseed',
    '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_app_c1/rgpdip03_app_c1_s1'
  );

prompt Abrir rgpdip03_app_c1_s1 
alter pluggable database rgpdip03_app_c1_s1 open read write;

prompt Realizar sync entre PDB y application container 
alter session set container=rgpdip03_app_c1_s1;
alter pluggable database application all sync;

prompt Crear un application rgpdip03_app_c1_app1
alter session set container=rgpdip03_app_c1;

alter pluggable database application rgpdip03_app_c1_app1 begin install '1.0';

prompt Creando objetos comunes 
prompt Creando un tablespace 
alter system set db_create_file_dest='/u01/app/oracle/oradata' scope=memory;
create tablespace app1_test01_ts
datafile size 1m autoextend on next 1m;

prompt Crear un usuario 
create user app1_test_user identified by rodrigo 
  default tablespace app1_test01_ts
  quota unlimited on app1_test01_ts
  container=all;

grant create session, create table, create procedure
  to app1_test_user;

prompt Crear una tabla 
create table app1_test_user.carrera(
  id number(10,0) constraint carrera_pk primary key, 
  nombre varchar2(50) 
);

prompt Insertando datos 
INSERT INTO app1_test_user.carrera (id, nombre) VALUES (1, 'Licenciatura en Administración');
INSERT INTO app1_test_user.carrera (id, nombre) VALUES (2, 'Ingeniería en Sistemas Computacionales');
INSERT INTO app1_test_user.carrera (id, nombre) VALUES (3, 'Licenciatura en Contaduría Pública');
commit; 

prompt Terminar de asociar objetos comunes 
alter pluggable database application rgpdip03_app_c1_app1 end install;

prompt Realizando sync 
alter session set container=rgpdip03_app_c1_s1;
alter pluggable database application rgpdip03_app_c1_app1 sync;

prompt Mostrando datos de objetos comunes 
select * from app1_test_user.carrera;

pause Revisar resultados, [Enter] para continuar 

prompt Creando nueva PDB rgpdip03_app_c1_s2
alter session set container=rgpdip03_app_c1;

create pluggable database rgpdip03_app_c1_s2
  admin user admin identified by admin 
  file_name_convert=(
    '/u01/app/oracle/oradata/RGPDIP03/pdbseed',
    '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_app_c1/rgpdip03_app_c1_s2'
  );

prompt Abrir rgpdip03_app_c1_s2
alter pluggable database rgpdip03_app_c1_s2 open read write;

prompt Mostrar los datos en rgpdip03_app_c1_s2 sin hacer un sync 
alter session set container=rgpdip03_app_c1_s2;
select * from app1_test_user.carrera;
pause Analizar resultados, [Enter] para continuar 

prompt Hacer sync en rgpdip03_app_c1_s2, mostrando datos 
alter pluggable database application rgpdip03_app_c1_app1 sync;

select * from app1_test_user.carrera;
pause Analizar resultados, [Enter] para continuar 

prompt Generando version 1.2 de rgpdip03_app_c1_app1
alter session set container=rgpdip03_app_c1;
alter pluggable database application rgpdip03_app_c1_app1 
  begin upgrade '1.0' to '1.1';

prompt Insertar un nuevo dato
insert into app1_test_user.carrera(id,nombre) values(4, 'Licenciatura en filosofia');

prompt Agregando una nueva columna 
alter table app1_test_user.carrera add total_creditos number;

prompt Agregando un procedimiento almacenado 
create or replace procedure app1_test_user.p_asigna_creditos(p_carrera_id number) is
begin
  update  app1_test_user.carrera set total_creditos = id+10
  where id = p_carrera_id;
end;
/ 
show errors 

prompt Marcar el final del upgrade 
alter pluggable database application rgpdip03_app_c1_app1 end upgrade;


prompt Revisar la nueva version 
alter session set container=rgpdip03_app_c1_s1;

prompt Hacer sync 
alter pluggable database application rgpdip03_app_c1_app1 sync;

prompt Invocando a procedimiento almacenado
pause ¿Qué pasará al modificar un registro a través del procedimiento? [Enter] ..
exec app1_test_user.p_asigna_creditos(1);
commit; 

prompt Mostrando datos de la tabla 
select  * from app1_test_user.carrera;

prompt Haciendo sync en rgpdip03_app_c1_s2
alter session set container=rgpdip03_app_c1_s2;
alter pluggable database application rgpdip03_app_c1_app1 sync;

prompt Mostrando datos desde rgpdip03_app_c1_s2
select * from app1_test_user.carrera;

pause Analizar resultados [Enter] para continuar 

prompt Consultas al DD 
alter session set container=rgpdip03_app_c1;

col app_name format a20
col app_version format a10 
col name format a30 
select app_name, app_version, app_status 
from dba_applications;

prompt datos de PDBs asociadas a un APP container 
select c.name, ap.app_name, ap.app_version, ap.app_status
from dba_app_pdb_status ap
join v$containers c on c.con_uid=ap.con_uid;

pause Analizar resultados [Enter] para realizar limpieza 

alter session set container=rgpdip03_app_c1;
alter pluggable database rgpdip03_app_c1_s1 close;
alter pluggable database rgpdip03_app_c1_s2 close;

drop pluggable database rgpdip03_app_c1_s1 including datafiles;
drop pluggable database rgpdip03_app_c1_s2 including datafiles;

alter pluggable database application rgpdip03_app_c1_app1 begin uninstall; 

drop tablespace app1_test01_ts including contents and datafiles;
drop user app1_test_user cascade;

alter pluggable database application rgpdip03_app_c1_app1 end uninstall; 

alter session set container=cdb$root;
alter pluggable database rgpdip03_app_c1 close;
drop pluggable database rgpdip03_app_c1 including datafiles;
