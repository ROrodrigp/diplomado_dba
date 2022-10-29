prompt Autenticando como sys 
connect sys/system2 as sysdba

whenever sqlerror exit rollback

--Asignar al parametro inmemory_size un valor de por lo menos 100M
prompt Alterando parametro inmemory_size
alter system set inmemory_size = 100M scope=spfile;

--Detener y reiniciar la base de datos
prompt Reiniciando base de datos
shutdown immediate
startup 

--Revisar el parametro inmemory_size para comprobar que coincida con el valor establecido 
prompt Mostrando parametro inmemory_size
show parameter inmemory_size

--Elimina al usuario user03imc en caso de exisiter 
declare
  v_count number;
begin
  select count(*) into v_count
  from dba_users
  where username = 'USER03IMC';
  if v_count>0 then 
    execute immediate 'drop user user03imc cascade';
  end if;
end;
/

prompt Creando usuario user03imc 
create user user03imc identified by user03imc quota unlimited on users;
grant create session, create table to user03imc;

prompt Iniciando sesion como user03imc
connect user03imc/user03imc

prompt Creando tabla movie 
create table movie(
  id number,
  title varchar2(4000),
  m_year number(4,0),
  duration number(10,2),
  budget number,
  rating number(5,2),
  votes number(10),
  r1 number(10,2),
  r2 number(10,2),
  r3 number(10,2),
  r4 number(10,2),
  r5 number(10,2),
  r6 number(10,2),
  r7 number(10,2),
  r8 number(10,2),
  r9 number(10,2),
  r10 number(10,2),
  mpaa varchar2(50),
  m_action number(1,0),
  comedy number(1,0),
  drama number(1,0),
  Documentary number(1,0),
  romance number(1,0),
  short number(1,0)
);

pause ejecutar script s-11-movie-carga-inicial.sql [enter] para continuar
set feedback off
@@s-11-movie-carga-inicial.sql
set feedback on

prompt Contando registros, se esperan 58788
select count(*)
from movie;

pause Revisar resultados [enter] para hacer commit

prompt Haciendo commit 
commit;
prompt Listo!