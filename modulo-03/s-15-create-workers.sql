prompt Autenticando como sysdba
connect sys/system2 as sysdba 

set server output on 
prompt Creando usuarios

declare
  v_num_users number :=5;
  v_user_prefix varchar2(20) := 'WORKER_M03_';
  v_user_name varchar2(20);
  cursor cur_usuario is 
    select username from all_users where username like v_user_prefix||'%';
begin
  --Realizando limpieza 
  for r in cur_usuario loop
    execute immediate 'drop user '||r.username||' cascade';
  end loop;

  --- creando workers
  for i in 1..v_num_users loop
    v_user_name := v_user_prefix||i;
    dbms_output.put_line('Creando worker '||v_user_name);
    execute immediate 
      'create user '
      ||v_user_name
      ||' identified by '
      ||v_user_name
      ||' quota unlimited on users'
    ;
    execute immediate 'grant create session, create table, create job,
      create procedure, create sequence to '||v_user_name;
  end loop;  
end;
/


prompt Invocando la creacion de objetos para cada worker

define p_user=WORKER_M03_1
@s-16-create-worker-objects.sql

--con parametros seria:
-- se quita define y solo se agrega
--@s-16-create-worker-objects.sql

define p_user=WORKER_M03_2
@s-16-create-worker-objects.sql

define p_user=WORKER_M03_3
@s-16-create-worker-objects.sql