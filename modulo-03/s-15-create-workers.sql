prompt Autenticando como sysdba
connect sys/system2 as sysdba 

set server output on 
prompt Creando usuarios

declare
  v_num_users number :=5;
  v_user_prefix varchar2(20) := 'WORKER_03_';
  v_user_name varchar2(20);
  cursor cur_usuario is 
    select username from all_users where username like v_user_prefix||'%';
begin
  --Realizando limpieza 
  for r in cur_usuario loop
    execute immediate 'drop user '||r.username||' cascade';
  end loop;

  ---


  
end;
/