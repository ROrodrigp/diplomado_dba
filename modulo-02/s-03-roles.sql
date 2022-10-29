prompt conectando como sysdba
connect sys/system1 as sysdba

prompt creando roles 
create role web_admin_rol;
create role web_root_rol;

prompt asignando los privilegios a web_admin_rol
grant create session, create table, create sequence to web_admin_rol;

prompt asignar los privilegios de web_admin_rol a web_root_rol
grant web_admin_rol to web_root_rol;

prompt Creando al usuario j_admin
create user j_admin identified by j_admin;

prompt Otorgando rol 
grant web_admin_rol to j_admin with admin option;

prompt conectando como j_admin
pause ¿Será posible conectarse como j_admin?
connect j_admin/j_admin

prompt Conectando como sys 
connect sys/system1 as sysdba

prompt Creando al usuario j_os_admin
create user j_os_admin identified by j_os_admin;

prompt El usuario j_admin podra otorgar el rol web_admin_rol
prompt Conectando como j_admin
connect j_admin/j_admin
grant web_admin_rol to j_os_admin;

prompt Verificando privilegios de j_os_admin
prompt Conectando como sys
connect sys/system1 as sysdba

prompt consultando privilegios para j_os_admin
col grantee format A20
col granted_role format A40
select grantee, granted_role, admin_option
from dba_role_privs
where grantee = 'J_OS_ADMIN';

prompt Limpieza
drop user j_admin;
drop user j_os_admin;
drop role web_admin_rol;
drop role web_root_rol;

