prompt Conectando como sysdba 
connect sys/system2 as sysdba 

prompt Creando un usuario userJava

declare
    v_count number;
begin
    select count(*) into v_count
    from all_users
    where username = 'USERJAVA';
    if v_count >0 then
        execute immediate 'drop user userJava cascade';
    end if;
end;
/

create user userJava identified by userJava quota unlimited on users;
grant create session, create table, create procedure to userJava;

prompt Otorgando permisos para ejecutar procedimiento con java 

begin 
  dbms_java.grant_permission( 'USERJAVA',
    'java.util.PropertyPermission','*', 'read,write');
  dbms_java.grant_permission( 'USERJAVA',
    'java.util.PropertyPermission','*','read');
  dbms_java.grant_permission( 'USERJAVA',
    'SYS:java.lang.RuntimePermission', 'getClassLoader', ' ' );
  dbms_java.grant_permission( 'USERJAVA', 
    'SYS:oracle.aurora.security.JServerPermission', 'Verifier', ' ' );
  dbms_java.grant_permission( 'USERJAVA', 
    'SYS:java.lang.RuntimePermission',
    'accessClassInPackage.sun.util.calendar', ' ' );
  dbms_java.grant_permission( 'USERJAVA', 
    'java.net.SocketPermission', '*', 'connect,resolve' );
  dbms_java.grant_permission( 'USERJAVA', 
    'SYS:java.lang.RuntimePermission', 'createClassLoader', ' ');
  dbms_java.grant_permission( 'USERJAVA', 
    'SYS:java.io.FilePermission', '/tmp/paisaje.png', 'read');
  dbms_java.grant_permission( 'USERJAVA', 
    'SYS:java.io.FilePermission', '/tmp/output-paisaje.png', 'read,write,delete');
end;
/